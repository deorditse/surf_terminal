# Proposal

## Why

Surf Terminal is one Flutter application rather than a collection of independently released libraries. The previously approved top-level `packages/*` design adds workspace and manifest ceremony without an independent distribution boundary. The application still needs explicit Clean Architecture ownership, but that ownership should be expressed as named `*_layout` directories inside the app's single `lib/` tree, following the useful layout vocabulary from Gigalegal while retaining strict dependency inversion.

The interrupted package-based apply created partial `packages/*` files and root workspace entries. They are not connected to the UI and must be reconciled rather than left as a second competing architecture.

## What Changes

- Replace the planned top-level local packages with four explicit layers inside the single Flutter package:
  - `lib/domain_layout` for Flutter-free entities, values, failures and contracts;
  - `lib/business_layout` for feature Cubit/BLoC, immutable state, use cases and orchestration;
  - `lib/data_layout` for fixture datasources, mappers and implementations of domain contracts;
  - `lib/ui_layout` for application composition, routing, pages and shared presentation components.
- Preserve the dependency graph `business_layout → domain_layout`, `data_layout → domain_layout`, and `ui_layout → domain_layout + business_layout + data_layout`.
- Enforce the single-package boundaries with public layout barrels, import conventions and automated architecture tests rather than nested `pubspec.yaml` files.
- Replace the cross-feature `AppCubit` with feature-owned workflow state and constructor-injected domain contracts.
- Keep concrete data construction inside `lib/ui_layout/app/di`; pages and business logic do not import `data_layout`.
- Move the current `lib/ui` presentation into `lib/ui_layout` and keep routed pages explicitly decomposed under `lib/ui_layout/pages`.
- Reconcile the interrupted apply by removing unconsumed `packages/*`, Dart workspace entries and path dependencies only after the revised apply is approved.
- Add a superseding ADR and update `AGENT.md` because this replaces ADR-0007 and the canonical package-path rules.
- Keep the current fixture-only UI behavior. Real SSH/SFTP, Hive/SQLite and secure-storage adapters remain outside this change.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `project-development-governance`: replace independently manifested `packages/*` boundaries and `lib/ui` paths with one-app `lib/*_layout` boundaries, while preserving dependency inversion, constructor injection, Pure Dart domain code and explicit page ownership.

## Impact

- Changes the canonical governance spec, `AGENT.md`, and architecture ADR history.
- Changes root imports and source locations, but does not add nested manifests or Dart workspace members.
- Removes the interrupted `packages/*` implementation and workspace/path dependency entries after equivalent `lib/*_layout` code is established.
- Migrates tests to layout-level unit, contract, architecture and widget coverage in the root package.
- Does not add network, persistence, credential, filesystem or platform-storage side effects.
