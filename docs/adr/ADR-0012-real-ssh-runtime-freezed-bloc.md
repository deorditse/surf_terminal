# ADR-0012: Real SSH runtime with Freezed BLoC workflows

Status: Accepted
Date: 2026-09-27

Related decisions: [ADR-0002](ADR-0002-flutter-bloc-and-freezed.md), [ADR-0004](ADR-0004-dartssh2-and-xterm.md), [ADR-0008](ADR-0008-sqflite-and-secure-storage.md)

## Context

Surf Terminal must replace its offline terminal preview with real password-authenticated SSH sessions while preserving strict layout boundaries, explicit trust decisions, protected credentials, responsive terminal streaming, and reliable mobile text input. The existing prototype uses feature Cubits and synchronous in-memory repositories, which do not make asynchronous event ordering, cancellation, persistence failures, or reconnect behavior explicit enough for a transport state machine.

The app also needs user-created profiles to survive restarts, remembered passwords to remain outside ordinary storage, unknown and changed host keys to be handled safely, and terminal output to avoid global state rebuilds.

## Decision

Use Freezed `Bloc<Event, State>` workflows for every feature: profiles, snippets, settings, terminal tabs, and each SSH session. Apply `bloc_concurrency` deliberately: droppable for duplicate submissions and connects, restartable for superseded queries or resize work, and sequential for lifecycle, trust, credential, and cleanup events. Generate `*.freezed.dart` with `build_runner`; generated files are never edited manually and reproducibility is verified by rerunning generation.

Use domain-owned asynchronous contracts for profiles, credentials, known hosts, and SSH sessions. Keep `domain_layout` pure Dart and keep concrete adapters in `data_layout`, instantiated only by `ui_layout/app/di`.

Implement real transport with `dartssh2`. Every production client supplies `onVerifyHostKey`; verification bypass is forbidden. Unknown fingerprints pause the session for explicit trust, known matches continue, and changed fingerprints block authentication until a distinct replacement decision.

Persist non-secret profiles and known-host metadata with `sqflite`. Store only opaque credential references in SQLite. Store remembered passwords with `flutter_secure_storage` using iOS Keychain and Android Keystore-backed encryption. Editing never pre-fills a saved password; replacement and removal are explicit. Profile deletion coordinates structured and secure cleanup and exposes sanitized partial failures.

Render each connected PTY with a session-owned `xterm.Terminal`. Stream output directly into that buffer, not BLoC state. Each tab owns its session BLoC, transport, shell, emulator, subscriptions, retry timers, and a stable `FocusNode`. Tapping the viewport opens the platform software keyboard; toolbar controls preserve terminal focus; dismiss and reopen remain functional.

Use bounded reconnect delays of one, two, and four seconds only after unexpected transport loss. Manual disconnect, host-key rejection/mismatch, authentication failure, and tab closure cancel retries.

Verify with deterministic fake adapters and a disposable loopback OpenSSH environment using generated ephemeral credentials. Never use public servers or commit generated secrets, endpoints, fingerprints, transcripts, or real user data.

## Alternatives

- Keep Cubits for simple features and use Bloc only for SSH. Rejected by the approved project-wide event/state convention and because explicit events improve asynchronous consistency across profile, credential, and session workflows.
- Store terminal output in BLoC state. Rejected because sustained output would create excessive allocation, rebuilding, and unbounded transcript state.
- Silently trust the first host key. Rejected because it hides the trust decision and weakens protection against interception.
- Store encrypted passwords in SQLite. Rejected because application-managed encryption creates a separate key-management problem and violates the accepted secure-storage boundary.
- Prefill remembered passwords in the editor. Rejected because the UI does not need the secret value to indicate availability, preserve it, replace it, or remove it.
- Use a public SSH endpoint for automated verification. Rejected because it introduces external instability and risks credentials or network dependence in tests.

## Consequences

Workflow intent and concurrency become explicit and testable, at the cost of generated code and more event definitions. Code generation becomes a mandatory quality gate.

Real sessions verify server identity, protect remembered passwords, persist non-secret profiles, support interactive PTY input/output, and expose honest reconnect/failure state. TOFU still requires users to compare a first-seen fingerprint with a trusted source when security matters.

SQLite and secure storage cannot participate in one native transaction, so coordinated operations must preserve retryable non-secret cleanup state and test partial failures. Mobile operating systems can still suspend sockets; the app reports loss and attempts bounded recovery rather than promising permanent background connectivity.
