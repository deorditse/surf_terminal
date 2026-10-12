# Surf Terminal Engineering Guide

This file is the authoritative engineering contract for people and AI agents working in this repository. It defines the required workflow, architecture, security boundaries, presentation rules, and quality gates for the Flutter SSH client.

Normative words **MUST**, **MUST NOT**, **SHOULD**, and **MAY** are intentional. Canonical behavior lives in `openspec/specs/`; long-term rationale lives in accepted records under `docs/adr/`; `rules.md` is a shorter operational checklist and MUST NOT override this guide.

## 1. Mandatory OpenSpec workflow

Changes to source code, dependencies, configuration, platform projects, tests, project documentation, or engineering governance MUST use OpenSpec.

```text
request
  → announce discovery/planning commands and their effect
  → obtain approval for planning writes
  → create or update proposal/specs/design/tasks
  → validate and show the planned scope
  → obtain explicit apply approval
  → implement only the approved scope
  → verify with real command/device evidence
  → decide “ready for archive approval” or “continue work”
  → obtain explicit approval before archive
```

Before an OpenSpec command, show the exact command, purpose, whether it writes state, and expected effect. Read-only discovery MAY run after that announcement. Explicit approval is REQUIRED before creating a change, writing planning artifacts, applying a change, archiving, or performing destructive actions.

Planning approval is not apply approval. Apply approval is not archive approval. Never rewrite an existing active change merely because the project default schema changed.

If implementation reveals a material scope, behavior, architecture, security, compatibility, migration, or acceptance change, STOP and update planning through a separately approved write before continuing.

## 2. Repository shape and dependency direction

Surf Terminal is one Flutter package using explicit `*_layout` Clean Architecture directories:

```text
lib/
├── main.dart
├── domain_layout/            # pure Dart entities, values, failures, contracts
├── data_layout/              # SSH, persistence, secure-storage, platform adapters
├── business_layout/          # BLoCs, use cases, workflow policies
└── ui_layout/
    ├── app/                  # bootstrap, DI, lifecycle, router, theme
    ├── pages/                # routed surfaces and page-local widgets
    └── shared/               # genuinely reused presentation components
```

Dependency direction:

```text
business_layout ─────→ domain_layout ←───── data_layout
                               ↑
                  ui_layout composes all layers
```

Rules:

- `domain_layout` MUST remain pure Dart. It MUST NOT import Flutter, BLoC, persistence, secure storage, dartssh2, xterm, or platform APIs.
- `domain_layout` owns entities, value objects, failures, result types, repository/session contracts, and business/security policies.
- `data_layout` depends on domain only. It owns DTOs, mappers, sqflite, protected storage, dartssh2, and platform adapters.
- `business_layout` depends on domain only. It owns BLoCs, events, states, use cases, and workflow orchestration; it MUST NOT import data layout.
- `ui_layout/app/di` is the composition root for concrete adapters. Use explicit constructor/provider wiring; do not hide infrastructure lookup in pages or BLoCs.
- Pages MUST consume business/domain APIs and MUST NOT import concrete data adapters.
- Each routed surface belongs under `ui_layout/pages/<page>/`. Keep page-specific widgets there; move a widget to `ui_layout/shared` only after real reuse.
- The architecture boundary test under `test/architecture/` MUST cover prohibited imports and composition-root access.

Create a use case when it contains a business rule, coordinates multiple contracts, enforces a policy, or is reused. Do not add mechanical one-line wrappers only to satisfy a diagram.

## 3. Current stack

`pubspec.yaml` and `pubspec.lock` are the source of truth. The current project uses:

- Flutter/Dart;
- `bloc`, `flutter_bloc`, and `bloc_concurrency` for workflows;
- `freezed_annotation`, `freezed`, and `build_runner` for immutable unions/generated code;
- `go_router` for navigation;
- `dartssh2` behind domain contracts for SSH;
- a pinned xterm.dart Git revision for terminal emulation;
- `sqflite` for structured non-secret data and `sqflite_common_ffi` in tests;
- `flutter_secure_storage` for secrets;
- `liquid_glass_widgets` only for approved compact overlay controls;
- `flutter_test` and `integration_test` for automated/device coverage.

Dependency rules:

- NEVER commit `any` constraints or an unreviewed `dependency_overrides` workaround.
- Prefer SDK capabilities and existing dependencies over overlapping packages.
- Commit `pubspec.lock` for this application.
- Dependency changes require an approved OpenSpec scope, `flutter pub get`, `flutter pub outdated`, analysis, tests, and platform build evidence where applicable.
- Do not assume a dependency exists because it appeared in an older guide; inspect `pubspec.yaml` and neighbouring imports first.

## 4. BLoC and workflow state

Use explicit `Bloc<Event, State>` for user-visible workflows and SSH session control.

- Events and states MUST be immutable and SHOULD use Freezed sealed unions where the project already uses generated unions.
- Model lifecycle states explicitly rather than with unrelated booleans.
- Dependencies enter through constructors/providers.
- BLoCs MUST NOT access concrete SSH, sqflite, protected storage, or global locators directly.
- Side effects belong behind domain contracts and data adapters.
- Choose event concurrency intentionally: `droppable()` for duplicate submits/connects, `restartable()` for superseded searches/validation, `sequential()` when order is correctness, and concurrent handling only for independent work.
- Reject stale async completions when the selected profile/session/request has changed.
- Close BLoCs, subscriptions, SSH sessions, shell channels, stream controllers, terminals, and database handles at the scope that owns them.

High-frequency terminal bytes are not growing BLoC state. Stream shell output to the session-owned xterm buffer; keep control-plane lifecycle, IDs, prompts, and recoverable errors in workflow state.

## 5. SSH and terminal invariants

`dartssh2` types MUST NOT escape `data_layout`. A session contract exposes project-defined domain types.

Minimum lifecycle concepts include disconnected, connecting, host verification, authenticating, connected, reconnecting, disconnecting, and failed.

- Every terminal tab owns a unique session ID, workflow/controller, SSH connection, shell channel, terminal buffer, and cleanup scope.
- Connect/disconnect/reconnect/authentication/host-verification transitions MUST be explicit and testable.
- User disconnect cancels reconnect. Retry policies MUST be bounded and cancellable.
- PTY dimensions follow xterm dimensions; resize forwarding SHOULD be debounced.
- Mobile suspension can invalidate sockets. On resume, detect stale transport and expose a clear reconnect path instead of promising permanent background SSH.
- Software and hardware Enter MUST send one carriage return byte (`13`) to the active terminal.
- Preserve terminal focus while overlay controls are used unless the action intentionally moves focus.
- Remote/SSH errors shown in the terminal MUST preserve their original meaning and useful detail. Redact only secret material; do not replace actionable errors with generic text.

## 6. Security and secrets

Security requirements are mandatory acceptance criteria.

### Secret storage

- Passwords, private keys, key passphrases, and sensitive tokens belong only in protected storage or short-lived memory.
- SQLite stores non-secret profile/known-host/settings data and opaque references to secret entries.
- Secrets MUST NOT appear in BLoC states, generated `toString()`, logs, analytics, crash reports, fixtures, screenshots, terminal-history persistence, or user-visible diagnostics.
- Do not persist terminal transcripts by default. Such a feature requires its own threat model, OpenSpec change, and ADR.

### Host verification

- Production code MUST NOT unconditionally accept host keys.
- Unknown hosts pause before authentication and require explicit fingerprint confirmation.
- Mismatched known hosts block connection with a high-severity warning; do not silently replace trust records.
- Known-host metadata and credentials remain separate.
- Updating/removing trust records requires an explicit user action.

### Diagnostics

- Sanitize credentials, private-key material, authorization values, and input that may contain secrets.
- Preserve stack traces and transport context only in a redacted diagnostic path.
- Never log raw terminal output by default.
- Release diagnostics stay minimal; debug mode still obeys redaction.

## 7. Persistence

Use sqflite directly in `data_layout` for structured non-secret data and protected storage for secret values.

- Tables, SQL, persisted DTOs, mappers, and migrations belong in `lib/data_layout/`.
- Domain entities MUST NOT carry sqflite types or persistence annotations.
- Map persisted DTOs to domain entities explicitly.
- Keep an explicit schema version. Schema changes require ordered transactional migrations and tests from every supported previous version.
- Enable/test foreign keys, uniqueness, transactions, rollback, and referential integrity.
- Convert storage/library exceptions to typed domain failures at the adapter boundary.
- Coordinate deletion of a profile with deletion of its referenced protected secret and specify partial-failure recovery.

## 8. Models and generated code

- Use Freezed for immutable entities, DTOs, events, and states where unions/copy semantics are useful and consistent with neighbouring code.
- Generated files (`*.freezed.dart`, `*.g.dart`, and configured generator output) MUST NOT be edited manually.
- Do not create placeholder generated directories or empty generated files.
- After annotation changes run:

```bash
dart run build_runner build
```

- Verify generation produced a non-empty expected inventory and a second run is reproducible.

## 9. Cupertino-first presentation

The root application MUST use `CupertinoApp.router`. Visible application chrome SHOULD use Cupertino widgets. A narrowly scoped Material compatibility wrapper is allowed only when an existing package or API requires it; it MUST NOT turn the app shell into `MaterialApp` or introduce Material-looking chrome.

Terminal presentation rules:

- terminal sessions use a strict dark background continuous with the page background;
- the terminal occupies the maximum available screen area with minimal insets;
- top/session controls may overlay terminal content instead of reserving a colored rectangle;
- terminal controls remain compact and icon-only when the icon is understandable;
- management app bars are transparent and content scrolls beneath them;
- preserve focus, selection, software keyboard, IME resize, safe areas, and text scaling behavior on iOS and Android;
- maintain semantics/tooltips for icon-only controls;
- golden changes require an approved visual behavior change and visual review, not blind image regeneration.

Use project colors/tokens from the live theme. Do not introduce a second visual system in a page-local change.

## 10. Navigation

Use `go_router` and stable IDs in route parameters. Do not serialize entire models into routes. Resolve data after navigation through BLoCs/use cases/repositories.

Current route families include connections, terminal sessions, snippets, known hosts, and settings. Inspect the live router before adding or changing paths. A route contract change requires usage search, tests, compatibility analysis, and OpenSpec approval.

## 11. Test-first implementation

Deterministic production behavior MUST use `RED → GREEN → REFACTOR`.

1. Add the smallest focused automated scenario.
2. Run it and observe the expected failure caused by missing/incorrect behavior.
3. Implement the smallest approved slice.
4. Run the focused GREEN test and relevant regressions.
5. Refactor only while tests remain green.

A defect fix starts with a reproducing regression test. A test that passes before implementation is not RED evidence.

Meaningful exceptions are limited to generated output, documentation/configuration where no deterministic behavior exists, one-off spikes, or environment-gated device/external behavior. The exception and substitute evidence MUST be explicit in `design.md` and `tasks.md`; a skipped device smoke is never reported as passed.

Use the narrowest applicable layers:

- pure Dart/unit tests for values, policies, mappers, redaction, and failures;
- BLoC tests for transitions, concurrency, cancellation, and stale events;
- repository/adapter tests for sqflite, protected storage, and SSH boundaries;
- architecture tests for dependency direction;
- widget/golden tests for UI, focus, overlays, and lifecycle states;
- `integration_test` or a disposable localhost SSH harness for real boundaries;
- device/emulator checks for keyboard, IME, lifecycle, and platform behavior.

Never use real user credentials or an unstable public SSH server in automated tests.

## 12. ADR policy

Read `docs/adr/README.md` and applicable accepted ADRs before a significant design change.

Create a new ADR when changing a long-term architecture boundary, primary coupled library, persistence/security policy, protocol abstraction, cross-feature contract, or governance rule. Do not create one for a local implementation detail. Never rewrite accepted history; supersede it with a new numbered ADR and cross-links.

OpenSpec does not automatically create ADRs. The change design/tasks must explicitly create or update the record when required.

## 13. Editing and repository safety

- Keep edits inside the approved scope and do not revert unrelated user changes.
- Inspect definitions and all usages before changing a symbol or contract.
- Match neighbouring style; avoid drive-by renames, formatting, or refactors.
- Do not commit, push, rewrite history, or run destructive Git commands unless requested.
- Do not read, print, or commit secrets and credential files.
- Never claim a check passed without real command output.
- A structural OpenSpec validation is not proof that guidance matches the repository; also verify paths, dependencies, commands, and forbidden stale terms.

## 14. Definition of done

A change is complete only when every approved task has evidence and applicable checks pass.

Default repository gates:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Additional gates as applicable:

```bash
dart run build_runner build
flutter pub get
flutter pub outdated
flutter build apk --debug
flutter build ios --debug --no-codesign
openspec validate "<change>" --strict
```

Also verify:

- no secrets or sensitive terminal content were logged/persisted;
- dependency direction and composition-root boundaries remain valid;
- resources/sessions/subscriptions are disposed;
- generated output is reproducible;
- required adapter/platform/device evidence is recorded separately;
- documentation, ADRs, specs, and task checkboxes match actual behavior;
- unrelated working-tree changes remain untouched;
- the final report explicitly says either **ready for separate archive approval** or **continue work**.
