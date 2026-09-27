# ADR-0006: Use a transparent approval-gated OpenSpec workflow

Status: Accepted
Date: 2026-09-26

## Context

The project will be developed with AI agents and humans. Architecture, security, dependency, and scope decisions must be reviewable before implementation. Silent tool use or implementation immediately after a high-level request makes it difficult for the owner to understand scope, commands, and side effects.

Requiring approval for every read-only query would create unnecessary friction, while allowing writes, apply, archive, or destructive operations without approval would remove meaningful control.

## Decision

All project changes use OpenSpec. Before every OpenSpec command, show the exact command, its purpose, whether it is read-only or state-changing, and its expected effect.

Announced read-only discovery commands may run without an additional approval. Creating a change, creating or editing planning artifacts, apply, archive, and destructive operations require explicit user approval.

Planning approval, apply approval, and archive approval are separate gates. If apply reveals a material scope, behavior, architecture, compatibility, security, or acceptance-criteria change, stop and return to an approved planning update.

After commands run, report actual results. Never infer success from intent or a command that was not executed.

## Alternatives

- **Implement directly after a user request.** Rejected because scope and architectural consequences are not reviewed first.
- **Require approval for every command, including reads.** Rejected because it adds friction without protecting state.
- **Show only summaries, not commands.** Rejected because the owner cannot evaluate exact effects or reproduce the workflow.
- **One approval for planning, apply, and archive.** Rejected because each phase has distinct side effects and review information.

## Consequences

The owner keeps explicit control over writes and lifecycle transitions while still allowing efficient discovery. Planning artifacts create an auditable contract for implementation.

The process adds ceremony, especially for small changes. Agents must announce commands clearly, keep scope proportional, and pause instead of silently absorbing design changes. Archive remains a separate user decision after implementation review.
