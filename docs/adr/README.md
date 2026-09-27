# Architecture Decision Records

Architecture Decision Records (ADR) explain significant, long-lived technical decisions for Surf Terminal. `AGENT.md` defines the active engineering rules; this directory preserves the reasoning, alternatives, and consequences behind those rules.

## When an ADR is required

Create an ADR when an OpenSpec change chooses or replaces:

- an architectural pattern or layer boundary;
- a primary framework or library with long-term coupling;
- persistence or security policy;
- a protocol or transport abstraction;
- a cross-feature contract;
- a project-wide quality or delivery governance rule.

Local implementation details that do not affect long-term boundaries, public contracts, security, data, or maintainability do not require an ADR.

## Naming and numbering

```text
ADR-NNNN-kebab-case-title.md
```

- Allocate the next unused sequential number.
- Never reuse a number, even if an ADR is removed from active consideration.
- Keep the title stable after acceptance.
- Copy `template.md`; do not edit the template for a single decision.

## Status lifecycle

- `Proposed` — awaiting review and approval.
- `Accepted` — approved and active.
- `Deprecated` — retained for history but no longer recommended.
- `Superseded` — replaced by a newer ADR.

Do not rewrite accepted history when a decision changes. Create a new ADR, link it to the previous ADR, and update the previous ADR status to `Superseded` while preserving its original content.

## Index

| ADR | Status | Decision |
|---|---|---|
| [ADR-0001](ADR-0001-feature-first-clean-architecture.md) | Superseded | Feature-first Clean Architecture in one Flutter application |
| [ADR-0002](ADR-0002-flutter-bloc-and-freezed.md) | Accepted | Flutter BLoC and Freezed for workflow state |
| [ADR-0003](ADR-0003-getit-constructor-injection.md) | Accepted | GetIt only in the composition root with constructor injection |
| [ADR-0004](ADR-0004-dartssh2-and-xterm.md) | Accepted | dartssh2 transport behind a domain contract and xterm terminal buffer |
| [ADR-0005](ADR-0005-drift-and-secure-storage.md) | Superseded | Drift for structured data and secure storage for secrets |
| [ADR-0006](ADR-0006-openspec-approval-workflow.md) | Accepted | Transparent, approval-gated OpenSpec workflow |
| [ADR-0007](ADR-0007-package-based-clean-architecture.md) | Superseded | Package-based Clean Architecture with explicit Flutter pages |
| [ADR-0008](ADR-0008-sqflite-and-secure-storage.md) | Accepted | sqflite for structured data and secure storage for secrets |
| [ADR-0009](ADR-0009-surf-terminal-presentation-system.md) | Accepted | Original adaptive presentation system with fixture-only boundaries |
| [ADR-0010](ADR-0010-single-package-layout-clean-architecture.md) | Accepted | Single-package Clean Architecture with explicit `*_layout` boundaries |
