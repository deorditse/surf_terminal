# ADR-0003: Restrict GetIt to the composition root

Status: Accepted
Date: 2026-09-26

## Context

Surf Terminal needs to compose repositories, SSH adapters, storage implementations, BLoCs, and platform services without hiding their dependencies. Allowing BLoCs or services to obtain repositories through static service-locator calls would make construction order implicit and complicate deterministic tests.

## Decision

Use GetIt as the dependency container only in `lib/ui/app/di` and bootstrap code. Register concrete implementations against domain contracts in the composition root.

All BLoCs, use cases, repositories, adapters, and services receive dependencies through constructors. Calls such as `GetIt.I.get()` or a project-specific global locator are prohibited outside the composition root.

Session-scoped resources are created and disposed by an explicit session scope rather than registered as accidental global singletons.

## Alternatives

- **Global service locator access from any layer.** Rejected because dependencies become hidden and tests depend on mutable global registration state.
- **Manual construction without a container.** Viable for a very small application, but becomes noisy as platform and session scopes grow.
- **Generated dependency injection.** Rejected initially because it adds another generator and annotation model without a demonstrated need.
- **Provider-based dependency lookup from BuildContext.** Rejected for domain/data objects because it couples construction to Flutter UI context.

## Consequences

Class APIs reveal their dependencies and are straightforward to test with fakes. GetIt remains a small composition mechanism rather than an application-wide access pattern.

Constructors may become longer, and bootstrap must explicitly define lifetimes and disposal. Any future generated-DI migration would be localized to the composition root.
