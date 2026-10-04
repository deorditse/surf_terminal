# Tasks

## 1. Reconcile the interrupted apply

- [x] 1.1 Capture Git status, root `pubspec.yaml`, current `lib/ui` inventory and every partial `packages/*` file; classify pre-existing user changes separately from interrupted architecture output
- [x] 1.2 Remove only the interrupted Dart workspace entries and local package path dependencies, preserve approved root dependencies and verify the single root manifest resolves without `any` or dependency overrides
- [x] 1.3 Reuse reviewed partial logic only through the target `lib/*_layout` structure; do not leave duplicate authoritative models, repositories or Cubits under `packages/*`

## 2. Domain layout

- [x] 2.1 Create `lib/domain_layout/domain_layout.dart` and private source directories for entities, values, failures and contracts
- [x] 2.2 Move `SshProfile`, `CommandSnippet` and `PreviewSession` into domain layout and verify endpoint, immutability, copy and identity tests
- [x] 2.3 Move terminal preferences, palette and cursor concepts into Flutter-free domain values and verify domain imports contain no Flutter, UI, DI, storage, SSH implementation or platform libraries
- [x] 2.4 Add SFTP values and typed failures required by preview workflows and verify all supported states and diagnostics without secrets
- [x] 2.5 Define domain contracts for profiles, snippets, settings and preview SFTP browsing and verify they expose no BLoC or concrete adapter types

## 3. Data layout

- [x] 3.1 Create `lib/data_layout/data_layout.dart` with private fixture datasource and repository implementation directories
- [x] 3.2 Implement fictional in-memory profile and snippet repositories and verify contract tests cover list, save/update, deletion and final-item empty behavior
- [x] 3.3 Implement in-memory settings and SFTP repositories with path-dependent listings and parent navigation; verify empty/loading/data/error and navigation behavior
- [x] 3.4 Export only composition-facing repository implementations and verify data imports domain only, never business or UI
- [x] 3.5 Scan fixtures and logs for real addresses, usernames, passwords, keys and passphrases

## 4. Business layout

- [x] 4.1 Add a direct compatible root `bloc` dependency and create the `lib/business_layout/business_layout.dart` public API
- [x] 4.2 Implement constructor-injected `ProfilesCubit` and verify load, save/update, deletion, empty and failure states
- [x] 4.3 Implement constructor-injected `SnippetsCubit` and verify filtering, create/update, deletion and failure states
- [x] 4.4 Implement `TerminalSessionsCubit` and verify add, select, close active/inactive, neighboring selection and zero-session behavior
- [x] 4.5 Implement constructor-injected `SftpCubit` and verify preview-state transitions and folder/parent navigation
- [x] 4.6 Implement constructor-injected `SettingsCubit` and verify palette, font, cursor, emulation, keepalive and keep-awake updates with bounded values
- [x] 4.7 Verify business imports domain plus Dart BLoC only and has no data, UI, Flutter widget, DI, storage, SSH or platform imports

## 5. UI layout and composition

- [x] 5.1 Move `lib/ui` to `lib/ui_layout`, update root imports and preserve explicit app/pages/shared ownership
- [x] 5.2 Add immutable Pure DI composition under `lib/ui_layout/app/di` and verify only that directory imports concrete data implementations
- [x] 5.3 Replace `AppCubit` with independently owned feature Cubits in `MultiBlocProvider` and verify app disposal and test injection
- [x] 5.4 Migrate connections/editor to domain entities and `ProfilesCubit`; verify create, validation, password and navigation tests
- [x] 5.5 Migrate terminal and SFTP to terminal/settings/SFTP Cubits; verify workspace and isolated SFTP state tests
- [x] 5.6 Migrate snippets/editor/settings to feature Cubits/domain values; verify editor, settings and cross-page preference propagation
- [x] 5.7 Map domain terminal palette identifiers to Flutter colors only in presentation and verify rendering remains unchanged
- [x] 5.8 Remove obsolete `AppCubit`, `SurfAppState` and duplicate UI-domain models after consumers migrate

## 6. Architecture governance and verification

- [x] 6.1 Add `test/architecture/layout_boundaries_test.dart` covering all forbidden imports and composition-root-only data resolution
- [x] 6.2 Create ADR-0010 for single-package `*_layout` Clean Architecture, mark ADR-0007 superseded without rewriting its history, and update ADR index
- [x] 6.3 Update `AGENT.md` to the canonical layout paths, dependency graph, DI rule and architecture-test gate
- [x] 6.4 Remove the interrupted `packages/*` tree only after equivalent layout code and tests pass, and verify no nested manifests or workspace members remain
- [x] 6.5 Audit page/module decomposition: route pages target 150 lines and ordinary handwritten Dart files target 200 lines unless explicitly justified
- [x] 6.6 Run root dependency resolution, formatting and analysis; use the established ASCII-copy workaround if analysis still fails solely because of the Cyrillic repository path
- [x] 6.7 Run domain, data contract, BLoC, architecture, widget and golden tests with no network, credential, persistence or platform-storage side effects
- [x] 6.8 Run available Android and iOS-compatible builds and report unavailable targets honestly
- [x] 6.9 Verify the final graph is `business_layout → domain_layout`, `data_layout → domain_layout`, `ui_layout → all`, with no business→data, data→business, domain→Flutter, page→data or hidden service-locator dependency
