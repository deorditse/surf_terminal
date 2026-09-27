# Surf Terminal Engineering Guide

This file is the authoritative engineering contract for people and AI agents working in this repository. It defines the required workflow, architecture, security boundaries, stack, and quality gates for the Flutter SSH client.

Normative words **MUST**, **MUST NOT**, **SHOULD**, and **MAY** are intentional. If a task needs an exception, propose it through OpenSpec before implementation. The rationale for accepted architectural choices lives in [`docs/adr/`](docs/adr/README.md).

## 1. Mandatory OpenSpec workflow

Every change to source code, dependencies, configuration, platform projects, tests, or project documentation MUST use OpenSpec.

### Workflow

```text
request
  → show the proposed OpenSpec command, purpose, and expected effect
  → obtain approval for planning writes
  → create or update proposal/spec/design/tasks
  → show validation results and planned scope
  → obtain explicit approval for apply
  → implement only the approved scope
  → verify and report actual command results
  → obtain explicit approval before archive
```

### Command visibility and approval gates

Before running an OpenSpec command, show:

1. the exact command;
2. why it is needed;
3. whether it is read-only or writes state;
4. its expected effect.

Read-only discovery commands MAY run after this announcement without another approval. Examples:

```bash
openspec list --json
openspec context --json
openspec status --change "<change>" --json
openspec show "<spec>" --type spec
openspec instructions <artifact> --change "<change>" --json
openspec validate "<change>" --strict
```

Explicit user approval is REQUIRED before:

- creating a change;
- creating or editing planning artifacts;
- applying a change;
- archiving a change;
- destructive or irreversible operations.

Approval for proposal/planning is not approval for apply. Approval for apply is not approval for archive.

If implementation reveals a material scope, behavior, architecture, compatibility, security, or acceptance-criteria change, STOP. Show the required planning update and obtain approval before editing OpenSpec artifacts or continuing implementation.

## 2. Architecture

Use **single-package layout Clean Architecture**. Surf Terminal is one Flutter application whose domain, data, business logic, and presentation responsibilities are explicit `*_layout` directories under `lib/`.

### Target structure

```text
lib/
├── main.dart
├── domain_layout/            # pure Dart entities, failures and contracts
├── data_layout/              # SSH, persistence and platform adapters
├── business_layout/          # BLoCs, use cases and policies
└── ui_layout/
    ├── app/                  # bootstrap, DI, lifecycle, router and theme
    ├── pages/                # explicit routed surfaces and local modules
    └── shared/               # genuinely reused presentation components
```

### Dependency direction

```text
business_layout ─────→ domain_layout ←───── data_layout
                               ↑
                  ui_layout composes all layers
```

Rules:

- `lib/domain_layout` MUST be pure Dart and MUST NOT import Flutter, BLoC, GetIt, persistence, secure storage, dartssh2, xterm, or platform APIs.
- `lib/domain_layout` owns entities, value objects, repository/session contracts, failures, result types, and business policies.
- `lib/data_layout` depends only on domain layout. It implements domain contracts and contains DTOs, mappers, persistence adapters, secure-storage adapters, SSH adapters, and platform integrations.
- `lib/business_layout` depends only on domain layout. It owns BLoCs, events, states, use cases, and orchestration policies; it MUST NOT import data layout.
- `lib/ui_layout/app/di` is the only place allowed to construct concrete data implementations or resolve them with GetIt.
- Pages MUST receive BLoCs/controllers through constructor or provider composition and MUST NOT construct infrastructure dependencies.
- Dependencies `business_layout → data_layout`, `data_layout → business_layout`, `domain_layout → Flutter`, page → data layout, and hidden service-locator access outside the composition root are prohibited and MUST be covered by an architecture test.
- Every routed surface belongs under `lib/ui_layout/pages/<page>/`; page-specific widgets stay with their page. Move a component to `lib/ui_layout/shared` only after genuine cross-page reuse.

### Use cases

Create a use case when it contains a business rule, coordinates multiple repositories, enforces security/policy, or is reused. Do not wrap a one-line repository call in a mechanical use-case class solely to satisfy a diagram.

## 3. Approved stack

The project uses Flutter 3.47.5 and Dart 3.13.4. The following snapshot was resolved together with `flutter pub get` on 2026-09-26. Before changing `pubspec.yaml`, query the current stable compatible versions again; the snapshot is not permission to skip dependency resolution.

The compatibility probe reported all direct runtime dependencies up to date. For development dependencies, `freezed 4.0.1` is the newest mutually resolvable version in this graph even though `4.0.2` is published.

### Runtime dependencies

| Package | Version | Role |
|---|---:|---|
| `flutter_bloc` | `^9.1.1` | UI workflow and session state |
| `bloc_concurrency` | `^0.3.0` | explicit event concurrency |
| `freezed_annotation` | `^3.1.0` | immutable models and sealed unions |
| `json_annotation` | `^4.12.0` | JSON annotations for persisted DTOs |
| `get_it` | `^9.3.0` | composition-root dependency container |
| `go_router` | `^18.0.1` | navigation |
| `dartssh2` | `^4.1.0` | SSH transport, authentication, shell and PTY |
| `xterm` | `^4.0.0` | terminal emulator and terminal buffer |
| `flutter_secure_storage` | `^11.2.0` | secrets in Keychain/Keystore-backed storage |
| `sqflite` | `^2.4.4` | direct SQLite persistence for structured non-secret data |
| `path_provider` | `^2.1.6` | application filesystem locations |
| `uuid` | `^4.6.0` | stable profile and session identifiers |
| `logger` | `^2.8.0` | diagnostics behind a redacting wrapper |

### Development dependencies

| Package | Version | Role |
|---|---:|---|
| `freezed` | `^4.0.1` | compatible Freezed generator selected by the resolver |
| `json_serializable` | `^6.14.1` | JSON code generation |
| `build_runner` | `^2.16.1` | code-generation runner |
| `bloc_test` | `^10.0.0` | BLoC tests |
| `mocktail` | `^1.0.5` | mocks where fakes are impractical |
| `flutter_lints` | `^6.0.0` | baseline static-analysis rules |
| `flutter_test` | Flutter SDK | unit and widget testing |
| `integration_test` | Flutter SDK | device integration testing |

Dependency rules:

- NEVER use `any` in committed `pubspec.yaml` files.
- Do not add `dependency_overrides` unless a temporary incompatibility is documented with reason, owner/removal condition, and an OpenSpec/ADR reference.
- Prefer SDK packages and existing dependencies over adding overlapping libraries.
- Commit `pubspec.lock` for this application.
- A dependency change is incomplete until `flutter pub get`, `flutter pub outdated`, analysis, and tests have been run and reported.

## 4. State management

Use Flutter BLoC for user-visible workflows and SSH session control.

- Events and states MUST be immutable and SHOULD use Freezed sealed unions.
- Model lifecycle states explicitly rather than with unrelated booleans.
- Inject dependencies through the BLoC constructor.
- NEVER call `GetIt.I`, a global service locator, secure storage, sqflite, or dartssh2 directly from a BLoC.
- Side effects belong behind domain contracts and data implementations.
- Use `bloc_concurrency` intentionally:
  - `droppable()` for repeated connect/submit actions that must not overlap;
  - `restartable()` for superseded searches or validation;
  - `sequential()` when order is part of correctness;
  - default concurrent handling only when operations are independent.
- Close BLoCs, subscriptions, SSH sessions, shell channels, stream controllers, and database handles at the scope that owns them.

## 5. SSH session model

A session MUST expose an implementation-independent domain contract. `dartssh2` types MUST NOT escape the data layer.

Minimum lifecycle states:

```text
Disconnected
Connecting
VerifyingHost
Authenticating
Connected
Reconnecting
Disconnecting
ConnectionFailed
```

Session rules:

- Each terminal tab owns a unique `sessionId`, session BLoC/controller, SSH session, shell channel, terminal buffer, and cleanup scope.
- Connect, disconnect, reconnect, authentication, and host-verification transitions MUST be explicit and testable.
- User-requested disconnect MUST cancel reconnect attempts.
- Reconnect policies MUST be bounded and cancellable; do not implement infinite silent retries.
- PTY dimensions MUST track xterm dimensions. Resize requests SHOULD be debounced and forwarded to the remote PTY.
- Assume iOS and Android may suspend or terminate TCP connections in background. Never promise an indefinitely persistent background SSH session.
- On foreground resume, detect stale transport and expose an explicit reconnect path.

### Terminal data path

Raw terminal output is high-frequency data and MUST NOT be appended to a growing global BLoC state.

```text
SSH shell stdout/stderr
  → session stream adapter
  → xterm Terminal buffer
  → terminal widget repaint
```

BLoC state contains control-plane information only: lifecycle status, profile/session identifiers, verification prompts, recoverable errors, and user-visible metadata.

Terminal input flows from xterm to the active shell channel through the session adapter. Flow control, UTF-8 boundaries, binary data, resize, and disposal MUST be handled without rebuilding the whole application for every chunk.

## 6. Security

Security requirements are not optional acceptance criteria.

### Secrets

- Passwords, private keys, key passphrases, and sensitive tokens MUST be stored only in `flutter_secure_storage` or held in memory for the minimum necessary lifetime.
- SQLite stores only non-secret profile data and opaque references to secure entries.
- Secrets MUST NOT appear in BLoC states, Freezed `toString()`, logs, analytics, crash reports, exceptions shown to users, fixtures, screenshots, or persisted terminal history.
- Clear temporary secret buffers/references as soon as practical.
- Do not persist terminal transcripts by default. Any future transcript feature requires a separate threat model, OpenSpec change, and ADR.

### Host-key verification

- NEVER use unconditional acceptance such as `onVerifyHostKey: (...) => true`.
- Store known-host entries separately from credentials with host, port, algorithm, fingerprint, first-seen, and last-confirmed metadata.
- For an unknown host, pause before authentication and show the fingerprint for explicit user confirmation.
- For a mismatched known host, block the connection and display a high-severity warning. Do not offer a default one-tap silent replacement.
- Updating or deleting a known-host record requires an explicit user action and audit-friendly UI copy.

### Logging

All diagnostics go through a redacting logger wrapper. Redact at minimum:

- passwords and passphrases;
- private-key material;
- authorization data;
- raw keyboard input;
- terminal output unless an explicitly approved diagnostic mode says otherwise;
- user-controlled connection strings that embed secrets.

Release logging MUST be minimal. Debug logging MUST still obey redaction.

## 7. Persistence

Use sqflite as the direct SQLite adapter for connection profiles, labels, known-host metadata, snippets, non-secret settings, and non-sensitive session metadata. Use secure storage for secret values.

- Database tables, SQL, migrations, and persisted DTOs belong only in `packages/data`.
- Domain entities MUST NOT carry sqflite types or persistence annotations.
- Map DTOs to domain entities explicitly.
- Keep an explicit schema version. Every schema change MUST have an ordered transactional `onCreate`/`onUpgrade` migration and tests from each supported prior version.
- Enable and test foreign-key constraints. Repository integration tests MUST cover transactions, rollback, uniqueness, and referential integrity.
- Repositories expose domain contracts and convert storage/library exceptions to typed failures.
- Coordinate profile deletion with deletion of referenced secure-storage entries and handle partial failure explicitly.
- Avoid SharedPreferences for structured domain data. It MAY be used only for trivial UI preferences when SQLite would add no value and the choice is documented.

## 8. Errors and Result

Use a small sealed `Result<T, Failure>` abstraction or an equivalent project-defined type.

- Domain failures describe meaning, not vendor exception classes.
- Catch library and platform exceptions at the data boundary.
- Preserve stack traces for redacted diagnostics.
- Map failures to localized user messages in presentation.
- Do not catch `Error` as recoverable application behavior.
- Never expose raw exception strings that may contain secrets or infrastructure details.

Suggested failure families include validation, authentication, host-key, transport, timeout, protocol, storage, permission, cancellation, and unexpected failures.

## 9. Models and code generation

- Use Freezed for immutable domain entities, DTOs, BLoC events, and BLoC states when unions/copy semantics provide value.
- Use `json_serializable` only for serialized DTOs; domain entities do not require JSON by default.
- Keep DTOs and mappers in the data layer.
- Generated files (`*.freezed.dart`, `*.g.dart`, and configured generator output) MUST NOT be edited manually.
- Do not create placeholder generated directories or files. A global `lib/generated` directory is allowed only when a configured generator writes there.
- Commit generated application files consistently.

Generate code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

After changing annotated types, regenerate before analysis and tests.

## 10. Navigation and UI

Use `go_router`. Initial route areas are:

```text
/connections
/connections/new
/connections/:profileId/edit
/terminal/:sessionId
/sftp
/snippets
/snippets/new
/snippets/:snippetId/edit
/known-hosts
/settings
```

- Route parameters MUST use stable identifiers, not full serialized models.
- Resolve data after navigation through a BLoC/use case/repository.
- Keep screens declarative; business rules do not belong in widgets.
- Extract reusable UI only after real reuse or a stable design-system need appears.
- Terminal UI MUST preserve focus, keyboard behavior, selection, text scaling policy, and safe-area behavior on both iOS and Android.

## 11. Testing strategy

Prefer fakes over mocks for domain contracts and transports.

### Unit tests

Cover:

- domain policies and value objects;
- BLoC transitions and event concurrency;
- reconnect/cancellation behavior;
- host-key decisions;
- mappers and failure conversion;
- redaction;
- database migrations.

### Contract and integration tests

- Run repository contracts against fake/in-memory and real local implementations where practical.
- Test SSH adapters against a controlled local/test SSH server or deterministic fake transport, never an unstable public server.
- Test secure-storage behavior behind an adapter; do not require real user secrets.

### Widget tests

Cover critical flows:

- create/edit a connection profile;
- first-use host-key confirmation;
- changed-host-key warning;
- authentication and connection failures;
- terminal connect/disconnect/reconnect controls;
- session-tab ownership and disposal.

Every bug fix MUST include a regression test unless the OpenSpec explicitly documents why a deterministic test is impossible.

## 12. ADR policy

Significant architecture decisions MUST be recorded in [`docs/adr/`](docs/adr/README.md).

Create an ADR when choosing or changing:

- an architectural pattern or layer boundary;
- a primary framework/library with long-term coupling;
- persistence or security policy;
- a protocol/transport abstraction;
- a cross-feature contract;
- a quality or delivery governance rule.

Do not create an ADR for local implementation details that do not affect long-term boundaries, public contracts, security, data, or maintainability.

Naming:

```text
ADR-NNNN-kebab-case-title.md
```

Numbers are sequential and never reused. Do not rewrite accepted history. When a decision changes, create a new ADR, mark the old ADR `Superseded`, and link both documents.

## 13. Definition of done

A change is complete only when all approved OpenSpec tasks are complete and the relevant checks pass.

Required commands:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

When dependencies change:

```bash
flutter pub get
flutter pub outdated
```

When generated sources change:

```bash
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- '*.freezed.dart' '*.g.dart'
```

Also verify:

- no secrets or sensitive terminal content are logged or persisted;
- dependency direction remains valid;
- resources and sessions are disposed;
- new significant decisions have ADRs;
- documentation and OpenSpec tasks match actual behavior;
- actual command output is reported; success is never inferred from intent.
