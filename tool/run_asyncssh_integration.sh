#!/bin/sh
set -eu

REPOSITORY=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SCRATCH_ROOT=${HERMES_SCRATCH_DIR:-"$HOME/.hermes/profiles/my-projects/cache/scratch"}
VENV=${SURF_ASYNCSSH_VENV:-"$SCRATCH_ROOT/surf-terminal-asyncssh-venv"}
PYTHON="$VENV/bin/python"

if [ "${1:-}" = "--bootstrap" ]; then
  if [ ! -x "$PYTHON" ]; then
    python3 -m venv "$VENV"
  fi
  "$PYTHON" -m pip install --disable-pip-version-check asyncssh
  shift
fi

if [ "$#" -ne 0 ]; then
  printf '%s\n' 'usage: tool/run_asyncssh_integration.sh [--bootstrap]' >&2
  exit 64
fi

if [ ! -x "$PYTHON" ] || ! "$PYTHON" -c 'import asyncssh' >/dev/null 2>&1; then
  printf '%s\n' 'AsyncSSH prerequisite missing from the Hermes scratch venv.' >&2
  printf '%s\n' 'Run: tool/run_asyncssh_integration.sh --bootstrap' >&2
  exit 69
fi

cd "$REPOSITORY"
exec "$PYTHON" tool/asyncssh_loopback_harness.py
