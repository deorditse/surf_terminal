# ADR-0002: Use Flutter BLoC and Freezed for workflow state

Status: Accepted
Date: 2026-09-26

## Context

SSH sessions are state machines with asynchronous transitions: connecting, host-key verification, authentication, connected operation, reconnecting, disconnecting, and failure. The UI needs deterministic transitions, explicit user intent, cancellable operations, and testable concurrency. Session state must not depend on mutable widget state.

Terminal output is a high-frequency byte stream. Treating every output chunk as application state would create excessive allocations, rebuilds, and unbounded state growth.

## Decision

Use `flutter_bloc` for user-visible workflows and SSH session control. Use Freezed sealed unions for immutable BLoC events, BLoC states, entities, and failures when union/copy semantics provide value.

Use `bloc_concurrency` deliberately: `droppable` for repeated connect/submit actions, `restartable` for superseded searches or validation, and `sequential` when ordering is required.

BLoC stores control-plane state only. Raw SSH output flows through a session adapter directly into the xterm terminal buffer. Dependencies are injected through BLoC constructors.

## Alternatives

- **Riverpod.** It is capable and testable, but BLoC was selected because Surf Terminal benefits from explicit event/state transitions for SSH lifecycle workflows.
- **Provider/ChangeNotifier.** Rejected because complex asynchronous transitions and concurrency rules become implicit and mutation-oriented.
- **Store terminal output in BLoC state.** Rejected because it would rebuild at stream frequency and retain an ever-growing transcript.
- **StatefulWidget as the session owner.** Rejected because transport lifecycle and reconnect rules would be tightly coupled to widget lifecycle.

## Consequences

Session transitions become observable and unit-testable. Concurrency behavior is explicit, and UI rendering is separated from raw terminal throughput.

The project takes on BLoC event/state boilerplate and Freezed code generation. Developers must keep high-frequency data out of global state and dispose each session BLoC and stream scope correctly.
