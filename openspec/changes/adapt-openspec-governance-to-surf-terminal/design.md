# Design

## Context

See `proposal.md` for motivation and `specs/project-development-governance/spec.md` for the behavioral contract.

The repository currently has a valid built-in `spec-driven` workflow, accepted governance in `openspec/specs/project-development-governance/spec.md`, and ADRs covering approval gates, single-package layout Clean Architecture, SSH/security runtime, persistence, and presentation. The copied files replaced the authoritative `AGENT.md`, introduced a large unrelated `rules.md`, added `openspec/schemas/monitoring-sdd`, and switched `openspec/config.yaml` to that schema. Structural schema validation passes because it cannot detect semantic mismatch.

The active `save-and-connect-ssh-profile` change predates this governance update and has its own artifacts. It must remain untouched. This planning change is explicitly recorded with `schema: spec-driven` to avoid bootstrapping itself through the copied workflow.

## Goals / Non-Goals

**Goals:**

- Provide one project-local schema named `surf-terminal-sdd` whose workflow and templates reflect the live repository.
- Re-establish a clear context hierarchy: canonical specs and accepted ADRs, then authoritative `AGENT.md`, then concise operational `rules.md`, then schema/template guidance.
- Make proposal/spec/design/tasks generation consistently reference real Flutter/Dart paths, commands, architectural boundaries, security constraints, and verification types.
- Preserve explicit planning/apply/archive approval gates and make test-first evidence visible in tasks.
- Make stale copied-project assumptions mechanically discoverable through targeted content scans in addition to schema validation.

**Non-Goals:**

- Do not change runtime Dart code, dependencies, routes, database schema, SSH behavior, visual output, platform projects, or generated sources.
- Do not rewrite, rename, complete, or archive `save-and-connect-ssh-profile`.
- Do not introduce a new workflow engine, dependency, test runner, or schema artifact type.
- Do not rewrite accepted ADR history. The design implements ADR-0006, ADR-0010, ADR-0011, and ADR-0012 rather than superseding them.

## Decisions

### 1. Replace rather than patch the copied schema

Create `openspec/schemas/surf-terminal-sdd/` and remove `openspec/schemas/monitoring-sdd/` in the same apply. The new schema keeps the familiar `proposal → specs → design → tasks` graph and standard output paths so OpenSpec tooling and existing practices remain predictable.

**Rationale:** Renaming isolated strings inside the copied schema would leave hidden assumptions about analyst/developer ownership, role matrices, React layers, ADR generation paths, and npm validation. A clean project-specific rewrite is easier to review and less likely to retain foreign policy.

**Alternative:** Keep the name `monitoring-sdd` and edit content. Rejected because the name itself is a foreign product concept and would remain misleading in configuration and generated metadata.

### 2. Keep templates rich enough to guide, but parser-compatible

The four Markdown templates will include Surf Terminal-specific headings and prompts while preserving OpenSpec's required delta syntax:

- proposal identifies affected capabilities and actual `lib/*_layout`, test, platform, config, and documentation surfaces;
- spec uses `## ADDED/MODIFIED/REMOVED/RENAMED Requirements`, exact `### Requirement:` and `#### Scenario:` headings, and GIVEN/WHEN/THEN guidance;
- design records applicable ADRs, layer placement, dependency direction, security/data flow, UI/runtime choices, verification strategy, and migration/rollback;
- tasks uses parseable `- [ ] N.N` checkboxes and separates RED, implementation/GREEN, generated-code checks, integration/device smoke, context synchronization, and final quality gates.

**Rationale:** Templates should eliminate repeated project discovery without embedding implementation details into behavior specs or creating syntax that archive/validation cannot parse.

**Alternative:** Use minimal default templates plus only `config.yaml` rules. Rejected because the user explicitly wants custom templates and the project has stable cross-cutting constraints that are easy to omit from generic skeletons.

### 3. Restore `AGENT.md` as authority and make `rules.md` intentionally shorter

Use the previous Surf Terminal `AGENT.md` from `HEAD` as the semantic baseline, then reconcile it with the live repository and accepted ADRs. Remove stale claims that no longer match `pubspec.yaml` or source layout, such as package-era `packages/data` paths, uninstalled dependency tables, or superseded UI wording. Retain normative OpenSpec, architecture, SSH/security, persistence, state, generation, testing, ADR, and definition-of-done sections.

Rewrite `rules.md` as a compact day-to-day checklist that links to `AGENT.md` and ADRs. It will cover file placement, event/BLoC conventions, Cupertino-first and terminal presentation rules, test-first workflow, secret handling, generated files, verification commands, and actions requiring separate approval. It will not duplicate long dependency tables or re-specify canonical requirements.

**Rationale:** Two full authoritative rulebooks drift. A primary contract plus a concise operational companion gives agents fast guidance while retaining one source of truth.

**Alternative:** Delete `rules.md`. Rejected because the copied schema and desired workflow explicitly use a short operational rules surface, and it is useful when kept subordinate and non-duplicative.

### 4. Put stable project context in `openspec/config.yaml`

Set `schema: surf-terminal-sdd`. Replace commented examples with concise live context and artifact-specific rules. Add operation guidance that requires reading `AGENT.md`, `rules.md`, relevant canonical specs/ADRs, preserving approval gates, reporting real verification, and explicitly deciding archive versus continued work after apply.

**Rationale:** Config context is automatically supplied during artifact generation and is the right place for short cross-artifact facts. Detailed policy remains in the schema and root documents.

**Alternative:** Leave config nearly empty. Rejected because it increases the chance that tools use the custom templates mechanically without the project's active scope and quality expectations.

### 5. Verify semantics separately from schema syntax

Validation will combine:

1. `openspec schema validate surf-terminal-sdd --verbose`;
2. `openspec schema which surf-terminal-sdd` and `openspec templates --schema surf-terminal-sdd --json`;
3. strict validation/status of this change;
4. content scans proving forbidden copied-project terms are absent from the adapted context/schema files;
5. checks that required Surf Terminal terms, paths, and commands are present;
6. a temporary disposable change generated with `--schema surf-terminal-sdd`, inspected with `status`/`instructions`, then removed without touching active project changes.

The disposable schema smoke is a tooling/config verification, not a runtime Flutter test. It must use a unique temporary change name and cleanup must be limited to that generated directory.

**Rationale:** OpenSpec validation proves structure, not domain correctness. A controlled generation smoke verifies that the schema actually resolves and unlocks artifacts as intended.

**Alternative:** Run only schema validation. Rejected because that already passes for the semantically wrong copied schema.

### 6. Do not create a new ADR

This change applies existing governance and architecture decisions. It does not choose a new long-term architecture, security policy, persistence approach, UI system, or approval model.

**Rationale:** ADR-0006 already requires approval-gated OpenSpec; ADR-0010, ADR-0011, and ADR-0012 provide the project-specific content being encoded. Creating another ADR would duplicate accepted decisions rather than record a new one.

## Risks / Trade-offs

- [The restored `AGENT.md` baseline contains historical stale details] → Reconcile every command, path, dependency, and UI statement against `pubspec.yaml`, the live `lib/`/`test/` tree, canonical specs, and accepted ADRs before writing.
- [A custom template can accidentally violate OpenSpec parser conventions] → Keep standard artifact IDs/output paths and validate both schema structure and a disposable generated change.
- [Deleting `monitoring-sdd` could break an active change recorded with that schema] → Inspect `.openspec.yaml` for all active changes before deletion; the current `save-and-connect-ssh-profile` must not depend on `monitoring-sdd`. If any active change does, stop and revise the migration plan.
- [Rules duplicated across config, schema, `AGENT.md`, and `rules.md` can drift] → Assign ownership explicitly: canonical behavior in specs, long-term rationale in ADRs, normative engineering contract in `AGENT.md`, operational checklist in `rules.md`, artifact-generation instructions in schema/templates, and only concise context in config.
- [Strict RED-first wording can be impractical for pure configuration/docs] → Require explicit justified non-RED verification for config, generated output, documentation-only, and environment-gated cases rather than pretending they have a meaningful failing unit test.
- [The working tree contains unrelated user changes] → Touch only the approved governance/schema files and this change's planning artifacts; leave `lib/main.dart`, `.idea`, and all unrelated code/tests unchanged.

## Migration Plan

1. Confirm no active change records `schema: monitoring-sdd`.
2. Create `openspec/schemas/surf-terminal-sdd/` with rewritten `schema.yaml` and templates.
3. Rewrite `AGENT.md` and `rules.md` from the accepted project context.
4. Update `openspec/config.yaml` to select and contextualize `surf-terminal-sdd`.
5. Remove only `openspec/schemas/monitoring-sdd/` after the new schema validates.
6. Run schema resolution, template resolution, semantic scans, and a disposable schema-generation smoke.
7. Run strict change validation/status and review the final diff for unrelated modifications.

Rollback is file-local: restore `schema: spec-driven`, restore the previous Surf Terminal `AGENT.md` from `HEAD`, remove `surf-terminal-sdd`, and leave the copied schema disabled or remove it. Existing active changes remain available because their directories and metadata are not modified.

## Open Questions

None.
