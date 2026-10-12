# Proposal

## Why

The copied OpenSpec schema, templates, `rules.md`, and replacement `AGENT.md` describe a different React/Vite monitoring application and now direct planning toward nonexistent paths, tools, roles, and quality gates. Surf Terminal needs a project-local schema and engineering guidance grounded in its actual Flutter/Dart codebase, accepted ADRs, SSH security boundaries, Cupertino-first presentation, and executable verification workflow.

## What Changes

- Replace the copied `monitoring-sdd` schema with a project-local `surf-terminal-sdd` workflow while preserving the proposal → specs → design → tasks dependency order.
- Rewrite proposal, spec, design, and tasks templates for Surf Terminal's single-package `*_layout` Clean Architecture, Flutter BLoC/Freezed workflows, SSH/security constraints, Cupertino-first UI direction, and layered tests.
- Restore and update the root `AGENT.md` as the authoritative engineering contract for the current repository instead of the copied React instructions.
- Rewrite `rules.md` as a concise operational companion to `AGENT.md`, with project-specific placement, TDD, verification, security, UI, and OpenSpec rules rather than duplicated or conflicting policy.
- Configure `openspec/config.yaml` to select `surf-terminal-sdd` and provide project context, artifact rules, and apply/archive guidance.
- Remove all copied-project identifiers and assumptions, including GIGALEGAL/LEGALBPM, legislation monitoring, React/Vite/TypeScript, Redux/RTK Query, Ant Design/Less, npm/jest/stylelint, `src/pages`, and `ci_cd` paths.
- Require planning artifacts to map requirements to verification, use RED → GREEN for behavioral production changes, distinguish automated tests from device/environment-gated smoke checks, and preserve separate planning/apply/archive approval gates.
- **BREAKING**: new changes will resolve through `surf-terminal-sdd`; the copied `monitoring-sdd` schema name and templates will be removed. Existing active changes keep their recorded schema and artifacts and are not automatically rewritten.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `project-development-governance`: extend the governance contract so project-local OpenSpec schemas/templates, `AGENT.md`, and `rules.md` must describe the live Surf Terminal project; require behavioral tasks to record RED/GREEN verification and require copied or stale project assumptions to be rejected during validation/review.

## Impact

- OpenSpec configuration: `openspec/config.yaml`.
- Project-local schema: replace `openspec/schemas/monitoring-sdd/` with `openspec/schemas/surf-terminal-sdd/` and rewrite `schema.yaml` plus all four templates.
- Engineering guidance: `AGENT.md` and `rules.md`.
- Canonical governance after archive: `openspec/specs/project-development-governance/spec.md`.
- Existing active change: `save-and-connect-ssh-profile` remains active and unchanged; it will not be migrated implicitly.
- No runtime Dart/Flutter behavior, dependencies, database schema, platform project, routes, or public APIs change in this governance-only work.
