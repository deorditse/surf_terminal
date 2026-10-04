# Tasks

## 1. Revised TDD regression coverage

- [ ] 1.1 Add a failing widget test that submits the transient password dialog, pumps its full dismissal animation and proves no disposed `TextEditingController` framework exception occurs; run it and record the expected RED from the current caller-owned controller lifecycle.
- [ ] 1.2 Add a failing widget test with independently controlled runtime-start and profile-save futures proving `Connect` opens the terminal and exposes centered `Connecting` before profile persistence completes; run it and record the expected RED from current save-before-runtime ordering.
- [ ] 1.3 Add a failing orchestration test proving DNS/transport/authentication failure does not cancel the pending profile save and the profile remains reloadable after that save succeeds; run it and record RED.
- [ ] 1.4 Add a failing orchestration/widget test proving profile or permanent secure-storage save failure reports a safe persistence error without closing, cancelling or replacing the already-started SSH lifecycle; run it and record RED.
- [ ] 1.5 Add failing credential-policy tests proving the first attempt receives only a transient opaque reference, remember-enabled persistence creates a distinct permanent opaque reference, remember-disabled persistence stores no reference, and neither assertion reads a secret value; run them and record RED.
- [ ] 1.6 Add a failing runtime-registry/widget test proving a second connection awaits cleanup of the previous transport, focus resources and transient credential and leaves exactly one active runtime/session; run it and record RED.
- [ ] 1.7 Add failing workspace tests proving server tabs and the persistent status row are absent, setup states render a centered `CircularProgressIndicator` plus lifecycle label, failure is centered/actionable, and connected xterm expands above the retained special-key toolbar; run them and record RED.
- [ ] 1.8 Add or retain a failing regression proving `Edit host → Save` updates the same profile identity, never pre-fills password and opens no SSH session; run it and confirm any failure reflects revised behavior rather than setup.
- [ ] 1.9 Add failing pure-Dart parser tests for accepted Tailscale user-auth banners and rejection of alternate schemes, lookalike hosts, user info, ports, query/fragment, malformed paths, multiple URLs and missing markers; use only fictional opaque tokens and record RED.
- [ ] 1.10 Add failing adapter/orchestration tests proving a trusted banner enters waiting-for-external-authentication, launches only through an injected external-browser contract, keeps the raw URI out of routes/BLoC/persistence/logs and continues the original attempt after approval; run and record RED.
- [ ] 1.11 Add failing lifecycle tests proving app resume does not duplicate a still-pending attempt, a dead attempt gets at most one fresh fully verified retry, and cancel or a second failure suppresses retry and erases the ephemeral challenge; run and record RED.
- [ ] 1.12 Add failing Connections widget tests for both empty and populated states proving exactly one `Add host` action exists in the AppBar, no connection FAB or empty-state create button exists, and stale preview/offline copy is absent; run and record RED.
- [ ] 1.13 Add a failing stateful-shell route-transition regression reproducing the default `FloatingActionButton` Hero-tag assertion and proving mounted branches expose no duplicate Hero tag; run and record RED.
- [ ] 1.14 Add failing visual/widget coverage proving management screens use the dark ocean/cyan/teal Surf tokens while terminal setup/connected/failure surfaces remain flat dark, monospace and free of waves, gradients, cards and preview badges; run and record RED.

## 2. Connect-first and lifecycle-safe implementation

- [ ] 2.1 Replace caller-owned transient password controller lifecycle with a dialog-owned state/value lifecycle and verify task 1.1 turns GREEN without timing delays.
- [ ] 2.2 Add an app-composed connect/persist orchestration boundary that outlives the editor route, keeps constructor/Pure DI boundaries intact and exposes only non-secret outcomes; verify architecture tests and task 1.2 turn GREEN.
- [ ] 2.3 Implement new-profile connect-first ordering: validate, prepare first-attempt transient credential, replace/open runtime and terminal route, then start independent persistence for the same stable profile identity; verify runtime creation occurs while controlled save is still pending.
- [ ] 2.4 Continue profile/credential-policy persistence regardless of SSH success or failure, refresh SSH home only after successful save and report persistence failure separately without cancelling transport; verify tasks 1.3 and 1.4 turn GREEN.
- [ ] 2.5 Implement remembered and non-remembered branches with separate transient/permanent opaque references, promptly clear form ownership and preserve deterministic transient cleanup; verify task 1.5 plus credential coordinator tests turn GREEN.
- [ ] 2.6 Serialize single-session replacement in the runtime registry and terminal-session workflow so old runtime cleanup completes before the replacement opens; verify task 1.6 turns GREEN under rapid duplicate submissions.
- [ ] 2.7 Remove `TerminalSessionTabs` and the persistent `SessionStatusBar` from production composition, bind the route directly to its requested runtime and verify no inaccessible background session remains.
- [ ] 2.8 Implement mutually exclusive centered lifecycle/failure surfaces and an expanded connected terminal viewport with the existing bottom special-key toolbar; verify task 1.7 turns GREEN with no synthetic delay or output.
- [ ] 2.9 Preserve saved-profile prompting and `Edit host → Save` behavior without password disclosure or implicit connection; verify task 1.8 and saved-profile connection tests turn GREEN.
- [ ] 2.10 Update only affected terminal/host-editor goldens after visual review confirms the approved full-screen layout, centered progress and absence of secret/user endpoint content; rerun golden tests without update mode.
- [ ] 2.11 Extend the SSH backend boundary and `DartSsh2Backend` to consume `onUserauthBanner` without logging banner content, and verify unrecognized banners cannot trigger browser launch.
- [ ] 2.12 Implement the strict Tailscale challenge parser and runtime-scoped ephemeral challenge coordinator with opaque references and deterministic clearing on success, cancel, failure, replacement and disposal; turn task 1.9 GREEN.
- [ ] 2.13 Add an injected UI-owned external system browser launcher, resolve a stable compatible `url_launcher` constraint without overrides, and keep plugin imports out of domain/business/data layers; turn the launch portion of task 1.10 GREEN.
- [ ] 2.14 Add waiting-for-external-authentication to the typed Freezed SSH lifecycle handlers and centered terminal UI without storing the raw banner/URI in event or state; implement open-again and cancel actions and turn task 1.10 GREEN.
- [ ] 2.15 Replace the fixed authentication deadline with ordinary/challenge-aware bounded timeout ownership and implement observe-first app-resume handling plus one fresh verified retry only after stale cleanup; turn task 1.11 GREEN.
- [ ] 2.16 Remove the Connections FAB and empty-state create callback/button, retain only the AppBar `Add host` action in empty and populated states, and turn task 1.12 GREEN.
- [ ] 2.17 Give any remaining mounted-shell FAB a stable feature-specific `heroTag` or disable Hero participation, then exercise the original transition path and turn task 1.13 GREEN.
- [ ] 2.18 Refine management screens with reusable dark ocean surfaces, restrained cyan/teal accents, thin outlines and a subtle non-terminal wave/gradient motif; remove `Local preview`, offline/mock copy and oversized promotional hierarchy without changing terminal composition.
- [ ] 2.19 Keep terminal setup, connected and failure composition on a standard flat black/dark-charcoal surface with monospace xterm, minimal chrome and no management decoration; turn task 1.14 GREEN.

## 3. Persistence and mobile lifecycle evidence

- [ ] 3.1 Verify SQLite round-trip stores supported non-secret fields and only permanent opaque credential references while platform secure storage owns remembered secrets and runtime cleanup owns transient references; run repository, adapter and cleanup tests.
- [ ] 3.2 Extend Android profile lifecycle integration to prove terminal navigation/connection starts before a controlled profile save completes, the profile survives reload even after a failed connection, and `Edit host` updates the same identity without capturing endpoint, password or transcript data.
- [ ] 3.3 Run the revised lifecycle smoke on an available Android emulator or physical device and record GREEN evidence; unmount and pump the widget tree before disposing app/runtime resources.
- [ ] 3.4 Verify the password dialog submit/dismiss path on a mobile runtime or integration binding and confirm no red framework error occurs during the reverse animation.
- [ ] 3.5 Extend Android lifecycle integration with an injected fictional Tailscale challenge to prove external-browser handoff, centered waiting state, resume without duplicate transport, bounded stale-attempt retry and challenge cleanup without screenshotting or logging the URI.

## 4. Real SSH and security verification

- [ ] 4.1 Run the localhost AsyncSSH harness against production `DartSshSessionFactory` and verify host-key challenge, authentication, PTY shell, disconnect, replacement cleanup and reconnect behavior pass without Docker or orphan processes.
- [ ] 4.2 Verify the UI cannot show connected or the interactive xterm before host-key verification, authentication and PTY/shell creation, while connecting/verifying/authenticating/reconnecting each expose centered progress.
- [ ] 4.3 Scan routes, BLoC states/events, persistence records, fixtures, screenshots, goldens and diagnostics for password/passphrase/private-key material and screenshot-derived endpoints; verify no secret was introduced.
- [ ] 4.4 Verify persistence failure leaves the active transport untouched and session replacement/close deletes transient credentials through focused failure and registry cleanup tests.
- [ ] 4.5 Extend the localhost AsyncSSH substitute to emit a fictional Tailscale-style user-auth banner and gate authentication, then verify the production adapter observes the challenge and the same transport reaches PTY/shell after release; do not use real Tailscale infrastructure or Docker.
- [ ] 4.6 Verify rejected banner variants never invoke the browser launcher and that all challenge success/cancel/failure/replacement paths erase raw banner/URI ownership.
- [ ] 4.7 Scan routes, typed BLoC events/states, persistence, secure storage, logs, crash diagnostics, fixtures, screenshots and goldens for one-time authentication URLs and challenge tokens in addition to SSH credential material.

## 5. Contract retirement and scope reconciliation

- [ ] 5.1 Verify all five delta specs preserve complete modified canonical requirement blocks, remove both tabbed-workspace and synthetic/offline requirements with explicit migrations, and retain the mobile toolbar plus honest current-run settings scope.
- [ ] 5.2 Inspect the canonical-after-archive projection and prove it contains one full-screen active session, centered lifecycle progress and connect-first independent persistence without stale save-before-connect, server-tab, offline-preview or mock-terminal behavior.
- [ ] 5.3 Scan production UI for stale `Local preview`, `offline preview`, `mock terminal`, `synthetic terminal`, duplicate host-create affordances, connection FAB, persistent session tabs/status row and profile `текущего запуска` behavior; document intentional test-only fake terminology separately.
- [ ] 5.4 Confirm archived changes and accepted ADR files remain unchanged by this revision through a scoped git diff review.

## 6. Final quality gates

- [ ] 6.1 Run focused password dialog, connection orchestration, credential coordinator, repository, runtime registry, workspace, session, single-create-action, Hero-transition, terminal-presentation, Tailscale parser/external-auth coordinator and architecture tests; all must pass.
- [ ] 6.2 Run `dart run build_runner build`, verify a non-empty generated-file inventory is hash-stable, run formatting checks, the full Flutter suite and `dart analyze lib test integration_test tool`; all must pass without generated drift.
- [ ] 6.3 Run the Android browser/resume lifecycle smoke, Android debug APK and iOS Simulator no-codesign build; the smoke and both builds must succeed after the revised implementation.
- [ ] 6.4 Enforce handwritten Dart size limits, run `git diff --check`, scan for debug logging and verify unrelated pre-existing working-tree changes were not overwritten.
- [ ] 6.5 Run `openspec validate "save-and-connect-ssh-profile" --strict`, inspect apply instructions/status and mark only tasks backed by fresh evidence for this revision complete.
