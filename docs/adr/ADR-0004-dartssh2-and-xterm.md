# ADR-0004: Use dartssh2 and xterm behind project contracts

Status: Accepted
Date: 2026-09-26

## Context

Surf Terminal needs an SSH implementation that works in Dart/Flutter on iOS and Android and a terminal emulator that supports interactive shell behavior, keyboard input, selection, ANSI sequences, and PTY resizing.

Binding presentation directly to package-specific SSH objects would make the transport difficult to replace or fake. Mobile operating systems can suspend or terminate background TCP connections, so the design must expose connection loss and recovery rather than promise an always-alive session.

## Decision

Use `dartssh2` for SSH transport, authentication, shell channels, and PTY operations. Hide it behind domain-owned session and repository contracts; dartssh2 types do not escape the data layer.

Use `xterm` as the terminal emulator and high-frequency terminal buffer. Route SSH output through a session stream adapter directly into xterm instead of storing output in global BLoC state. Route terminal input and debounced resize events through the session adapter to the active shell/PTY.

Each terminal tab owns a unique session scope containing its identifier, BLoC/controller, SSH session, shell channel, xterm buffer, subscriptions, and cleanup.

## Alternatives

- **Implement SSH natively on each platform.** Rejected because it duplicates protocol integration, increases platform code, and complicates testing.
- **Use a backend SSH gateway.** Rejected for the initial product because it changes the trust model, requires server infrastructure, and sends credentials or sessions through a third party.
- **Build a custom terminal renderer.** Rejected because terminal emulation and ANSI/PTY behavior are complex and outside the product's differentiating scope.
- **Expose dartssh2 objects to BLoC/UI.** Rejected because it couples architecture to one package and prevents simple fake transports.

## Consequences

The project gains a pure-Dart SSH path and an established terminal buffer while keeping replacement and test seams. Multi-session ownership and PTY resizing are explicit.

The application depends on dartssh2 and xterm behavior and must test adapter boundaries carefully. Background sessions can disconnect; reconnect is bounded, cancellable, and visible to the user. Package upgrades require adapter-level regression tests.
