# ADR-0010: Use single-package layout Clean Architecture

Status: Accepted
Date: 2026-09-27

Supersedes: [ADR-0007](ADR-0007-package-based-clean-architecture.md)

## Context

Surf Terminal is one Flutter mobile application. ADR-0007 selected independently manifested local packages to make dependency direction visible, but implementing that shape introduced workspace manifests and path dependencies for layers that are not independently distributed or consumed.

The project still needs explicit ownership for domain concepts, workflow state, infrastructure adapters, presentation and composition. The useful `*_layout` vocabulary from the Gigalegal reference makes these responsibilities visible inside the application, while automated import tests can enforce direction without treating application internals as reusable packages.

## Decision

Use one root Flutter package with four application-owned layouts:

- `lib/domain_layout`: Flutter-free entities, values, failures, policies and contracts;
- `lib/business_layout`: feature BLoC/Cubit, use cases and orchestration;
- `lib/data_layout`: DTOs, mappers, datasources and implementations of domain contracts;
- `lib/ui_layout`: app composition, routing, pages and shared presentation.

Allowed dependency direction is:

```text
business_layout → domain_layout
data_layout     → domain_layout
ui_layout       → domain_layout + business_layout + data_layout
```

`business_layout → data_layout`, `data_layout → business_layout`, `domain_layout → Flutter/platform`, and page-level imports of concrete data implementations are prohibited. Concrete implementations are created only in `lib/ui_layout/app/di`, and dependencies are passed through constructors/providers.

Because the single root manifest cannot enforce folder imports, an automated architecture test is a required quality gate. No nested `pubspec.yaml`, Dart workspace or path dependency is used for these layers.

## Alternatives

- **Top-level local packages.** Superseded because the application layers have no independent distribution boundary and the additional manifests/workspace configuration add ceremony.
- **Nested local packages under `lib`.** Rejected because they retain the same package overhead while placing package roots inside the application source tree.
- **Unstructured feature folders.** Rejected because domain, workflow and infrastructure ownership becomes ambiguous.
- **Business logic importing data implementations.** Rejected because it reverses dependency direction and prevents adapter-free tests.

## Consequences

The application has one dependency manifest and one package identity. Layer ownership remains explicit in source paths, public barrels, constructor injection and tests. Refactors across layers are simpler because package resolution is unnecessary.

Folder boundaries are weaker than package manifests, so architecture tests and review discipline are mandatory. The root package includes Flutter dependencies even though `domain_layout` must remain Flutter-free by import policy. Future adapters remain replaceable behind domain contracts.
