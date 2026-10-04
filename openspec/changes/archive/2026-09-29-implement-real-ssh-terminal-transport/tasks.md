# Tasks

## 1. Baseline and dependency gates

- [x] 1.1 Complete and verify the separately approved `build-terminal-app-ui` change before transport edits; confirm its SFTP removal, empty SSH state, dark theme, splash, icons, tests, and platform builds are green
- [x] 1.2 Capture Git status and inventory profile/session/editor/terminal/platform files; classify unrelated user changes and verify no generated or protected file will be edited manually
- [x] 1.3 Re-query stable package metadata for `dartssh2`, `xterm`, `flutter_secure_storage`, `sqflite`, `freezed_annotation`, `freezed`, `build_runner`, and `bloc_concurrency`, add exact compatible constraints without `any` or overrides, and verify `flutter pub get` succeeds on Flutter 3.47.5 / Dart 3.13.4
- [x] 1.4 Create ADR-0012 documenting concrete transport, trust, credential, persistence, Freezed Bloc workflows, event concurrency, code generation, and test-harness decisions; verify ADR-0002, ADR-0004, and ADR-0008 remain accepted and update the ADR index

## 2. Domain contracts and business lifecycle

- [x] 2.1 Add pure-Dart profile persistence, credential intent/reference, known-host, host-key challenge, session lifecycle, terminal-dimension, and typed SSH failure values using Freezed where union/copy semantics add value; verify domain tests cover exhaustive variants and invariants without Flutter or plugin imports
- [x] 2.2 Convert profile repository operations to asynchronous domain contracts and add secure-credential, known-host, and SSH session contracts; verify architecture tests reject data/plugin types crossing the boundary
- [x] 2.3 Add Freezed annotations/generators and `bloc_concurrency`, define the generation command, and verify generated `*.freezed.dart` files are reproducible and never manually edited
- [x] 2.4 Replace `ProfilesCubit` with `ProfilesBloc` plus Freezed events/states for asynchronous load/save/delete and droppable submits; verify first launch, persistence reload, pending, success, and partial-failure transitions
- [x] 2.5 Replace `SnippetsCubit` and `SettingsCubit` with Freezed event/state BLoCs using explicit sequential/restartable policies; verify existing workflows and failure paths through event-driven tests
- [x] 2.6 Replace `TerminalSessionsCubit` with `TerminalSessionsBloc` and implement a session-scoped `SshSessionBloc` covering disconnected, connecting, verifying, authenticating, connected, reconnecting, and failed; verify every legal transition and stale-event rejection
- [x] 2.7 Implement unknown-key and changed-key decisions as sequential Freezed events resolving a cancellable pending challenge; verify authentication cannot begin before acceptance and rejection closes the attempt
- [x] 2.8 Implement bounded reconnect events with 1, 2, and 4 second delays, droppable duplicate connects, and cancellation; verify success, exhausted retries, manual disconnect, authentication failure, and host-key failure using a fake clock/transport
- [x] 2.9 Replace every feature-level parent-event registration and `switch (event)` dispatcher with one typed `on<ConcreteEventSubtype>` registration and handler per Freezed event variant; assign concurrency transformers per subtype, preserve behavior through focused BLoC tests, and add an architecture test preventing regression

## 3. Structured profile and known-host persistence

- [x] 3.1 Add centralized SQLite database opening with foreign keys, schema versioning, transactional create/upgrade paths, and an injectable database factory; verify schema creation in an isolated test database
- [x] 3.2 Implement profile row mapping and repository CRUD for all supported non-secret fields plus opaque credential references; verify save, update, reload, ordering, empty defaults, constraints, and rollback
- [x] 3.3 Implement endpoint-scoped known-host persistence for host, port, algorithm, fingerprint, first-seen, and last-confirmed; verify exact match, unknown host, endpoint change, and mismatch queries
- [x] 3.4 Add migration tests for every supported schema version and malformed/duplicate records; verify migrations are transactional and secrets never appear in database schema or rows
- [x] 3.5 Add coordinated profile deletion and retryable cleanup metadata; verify successful deletion and secure-store partial-failure recovery without exposing secret values

## 4. Secure credential storage

- [x] 4.1 Implement a `flutter_secure_storage` adapter behind the domain credential contract with opaque UUID-based keys; verify tests never encode host, username, label, or password into key identifiers
- [x] 4.2 Implement save, read-for-authentication, replace, remove, and availability operations; verify plugin failures map to typed sanitized failures and no secret enters state or logs
- [x] 4.3 Configure iOS Keychain accessibility/entitlements required by the selected plugin and Android Keystore-backed defaults plus backup exclusion; verify platform files and plugin registration without weakening encryption
- [x] 4.4 Add a repository-wide secret scan and targeted tests for source, fixtures, golden assets, diagnostics, SQLite rows, and serialized Freezed states; verify no password/passphrase/private-key fixture or emitted value exists

## 5. Real SSH transport adapter

- [x] 5.1 Implement the `dartssh2` socket/client adapter with timeouts, keepalive, password callback, and mandatory `onVerifyHostKey`; verify production construction never omits the verifier or enables host-key verification bypass
- [x] 5.2 Map OpenSSH SHA256 fingerprint challenges to known-host lookups and business decisions; verify first-use accept/reject, known match, changed fingerprint block, and explicit replacement paths
- [x] 5.3 Implement password authentication and sanitized exception mapping for DNS, TCP timeout, negotiation, host key, authentication, PTY, shell, remote exit, and cancellation failures; verify contract tests cover each mapping
- [x] 5.4 Implement remote PTY/shell open, output stream, input sink, resize, exit observation, and idempotent close; verify fragmented UTF-8/ANSI bytes, write-after-close protection, and resource cleanup
- [x] 5.5 Wire concrete SQLite, secure storage, known-host, and SSH adapters only in `lib/ui_layout/app/di`; verify pages, BLoCs, domain, and business files contain no concrete data/plugin imports

## 6. Profile and trust user experience

- [x] 6.1 Update the connection editor with visible “Save password securely” behavior defaulted on for new password profiles, saved-password metadata, and explicit replace/remove actions; verify actual saved passwords are never prefilled or revealed
- [x] 6.2 Coordinate profile and credential save so secure-storage failure cannot falsely advertise remembered authentication; verify new, edit, preserve-empty, replace, disable-retention, and removal widget flows
- [x] 6.3 Make primary profile selection create a session and connect immediately when a remembered password exists; verify edit/delete remain separate actions and no profile connects merely on app launch
- [x] 6.4 Add a transient password prompt when no saved credential is available, with optional secure retention; verify cancellation creates no connection and password text is absent from route arguments and serialized state
- [x] 6.5 Add unknown-host and changed-host-key dialogs showing endpoint, algorithm, and fingerprint; verify first trust, rejection, mismatch block, and distinct explicit replacement confirmation
- [x] 6.6 Surface safe connection/authentication errors and cleanup failures with retry actions; verify messages remain actionable without revealing secret availability or credential contents

## 7. Interactive terminal integration

- [x] 7.1 Replace synthetic terminal rendering with a session-owned `xterm.Terminal` viewport for connected sessions while retaining progress/error surfaces; verify fixture output never appears after a real connection starts
- [x] 7.2 Stream remote output directly into the correct terminal buffer and route ordered emulator-input events to the active SSH shell; verify sustained output does not append transcript data to Freezed Bloc state or trigger whole-app rebuilds
- [x] 7.3 Send initial PTY columns/rows and debounced orientation/keyboard/layout resize updates; verify final dimensions reach only the active session
- [x] 7.4 Add one stable terminal `FocusNode` per tab so tapping the viewport opens the software keyboard, toolbar controls preserve focus, dismiss closes it, and a later tap reopens it; verify focus/input/resize behavior in compact widget tests
- [x] 7.5 Wire Escape, Control combinations, Alt combinations, Tab, arrows, paste, and keyboard dismissal to emulator/session APIs; verify byte sequences and session isolation in widget/controller tests
- [x] 7.6 Add visible lifecycle status, endpoint identity, retry/reconnect, and disconnect actions; verify connected is shown only after verified authentication and successful shell creation
- [x] 7.7 Make each tab own and close its SSH client, shell, emulator buffer, focus node, subscriptions, retry timer, and transient credential scope; verify two simultaneous fake sessions cannot cross input, output, status, focus, or resize events
- [x] 7.8 Handle app background/foreground and remote shell exit honestly; verify lost sessions become disconnected/reconnecting and no background-alive guarantee is presented

## 8. Platform and integration verification

- [x] 8.1 Add Android Internet permission and required secure-storage backup policy plus iOS network/Keychain configuration; verify Debug Android and iOS Simulator builds link all plugins
- [x] 8.2 Create and run a disposable AsyncSSH real-protocol harness bound strictly to `127.0.0.1` with generated ephemeral host/user credentials and a random port; verify it uses no Docker or public server, commits no generated secrets, passes the production-adapter scenario, and leaves no process behind
- [x] 8.3 Run real-adapter integration coverage for unknown fingerprint acceptance, remembered-password authentication, shell command/output, PTY resize, disconnect, and known-host repeat connection; verify all assertions pass
- [x] 8.4 Rotate the disposable server host key and verify the persisted fingerprint mismatch blocks authentication until explicit replacement; verify no automatic overwrite occurs
- [x] 8.5 Interrupt the disposable transport and verify bounded reconnect, manual cancellation, retry exhaustion, and cleanup behavior; verify no orphan socket/process remains
- [x] 8.6 Document and execute an Android/iOS physical-device or emulator smoke covering viewport tap-to-open keyboard, typing, toolbar focus retention, dismiss/reopen, and keyboard-driven PTY resize; use a debug-only injected connected session when needed so no credentials enter chat, command arguments, logs, screenshots, or repository files, and record only redacted outcomes
- [x] 8.7 Gate the automated real-IME/inset smoke to the verified Android instrumentation path, skip unsupported iOS binding runs before creating runtime resources, and unmount/pump the widget tree before disposing the injected terminal registry; verify Android remains green, iOS reports a clean explicit skip, and neither target triggers Flutter's `_dependents.isEmpty` lifecycle assertion

## 9. Final quality and reconciliation

- [x] 9.1 Update architecture tests for plugin boundaries, mandatory host-key verification, no serialized secrets, terminal-stream separation, Freezed generation, and absence of feature Cubit classes; verify all boundary and security tests pass
- [x] 9.2 Audit route pages and handwritten Dart files; verify route pages remain within 150 lines and other files within 200 unless a documented exception is approved
- [x] 9.3 Run Freezed generation, formatting, `git diff --check`, dependency resolution, full Flutter tests, rerun generation to prove a clean diff, and the physical ASCII-path analyze workaround; verify every mandatory command exits successfully
- [x] 9.4 Run Android debug and iOS Simulator builds after clean dependency resolution; verify no missing permission, entitlement, plugin registration, or native link error remains
- [x] 9.5 Compare implementation against all four capability specs and canonical governance; verify password-only scope, TOFU limitations, reconnect limits, and deferred key/jump/proxy features are represented honestly
- [x] 9.6 Mark tasks complete only from recorded evidence, run `openspec validate "implement-real-ssh-terminal-transport" --strict`, and request a separate archive approval without archiving automatically
