# Design

## Context

See `proposal.md` for motivation. The app currently has synchronous in-memory profile repositories, a password field whose value is discarded, synthetic `PreviewSession` objects, and a terminal-like Flutter widget with fixture text. The active `build-terminal-app-ui` change is separately removing SFTP, demo profiles, light theme paths, and adding branding resources; transport implementation must start from its completed and verified UI baseline rather than reintroduce removed behavior.

Canonical governance fixes the architecture to one Flutter package with `domain_layout`, `business_layout`, `data_layout`, and `ui_layout`, requires explicit session states, secure secret handling, direct terminal streaming, and managed network tests. ADR-0004 already selects `dartssh2` and `xterm`; ADR-0008 selects `sqflite` plus `flutter_secure_storage`. This change implements those accepted choices.

The latest stable compatible releases identified during planning are `dartssh2 4.1.0`, `xterm 4.0.0`, `flutter_secure_storage 11.2.0`, `sqflite 2.4.4`, `flutter_bloc 9.1.1`, `freezed_annotation 3.1.0`, `freezed 4.0.2`, `build_runner 2.16.1`, and `bloc_concurrency 0.3.0` for Flutter 3.47.5 / Dart 3.13.4. Dependency resolution remains an apply-time gate because package metadata and transitive constraints can change.

## Goals / Non-Goals

**Goals:**

- Establish real password-authenticated SSH sessions with mandatory server identity verification.
- Persist non-secret profiles and known-host records while isolating credentials in platform secure storage.
- Open the selected home-screen profile directly into a real interactive terminal.
- Keep transport, persistence, plugins, and terminal-emulator types behind the accepted layout boundaries.
- Verify adapters with deterministic fakes plus a disposable localhost AsyncSSH real-protocol environment, and verify mobile text-input behavior on a physical device or iOS/Android emulator.

**Non-Goals:**

- SFTP, port forwarding, jump hosts, proxies, agent forwarding, cloud sync, biometric lock, or subscription features.
- Private-key/passphrase authentication in the first transport increment; the contracts must permit a later extension without storing key material in SQLite.
- Guaranteed background connectivity while iOS or Android suspends the process.
- Persistent terminal transcripts or command-history synchronization.
- Copying xTerminal branding, assets, source code, or pixel geometry.

## Decisions

### 1. Domain owns asynchronous persistence and session contracts

`ProfilesRepository` becomes asynchronous because SQLite and coordinated secure deletion are asynchronous. Domain adds value types for credential intent, known-host identity, host-key challenges, connection lifecycle, terminal dimensions, and typed SSH failures. It also owns contracts for profile storage, secure credentials, known hosts, and SSH session creation/interaction.

No contract exposes `dartssh2`, `sqflite`, `flutter_secure_storage`, `xterm`, Flutter widgets, database rows, or plugin options. `business_layout` depends only on these domain types. Concrete adapters remain in `data_layout` and are instantiated only by `ui_layout/app/di`.

Alternative: keep synchronous repository methods and hide asynchronous work in callbacks. Rejected because it produces race conditions and prevents honest save/delete failure reporting.

### 2. All feature workflows use Freezed BLoCs with explicit events

Replace the existing `ProfilesCubit`, `SnippetsCubit`, `SettingsCubit`, and `TerminalSessionsCubit` with `ProfilesBloc`, `SnippetsBloc`, `SettingsBloc`, and `TerminalSessionsBloc`. The real connection lifecycle is owned by a session-scoped `SshSessionBloc`. Each workflow defines Freezed sealed `Event` and `State` unions in `business_layout`; widgets dispatch events rather than call mutation methods.

Event concurrency is deliberate and follows ADR-0002:

- `droppable()` for repeated connect, save, retry, and destructive submit events that must not overlap;
- `restartable()` for superseded profile search/filter and resize requests;
- `sequential()` for ordered terminal lifecycle, host-key decisions, credential replacement, and cleanup;
- default concurrent handling only where handlers are demonstrably independent.

Every concrete Freezed event subtype is registered separately with Bloc, for example `on<SettingsLoadRequested>(_onLoadRequested)` and `on<SettingsFontSizeChanged>(_onFontSizeChanged)`. A feature-level `on<SettingsEvent>(_onEvent)` (or equivalent parent-union registration) that dispatches through `switch (event)` is forbidden. Per-subtype registration keeps handler ownership explicit and allows each event to declare its own concurrency transformer. Handlers may delegate repeated persistence or error-mapping mechanics to private helpers, but those helpers do not replace typed event registrations. Architecture tests enforce this convention for every feature BLoC.

Freezed is used for business events/states and for domain unions where exhaustive variants or copy semantics add value. Domain remains pure Dart through `freezed_annotation`; generator and builder packages remain development dependencies. Generated `*.freezed.dart` files are created only by `dart run build_runner build`, are never edited manually, and are verified clean by rerunning generation and checking Git diff.

Alternative: retain Cubits for simple features and use Bloc only for SSH. Rejected at the user's direction because one event/state model across features makes async intent, ordering, tests, and cross-feature conventions explicit.

### 3. SQLite stores profiles and known hosts; secure storage stores passwords

SQLite schema version 1 contains:

- `ssh_profiles`: stable UUID, name, host, port, username, label, non-secret terminal options, opaque credential reference, created/updated timestamps;
- `known_hosts`: normalized host, port, key algorithm, OpenSSH SHA256 fingerprint, first-seen and last-confirmed timestamps, with a uniqueness constraint on endpoint and algorithm.

Foreign keys are enabled. Repository writes are transactional. Database migrations are centralized and tested from every supported schema version once later versions exist.

A password key uses an opaque application namespace plus profile UUID, for example `surf_terminal.ssh.password.<uuid>`. It never includes host, username, label, or password material. `flutter_secure_storage` is configured with an iOS accessibility class suitable for unlocked-device use and Android's current authenticated encryption defaults. Android backup rules exclude secure-storage ciphertext to avoid restoration without the original Keystore key.

Alternative: put encrypted password text in SQLite. Rejected because application-managed encryption creates key-management risk and violates the accepted security rule.

### 4. Password editing uses intent, never secret-prefill

A new password profile shows “Save password securely” enabled by default to satisfy one-tap reconnect while remaining visible and reversible. The actual password stays in the form controller only until save completes. Editing a profile never reads or displays the saved password; it receives only `hasSavedPassword` metadata and offers explicit replace/remove actions. An empty password on edit preserves the existing secure value unless removal was explicitly requested.

Save is coordinated as an application operation. The design records typed partial failures and never claims remember-password success if the secure write failed. Deletion removes secure material and structured profile data in an order that preserves a retryable non-secret cleanup record on partial failure.

Alternative: prefill the saved password. Rejected because it unnecessarily exposes Keychain/Keystore content to long-lived UI state and accessibility tooling.

### 5. `dartssh2` adapter always supplies `onVerifyHostKey`

The adapter connects with `SSHSocket.connect`, constructs `SSHClient` with `onVerifyHostKey`, and never enables `disableHostkeyVerification`. `dartssh2 4.1.0` supplies key algorithm and OpenSSH-style SHA256 fingerprint and permits an asynchronous verifier.

The business session controller turns an unknown fingerprint into a pending `HostKeyChallenge` state. UI shows host, port, algorithm, and fingerprint, then resolves trust or rejection. A match continues immediately. A mismatch blocks; replacing trust requires a distinct high-severity confirmation rather than treating it as first use. Accepted records are persisted before authentication continues.

Alternative: trust on first use silently. Rejected because it provides no meaningful protection against first-connection interception and violates canonical governance.

### 6. One session scope owns lifecycle and transport resources

Each terminal tab has a stable session ID and owns:

- a session-scoped `SshSessionBloc` with Freezed events and states;
- one domain SSH session handle;
- one `xterm.Terminal` buffer in presentation;
- input/output/exit subscriptions;
- resize debounce timer;
- reconnect cancellation token and attempt counter;
- deterministic `close()` cleanup.

Lifecycle state carries metadata only. SSH output is delivered by a byte/text stream adapter directly to the `xterm` buffer. It is not appended to BLoC state. UI input is represented by ordered session events and forwarded to the domain session contract without storing transcript bytes. PTY columns/rows are measured from the viewport and dispatched through restartable/debounced resize handling.

The terminal page owns a dedicated `FocusNode` for the `xterm` input client. Tapping the viewport requests focus and opens the platform text-input connection; keyboard dismissal releases the connection without disposing the terminal, and a later tap can reacquire it. Special-key toolbar controls preserve terminal focus and send their sequences through ordered input events rather than becoming the long-lived text-input target. Widget tests assert focus and keyboard visibility semantics on compact surfaces, while smoke on a physical device or iOS/Android emulator verifies actual platform software-keyboard presentation and resize behavior.

Alternative: keep terminal text in Bloc state. Rejected because sustained output would cause global rebuilds and unbounded state growth.

### 7. Connection selection is immediate but remains honest

Tapping a profile creates a session and navigates to terminal status immediately. If a remembered password exists, connection begins automatically. If absent, the route requests a transient password before authentication. Unknown host-key confirmation can appear on the terminal route while the connection is paused. “Connected” appears only after verified authentication and shell creation.

Edit and delete remain explicit secondary actions so a primary tap is unambiguously “connect”. No profile auto-connects merely because the application launched.

### 8. Reconnect is bounded and excludes security failures

Unexpected loss after a connected state retries at most three times with 1, 2, and 4 second delays. Manual disconnect, authentication rejection, unknown/rejected/changed host key, explicit tab close, and user cancellation never auto-retry. Reconnect re-runs host-key verification and retrieves the credential again rather than retaining it indefinitely.

Alternative: infinite retry. Rejected because it wastes battery, hides failures, and makes user cancellation unreliable.

### 9. Verification combines fakes, a disposable real-protocol server, and mobile targets

Unit and contract tests use fake repositories, secure store, host-key decisions, and transport sessions. A separate integration harness provisions a disposable AsyncSSH server bound strictly to `127.0.0.1`, with generated ephemeral host/user credentials and a random local port. It must skip with an explicit unmet-prerequisite result rather than contact a public server. The real SSH protocol scenario verifies first-use fingerprint capture, remembered-password authentication, command echo/output, PTY resize, disconnect, reconnect boundary, and mismatch rejection without Docker or another local container runtime.

No generated credential, endpoint, transcript, or fingerprint enters committed fixtures, screenshots, goldens, or logs. Final mobile smoke runs on an available physical Android/iOS device or corresponding emulator. A debug-only injected connected-session harness may isolate keyboard, focus, toolbar, dismissal/reopen, and viewport-resize mechanics without credentials; it MUST NOT enter production composition or replace the separate real-protocol adapter test.

The current automated software-keyboard smoke is gated to Android targets because Flutter's iOS `IntegrationTestWidgetsFlutterBinding` does not report real software-keyboard `viewInsets` in this environment, including for a minimal standard `TextField`. Running that target on iOS records an explicit skip before constructing a terminal runtime rather than a false failure. iOS remains covered by the documented manual device/emulator checklist and platform build until a reliable XCTest-backed IME observer is introduced. Test teardown must first replace the mounted app with an empty widget tree and pump deactivation to completion, then close the injected terminal runtime and its BLoC/focus resources. Disposing the runtime while `SessionPane` and `BlocProvider` dependents remain mounted is forbidden because it can trigger Flutter's `_dependents.isEmpty` lifecycle assertion.

## Risks / Trade-offs

- **[Coordinating SQLite and Keychain/Keystore is not a cross-store transaction]** → model save/delete phases explicitly, preserve retryable cleanup metadata, and test each partial failure.
- **[TOFU cannot authenticate the first connection without an out-of-band fingerprint]** → require visible confirmation and recommend comparison with a trusted server source; never silently trust.
- **[Mobile suspension can destroy sockets]** → expose disconnection honestly and use bounded foreground reconnect rather than promising background persistence.
- **[Terminal byte decoding and resize timing can corrupt interaction]** → isolate stream conversion, use emulator APIs, test fragmented UTF-8/ANSI data, and debounce only resize metadata.
- **[Toolbar buttons or route rebuilds can steal terminal focus and prevent the software keyboard from opening]** → own one stable terminal `FocusNode` per tab, request focus on viewport tap, preserve it across lifecycle-only rebuilds, and test dismiss/reopen behavior.
- **[Latest plugin versions can require platform changes]** → resolve dependencies before implementation, inspect generated platform requirements, and verify both Android and iOS builds.
- **[AsyncSSH availability can vary across environments]** → keep it isolated in a scratch virtual environment, skip explicitly when unavailable, and retain deterministic adapter tests; never fall back to a public server.
- **[A physical device can be disconnected or unavailable]** → permit the same software-keyboard smoke on an iOS/Android emulator while preserving the physical-device path for later release testing.
- **[Flutter integration bindings expose platform IME metrics inconsistently]** → gate the automated inset assertion to the verified Android instrumentation path, skip before runtime construction on unsupported iOS binding runs, retain the iOS manual checklist, and unmount the test widget tree before disposing injected dependencies.
- **[The current UI change is partially applied]** → complete and verify `build-terminal-app-ui` first; do not layer transport code onto a failing or structurally stale baseline.

## Migration Plan

1. Complete and verify the already approved `build-terminal-app-ui` implementation; request its separate archive approval when done.
2. Reconfirm dependency versions and resolve transport, persistence, Bloc concurrency, Freezed annotation/generator, and build-runner packages without overrides.
3. Add Freezed/domain contracts and value types, replace every feature Cubit with explicit Bloc events/states, register each concrete event subtype with its own typed handler, generate code, and migrate business APIs to asynchronous persistence using fakes first.
4. Add SQLite schema/repositories, secure credential adapter, known-host repository, and migration/partial-failure tests.
5. Add the `dartssh2` adapter and fake transport contract tests, including mandatory host-key verification.
6. Replace synthetic terminal sessions with per-tab runtime scopes and integrate `xterm` streaming/input/resize.
7. Update profile editor, home connect flow, trust dialogs, status/retry/disconnect, and secret-removal UX.
8. Apply Android/iOS network and secure-storage configuration and verify platform builds.
9. Run the disposable localhost AsyncSSH integration test and documented physical-device or emulator smoke checklist.
10. If rollback is required, disable construction of production adapters in the composition root while preserving schema and secure entries; never migrate passwords into ordinary storage.

## Open Questions

None. Private-key authentication, jump hosts, proxies, and background session guarantees are intentionally deferred capabilities rather than unresolved decisions for this increment.
