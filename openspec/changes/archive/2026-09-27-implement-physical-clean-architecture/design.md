# Design

## Context

Surf Terminal is a single mobile application. Its architecture needs visible responsibility boundaries, but it does not need independently resolvable libraries. The earlier design chose `packages/domain`, `packages/business_logic` and `packages/data`; implementation was interrupted after the user clarified that application-owned layers belong directly under `lib/` and should use the `*_layout` naming used by the Gigalegal reference.

The useful parts of the references remain: Gigalegal's explicit layout naming and page/module structure, and Apteka's responsibility separation and constructor injection. Surf Terminal does not copy Gigalegal's `business_layout → data_layout`, Flutter-dependent domain models or service-locator access inside BLoC.

## Goals / Non-Goals

**Goals:**

- Express all application layers as first-class directories in one Flutter package.
- Keep domain code Flutter-free and business logic independent of concrete data.
- Replace the global `AppCubit` with feature-specific Cubits.
- Make dependencies reviewable through public barrels and executable import-boundary tests.
- Preserve current UI behavior and safe fictional fixtures.
- Reconcile partial files from the interrupted package-based apply without touching unrelated user changes.

**Non-Goals:**

- Reusable or separately published packages.
- Nested package manifests or a Dart workspace.
- Real SSH/SFTP transport, persistence, secure storage or platform lifecycle adapters.
- Choosing Hive versus another persistence mechanism.
- Introducing GetIt or editing generated files.

## Decisions

### 1. One Flutter package with four named layouts

```text
surf_terminal/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── domain_layout/
│   │   ├── domain_layout.dart
│   │   └── src/
│   │       ├── entities/
│   │       ├── failures/
│   │       ├── repositories/
│   │       └── value_objects/
│   ├── business_layout/
│   │   ├── business_layout.dart
│   │   └── src/
│   │       ├── connections/
│   │       ├── terminal/
│   │       ├── sftp/
│   │       ├── snippets/
│   │       └── settings/
│   ├── data_layout/
│   │   ├── data_layout.dart
│   │   └── src/
│   │       ├── datasources/
│   │       ├── mappers/
│   │       └── repositories/
│   └── ui_layout/
│       ├── app/
│       │   ├── di/
│       │   ├── router/
│       │   └── theme/
│       ├── pages/
│       └── shared/
└── test/
    ├── architecture/
    ├── domain_layout/
    ├── business_layout/
    ├── data_layout/
    └── ui_layout/
```

There is one root `pubspec.yaml`. Layout code imports public barrels with `package:surf_terminal/<layout>/<layout>.dart`; implementation files inside a layout may use relative imports. No `pubspec.yaml`, workspace entry or path dependency is created beneath `lib/`.

### 2. Dependency direction remains strict

```text
business_layout ───→ domain_layout
 data_layout ──────→ domain_layout
 ui_layout ────────→ domain_layout + business_layout + data_layout
```

Additional constraints:

- `domain_layout` imports only Dart SDK libraries that do not expose Flutter/platform concerns.
- `business_layout` may import `bloc` and `domain_layout`, never `data_layout`, Flutter widgets or DI.
- `data_layout` may import `domain_layout`, never `business_layout` or `ui_layout`.
- only `ui_layout/app/di` imports concrete `data_layout` implementations;
- pages import domain/business APIs, not data implementations;
- no feature component resolves dependencies globally.

Because one manifest cannot enforce these edges, `test/architecture/layout_boundaries_test.dart` scans Dart imports and fails on forbidden directions. This test is a required quality gate.

### 3. Domain owns Flutter-free concepts and contracts

`domain_layout` owns `SshProfile`, `CommandSnippet`, `PreviewSession`, terminal preference values, SFTP values, typed failures and repository/session contracts. Visual mappings such as terminal palette colors remain in `ui_layout`.

Entities are immutable. Generation is used only when valuable for unions/value semantics; layer separation alone does not require Freezed output.

### 4. Business logic is feature-owned

`business_layout` owns independent `ProfilesCubit`, `TerminalSessionsCubit`, `SftpCubit`, `SnippetsCubit` and `SettingsCubit` components. Repository-backed Cubits receive domain contracts through constructors. The root `AppCubit` and shared cross-feature state are removed after migration.

The root manifest declares a direct compatible `bloc` dependency because business code imports `package:bloc`, while widgets use `flutter_bloc` in `ui_layout`.

### 5. Data owns replaceable adapters

`data_layout` contains deterministic in-memory repositories and fictional fixtures for the current preview. Its public barrel exports only concrete implementations required by composition; datasource details remain under `src` and are not consumed by UI or business logic.

No fixture contains a password, passphrase, private key, real host or real user data. Future persistence, secure-storage and SSH adapters implement the same domain contracts under separately approved changes.

### 6. UI layout is presentation and composition

The existing `lib/ui` tree migrates to `lib/ui_layout`. `lib/ui_layout/app/di/app_dependencies.dart` creates concrete repositories and injects their abstractions into feature Cubits. `SurfTerminalApp` provides independently owned Cubits through `MultiBlocProvider`.

Routed surfaces remain under `lib/ui_layout/pages/<page>`. Route-level page files target 150 lines, ordinary handwritten Dart files target 200 lines unless a documented cohesion reason justifies more. Feature-specific sections, dialogs and widgets stay beside their page.

### 7. Interrupted package implementation is reconciled during apply

The currently untracked `packages/*` files and root workspace/path entries came from the superseded apply direction. During revised apply:

1. inspect the partial files and retain useful logic through reviewed moves or rewrites into the matching layouts;
2. establish and test equivalent layout code;
3. remove only the interrupted `packages/*` files;
4. remove only their workspace and path-dependency additions from `pubspec.yaml`;
5. preserve pre-existing root dependency and user changes.

This is not performed during planning.

### 8. Architecture history is superseded, not rewritten

Create ADR-0010 for single-package layout Clean Architecture. It supersedes ADR-0007; ADR-0007 receives only a `Status: Superseded by ADR-0010` update and otherwise remains historical. Update `AGENT.md` and the canonical governance spec to the new paths.

## Risks / Trade-offs

- **Folder boundaries are weaker than package manifests.** Mitigation: mandatory import scanner, public barrels, architecture review and tests.
- **Renaming `lib/ui` changes many imports at once.** Mitigation: migrate dependency-first, format after each vertical slice and run targeted widget tests.
- **Partial package files create duplicate models.** Mitigation: keep one authoritative layout implementation and scan for duplicate entity/Cubit definitions before removing compatibility code.
- **`data_layout` can leak into pages in one package.** Mitigation: architecture tests allow data imports only from the composition directory.
- **A single manifest includes Flutter for the whole app.** Mitigation: domain purity is validated from imports and tested without Flutter APIs; independent package resolution is intentionally not a goal.

## Migration Plan

1. Snapshot the working tree and partial package output.
2. Remove workspace/path-package additions while preserving unrelated `pubspec.yaml` changes; add only direct dependencies needed by layout code.
3. Establish `domain_layout`, its barrel and tests.
4. Establish `data_layout` adapters and contract tests.
5. Establish feature Cubits in `business_layout` and unit tests.
6. Move `lib/ui` to `lib/ui_layout`, add Pure DI and migrate consumers.
7. Remove obsolete `AppCubit`, duplicate UI models and interrupted `packages/*` only after replacements pass tests.
8. Add architecture tests and superseding ADR/governance documentation.
9. Run format, analysis, all tests, structural limits and available platform builds.

Rollback restores the pre-change `lib/ui` implementation and removes only files introduced by this change. Unrelated `.idea`, generated, asset and user-owned configuration changes are not restored or deleted.
