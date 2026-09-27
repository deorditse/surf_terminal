# ADR-0001: Use feature-first Clean Architecture

Status: Superseded
Date: 2026-09-26

Superseded by: [ADR-0007](ADR-0007-package-based-clean-architecture.md)

## Context

Surf Terminal is a Flutter SSH client for iOS and Android. SSH transport, terminal rendering, secure storage, persistence, mobile lifecycle, and UI state have different change rates and test boundaries. A structure organized only by technical type makes a feature span distant folders, while splitting the initial application into multiple local packages adds release and dependency overhead before stable package boundaries exist.

The project needs domain rules that can be tested without Flutter, real devices, secure storage, or an SSH server.

## Decision

Use feature-first Clean Architecture inside one Flutter application. Each feature contains `domain`, `data`, and `presentation` layers.

The dependency direction is `presentation → domain ← data`. Domain remains pure Dart and owns entities, failures, policies, and contracts. Data implements domain contracts. Presentation uses domain contracts through BLoC. `app/di` is the composition root that wires concrete implementations.

Shared `core` code is allowed only for stable abstractions genuinely reused by multiple features. Use cases are created for business rules, orchestration, policy, or reuse—not as mechanical wrappers around every repository method.

The architecture does not reserve a global `lib/generated` directory. Generated sources live next to source files or in generator-specific output locations only after the corresponding generator is configured.

## Alternatives

- **Layer-first folders for the whole application.** Rejected because a single feature would be scattered across global `models`, `services`, `repositories`, `blocs`, and `screens` folders.
- **Separate local packages for models, data, business logic, and UI.** Rejected for the initial project because package boundaries are not yet independently versionable and would add boilerplate similar to the Gigalegal reference project.
- **UI calling SSH and storage libraries directly.** Rejected because it couples widgets to infrastructure and prevents deterministic testing.

## Consequences

Features have clear ownership and can be tested by replacing domain contracts with fakes. Infrastructure libraries remain replaceable and platform concerns stay outside domain logic.

The structure introduces interfaces, mappers, and explicit boundaries. Developers must resist placing feature-specific code in `core`. A future package extraction requires a separate OpenSpec change and ADR based on demonstrated boundaries.

This decision was superseded when Surf Terminal adopted physically independent local packages in [ADR-0007](ADR-0007-package-based-clean-architecture.md).
