# ADR-0007: Use package-based Clean Architecture

Status: Superseded by [ADR-0010](ADR-0010-single-package-layout-clean-architecture.md)
Date: 2026-09-26

Supersedes: [ADR-0001](ADR-0001-feature-first-clean-architecture.md)

## Context

Surf Terminal combines SSH transport, terminal emulation, secure credentials, structured persistence, session workflows, and mobile presentation. These responsibilities require enforceable dependency boundaries so domain and workflow tests do not depend on Flutter, platform plugins, SQLite, or a real SSH server.

A single-package feature-first structure documents boundaries but does not make violations physically visible in package manifests. The project also needs a clear page-oriented presentation structure for navigation and UI ownership.

## Decision

Use three local packages and a root Flutter application:

- `packages/domain`: pure Dart entities, value objects, failures, result types, policies, and repository/session contracts;
- `packages/data`: SSH, SQLite, secure-storage, DTO, mapper, and repository implementations;
- `packages/business_logic`: BLoCs, immutable events/states, use cases, and orchestration policies;
- root Flutter app: presentation and composition under `lib/ui`.

Allowed dependency direction is:

```text
business_logic → domain
data           → domain
root app       → domain + data + business_logic
```

`business_logic → data`, `data → business_logic`, and `domain → Flutter/platform packages` are prohibited. GetIt is restricted to `lib/ui/app/di`; all other classes receive dependencies through constructors.

Presentation is organized as `lib/ui/app`, `lib/ui/pages`, and `lib/ui/shared`. Every routed surface has an explicit directory under `lib/ui/pages/<page>/`. Page-specific widgets stay with the page; only genuinely cross-page components move to `lib/ui/shared`.

## Alternatives

- **Single-package feature-first Clean Architecture.** Superseded because import conventions alone do not provide the required physical isolation between domain, infrastructure, and workflow logic.
- **Global layer folders inside `lib`.** Rejected because package manifests cannot enforce the boundaries and presentation ownership becomes unclear.
- **Additional application, infrastructure, and design-system packages.** Rejected initially because they add package overhead without a separate independently useful boundary.
- **BLoCs importing concrete repositories.** Rejected because it reverses dependency direction and prevents infrastructure-free tests.

## Consequences

Package manifests make dependency direction reviewable and testable. Domain and business logic can be exercised without Flutter plugins, while data implementations remain replaceable. The root app has one explicit composition root and an understandable page hierarchy.

The repository gains multiple pubspec files, package-level test suites, mappers, and contracts. Cross-package refactors require coordinated changes, and shared abstractions must remain small enough to prevent `domain` from becoming a dumping ground.
