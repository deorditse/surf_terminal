# Design: <change title>

## Context

<Current state and constraints needed for the approach. Reference proposal.md for motivation.>

## Goals / Non-goals

**Goals:**

- <Technical outcome>

**Non-goals:**

- <Excluded implementation or follow-up>

## Applicable ADRs

- `<ADR path>`: <how the change follows, extends, or supersedes it>
- New/superseding ADR required: `yes` / `no` — <reason>

## Architecture Profile

Record the live choices applicable to this change:

- Package shape: one Flutter package
- Layers: `domain_layout`, `data_layout`, `business_layout`, `ui_layout`
- State/workflows: Freezed `Bloc<Event, State>` / local UI state / direct stream
- Composition: constructor/provider wiring; concrete adapters only in `ui_layout/app/di`
- UI: Cupertino-first app chrome; xterm terminal surface
- Persistence: sqflite for non-secrets; protected storage for secrets
- SSH: dartssh2 behind domain contracts with mandatory host-key verification
- Tests: unit/BLoC, adapter/repository, architecture, widget/golden, integration/device

## Layer and File Placement

| Area | Responsibility/change | Paths | Allowed dependencies |
| --- | --- | --- | --- |
| Domain | <...> | `lib/domain_layout/...` | pure Dart only |
| Business | <...> | `lib/business_layout/...` | domain only |
| Data | <...> | `lib/data_layout/...` | domain only |
| UI/app | <...> | `lib/ui_layout/app/...` | composition of all layers |
| UI/pages/shared | <...> | `lib/ui_layout/pages/...` | no concrete data imports |

## Workflow, Concurrency, and Ownership

<Events/states, ordering, cancellation, stale-event rejection, retries, subscriptions,
resource ownership and disposal. Explain when direct terminal streams bypass BLoC state.>

## Security and Data Flow

<Secrets, credential references, host-key decisions, safe errors/logging, data at rest,
migrations, partial failure ordering, and cleanup. Write “not affected” with reasoning when checked.>

## UI, Navigation, and Input

<Routes, Cupertino components, lifecycle/loading/error states, terminal focus, software keyboard,
IME/safe-area behavior, accessibility semantics, and visual/golden impact.>

## Decisions

### D1. <decision>

- **Choice:** <selected approach>
- **Rationale:** <why it fits requirements and current project>
- **Alternatives:** <rejected options and why>
- **Requirements:** <requirement names>
- **Longevity:** local / long-term

## Verification Strategy

- RED evidence: <focused test/check and expected failing reason>
- GREEN/regression: <commands and expected result>
- Architecture/security/generation: <checks>
- Adapter/integration harness: <checks or not required>
- Widget/golden/platform build: <checks or not required>
- Device/emulator/external smoke: <prerequisites and evidence or not required>

## Risks / Trade-offs

- [Risk] <...> → Mitigation: <...>

## Migration and Rollback

<Ordered migration, compatibility, rollback, and cleanup plan.>

## Open Questions

- None.

<!-- Keep only genuinely deferrable questions. Resolve anything that changes requirements,
     architecture, security, acceptance criteria, or tasks before authoring tasks.md. -->
