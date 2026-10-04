#!/usr/bin/env python3
"""Run the real Dart SSH adapter against an in-process localhost AsyncSSH server."""

from __future__ import annotations

import asyncio
import contextlib
import json
import logging
import os
from pathlib import Path
import secrets
import shutil
import sys
import tempfile
from typing import Any

import asyncssh

_LOOPBACK = "127.0.0.1"


class _PasswordServer(asyncssh.SSHServer):
    def __init__(self, harness: "_LoopbackHarness") -> None:
        self._harness = harness
        self._connection: asyncssh.SSHServerConnection | None = None

    def connection_made(self, connection: asyncssh.SSHServerConnection) -> None:
        peer = connection.get_extra_info("peername")
        if not peer or peer[0] != _LOOPBACK:
            connection.abort()
            return
        self._connection = connection
        self._harness.connections.add(connection)

    def connection_lost(self, exc: Exception | None) -> None:
        if self._connection is not None:
            self._harness.connections.discard(self._connection)

    def begin_auth(self, username: str) -> bool:
        return True

    def password_auth_supported(self) -> bool:
        return True

    def validate_password(self, username: str, password: str) -> bool:
        return secrets.compare_digest(username, self._harness.username) and secrets.compare_digest(
            password, self._harness.password
        )


class _LoopbackHarness:
    def __init__(self, control_directory: Path) -> None:
        self.control_directory = control_directory
        self.username = secrets.token_urlsafe(18)
        self.password = secrets.token_urlsafe(32)
        self.host_key = asyncssh.generate_private_key("ssh-ed25519")
        self.connections: set[asyncssh.SSHServerConnection] = set()
        self.listener: asyncssh.SSHAcceptor | None = None
        self.port = 0
        self._control_task: asyncio.Task[None] | None = None
        self._process_tasks: set[asyncio.Task[Any]] = set()
        self._closed = False

    async def start(self) -> None:
        await self._start_listener()
        self._control_task = asyncio.create_task(self._watch_controls())

    async def _start_listener(self) -> None:
        self.listener = await asyncssh.create_server(
            lambda: _PasswordServer(self),
            _LOOPBACK,
            self.port,
            server_host_keys=[self.host_key],
            process_factory=self._process,
            reuse_address=True,
        )
        if self.port == 0:
            self.port = self.listener.get_port()

    async def _stop_listener(self, *, abort_connections: bool) -> None:
        listener = self.listener
        self.listener = None
        if listener is not None:
            listener.close()
        if abort_connections:
            for connection in tuple(self.connections):
                connection.abort()
            await asyncio.sleep(0)
        if listener is not None:
            await listener.wait_closed()

    async def _process(self, process: asyncssh.SSHServerProcess[str]) -> None:
        task = asyncio.current_task()
        if task is not None:
            self._process_tasks.add(task)
        self._write_dimensions(*process.get_terminal_size()[:2])
        try:
            while True:
                try:
                    data = await process.stdin.read(4096)
                except asyncssh.TerminalSizeChanged as change:
                    self._write_dimensions(change.width, change.height)
                    continue
                if not data:
                    break
                process.stdout.write(data)
                await process.stdout.drain()
        except (asyncssh.ConnectionLost, BrokenPipeError, OSError):
            pass
        finally:
            with contextlib.suppress(Exception):
                process.exit(0)
            if task is not None:
                self._process_tasks.discard(task)

    def _write_dimensions(self, columns: int, rows: int) -> None:
        destination = self.control_directory / "pty-size.json"
        temporary = self.control_directory / "pty-size.pending"
        temporary.write_text(
            json.dumps({"columns": columns, "rows": rows}), encoding="utf-8"
        )
        os.replace(temporary, destination)

    async def _watch_controls(self) -> None:
        while not self._closed:
            for request in sorted(self.control_directory.glob("*.request")):
                parts = request.name.split(".")
                if len(parts) != 3:
                    request.unlink(missing_ok=True)
                    continue
                try:
                    await self._handle_control(parts[1])
                except Exception as error:
                    failure = request.with_name(f"{parts[0]}.{parts[1]}.error")
                    failure.write_text(type(error).__name__, encoding="utf-8")
                else:
                    ack = request.with_name(f"{parts[0]}.{parts[1]}.ack")
                    ack.touch(exist_ok=True)
                request.unlink(missing_ok=True)
            await asyncio.sleep(0.02)

    async def _handle_control(self, command: str) -> None:
        if command == "interrupt":
            for connection in tuple(self.connections):
                connection.abort()
            await asyncio.sleep(0)
        elif command == "pause":
            await self._stop_listener(abort_connections=True)
        elif command == "resume":
            if self.listener is None:
                await self._start_listener()
        elif command == "rotate":
            await self._stop_listener(abort_connections=True)
            self.host_key = asyncssh.generate_private_key("ssh-ed25519")
            await self._start_listener()
        else:
            raise RuntimeError("Unsupported sanitized harness control command")

    async def close(self) -> None:
        if self._closed:
            return
        self._closed = True
        if self._control_task is not None:
            self._control_task.cancel()
            with contextlib.suppress(asyncio.CancelledError):
                await self._control_task
        await self._stop_listener(abort_connections=True)
        for task in tuple(self._process_tasks):
            task.cancel()
        if self._process_tasks:
            await asyncio.gather(*self._process_tasks, return_exceptions=True)
        self.connections.clear()
        self.username = ""
        self.password = ""
        self.host_key = None  # type: ignore[assignment]


async def _run() -> int:
    logging.disable(logging.CRITICAL)
    repository = Path(__file__).resolve().parents[1]
    scratch_root = Path(
        os.environ.get(
            "HERMES_SCRATCH_DIR",
            Path.home() / ".hermes/profiles/my-projects/cache/scratch",
        )
    ).resolve()
    scratch_root.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(
        prefix="surf-terminal-asyncssh-", dir=scratch_root
    ) as temporary:
        control_directory = Path(temporary) / "control"
        control_directory.mkdir(mode=0o700)
        harness = _LoopbackHarness(control_directory)
        process: asyncio.subprocess.Process | None = None
        try:
            await harness.start()
            environment = os.environ.copy()
            environment.update(
                {
                    "SURF_ASYNCSSH_TEST": "1",
                    "SURF_ASYNCSSH_HOST": _LOOPBACK,
                    "SURF_ASYNCSSH_PORT": str(harness.port),
                    "SURF_ASYNCSSH_USERNAME": harness.username,
                    "SURF_ASYNCSSH_PASSWORD": harness.password,
                    "SURF_ASYNCSSH_CONTROL_DIR": str(control_directory),
                    "TMPDIR": str(scratch_root),
                }
            )
            process = await asyncio.create_subprocess_exec(
                "flutter",
                "test",
                "test/integration/asyncssh_real_adapter_test.dart",
                cwd=repository,
                env=environment,
            )
            return_code = await process.wait()
            if return_code != 0:
                watcher = harness._control_task
                if watcher is not None and watcher.done() and not watcher.cancelled():
                    error = watcher.exception()
                    if error is not None:
                        print(
                            f"Harness control watcher stopped: {type(error).__name__}",
                            file=sys.stderr,
                        )
                pending = sorted(
                    path.name.split(".")[1]
                    for path in control_directory.glob("*.request")
                    if len(path.name.split(".")) == 3
                )
                if pending:
                    print(
                        f"Pending sanitized harness controls: {', '.join(pending)}",
                        file=sys.stderr,
                    )
                control_states = sorted(
                    ".".join(path.name.split(".")[1:])
                    for path in control_directory.iterdir()
                    if len(path.name.split(".")) == 3
                )
                if control_states:
                    print(
                        f"Sanitized harness control states: {', '.join(control_states)}",
                        file=sys.stderr,
                    )
            return return_code
        finally:
            if process is not None and process.returncode is None:
                process.terminate()
                with contextlib.suppress(asyncio.TimeoutError):
                    await asyncio.wait_for(process.wait(), timeout=3)
                if process.returncode is None:
                    process.kill()
                    await process.wait()
            await harness.close()


def main() -> int:
    try:
        return asyncio.run(_run())
    except KeyboardInterrupt:
        return 130
    except Exception:
        print("AsyncSSH localhost harness failed before the Dart test started.", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
