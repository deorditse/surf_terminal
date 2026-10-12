# Tasks

## 1. Baseline and RED semantic audit

- [x] 1.1 Record the governance-file baseline (`git status --short`, active changes with their `.openspec.yaml` schema values, current schema resolution, and the approved file scope) and verify `save-and-connect-ssh-profile` is not recorded against `monitoring-sdd` before deleting that schema — REQ: project-local OpenSpec guidance matches the live repository.
- [x] 1.2 Run a focused semantic audit over `AGENT.md`, `rules.md`, `openspec/config.yaml`, and `openspec/schemas/monitoring-sdd/**` that fails on copied-project terms (`GIGALEGAL`, `LEGALBPM`, legislation monitoring, React, Vite, TypeScript, Redux, RTK Query, Ant Design, Less, npm, jest, stylelint, `src/pages`, `ci_cd`) and record the expected RED result before adapting the files — REQ: project-local OpenSpec guidance matches the live repository; architecture instructions are authoritative.
- [x] 1.3 Inventory live Surf Terminal facts from `pubspec.yaml`, `lib/`, `test/`, canonical specs, and accepted ADRs, and verify the resulting checklist covers architecture, BLoC/Freezed, SSH/security, persistence, Cupertino-first presentation, code generation, test layers, and quality commands — REQ: architecture instructions are authoritative.

## 2. Project-local OpenSpec schema

- [x] 2.1 Create `openspec/schemas/surf-terminal-sdd/schema.yaml` with the proposal → specs → design → tasks dependency graph, standard artifact output paths, Surf Terminal-specific instructions, and approval-gated apply guidance; verify `openspec schema validate surf-terminal-sdd --verbose` succeeds — REQ: project-local OpenSpec guidance matches the live repository.
- [x] 2.2 Rewrite `templates/proposal.md` to capture problem/scope, affected `*_layout`/tests/platform/config/docs surfaces, capabilities, security/data impact, UI impact, exclusions, compatibility, and verification impact; verify no foreign project identifier or nonexistent React path remains — REQ: project-local OpenSpec guidance matches the live repository.
- [x] 2.3 Rewrite `templates/spec.md` with parser-compatible delta headings, complete requirements, exactly four-hash scenarios, GIVEN/WHEN/THEN prompts, error/security/privacy/reliability/accessibility considerations, explicit non-goals, and requirement-to-verification traceability; verify the headings remain accepted by strict OpenSpec validation — REQ: project-local OpenSpec guidance matches the live repository.
- [x] 2.4 Rewrite `templates/design.md` for applicable ADRs, live architecture profile, layer placement and dependency direction, BLoC concurrency, SSH/security and credential flow, persistence/migration, Cupertino/terminal presentation, verification strategy, risks, migration/rollback, and open questions; verify every referenced path exists or is an explicit placeholder pattern for this repository — REQ: architecture instructions are authoritative.
- [x] 2.5 Rewrite `templates/tasks.md` with parseable checkboxes and ordered groups for baseline/RED, implementation/GREEN, generated-code reproducibility, adapter/integration checks, device/environment smoke, context synchronization, and final quality gates; verify deterministic behavior tasks require named RED and GREEN evidence while justified configuration/device exceptions remain explicit — REQ: behavioral work records test-first verification.
- [x] 2.6 Validate and resolve the new schema with `openspec schema validate surf-terminal-sdd --verbose`, `openspec schema which surf-terminal-sdd`, and `openspec templates --schema surf-terminal-sdd --json`; verify every artifact resolves from `openspec/schemas/surf-terminal-sdd/templates/` — REQ: project-local OpenSpec guidance matches the live repository.

## 3. Authoritative project context

- [x] 3.1 Restore and update `AGENT.md` from the Surf Terminal engineering contract in `HEAD`, reconciling every dependency, path, command, architecture statement, SSH/security rule, persistence rule, presentation rule, test rule, and quality gate with the live repository and accepted ADRs; verify no stale package-era path or uninstalled dependency is presented as current fact — REQ: architecture instructions are authoritative.
- [x] 3.2 Rewrite `rules.md` as a concise operational companion that links to `AGENT.md` and applicable ADRs, covers file placement, BLoC/Freezed event conventions, Cupertino-first/terminal UI, RED → GREEN, secret handling, generated files, verification, and approval boundaries, and explicitly states precedence; verify it does not duplicate a second full architecture contract — REQ: architecture instructions are authoritative; behavioral work records test-first verification.
- [x] 3.3 Update `openspec/config.yaml` to select `surf-terminal-sdd` and add concise live project `context`, artifact `rules`, and `operations.apply/archive.guidance`; verify the YAML parses and every path/command matches Surf Terminal — REQ: project-local OpenSpec guidance matches the live repository.
- [x] 3.4 Remove only `openspec/schemas/monitoring-sdd/` after the replacement validates, then verify no active change references `monitoring-sdd` and `openspec schema which surf-terminal-sdd` still resolves from the project — REQ: project-local OpenSpec guidance matches the live repository.

## 4. GREEN semantic and workflow verification

- [x] 4.1 Re-run the copied-project semantic audit from task 1.2 and verify GREEN: forbidden foreign terms are absent from `AGENT.md`, `rules.md`, `openspec/config.yaml`, and `openspec/schemas/surf-terminal-sdd/**` — REQ: project-local OpenSpec guidance matches the live repository; architecture instructions are authoritative.
- [x] 4.2 Run a positive semantic audit and verify required Surf Terminal concepts are present where applicable: `domain_layout`, `data_layout`, `business_layout`, `ui_layout`, Flutter/Dart, BLoC/Freezed, dartssh2/xterm, sqflite/secure storage, Cupertino-first, RED/GREEN, `flutter analyze`, and `flutter test` — REQ: architecture instructions are authoritative; behavioral work records test-first verification.
- [x] 4.3 Create a uniquely named disposable change with `openspec new change <temporary-name> --schema surf-terminal-sdd`, inspect `status` and `instructions` for all artifacts, verify schema metadata and project-specific guidance, then delete only that disposable directory and confirm the real active changes are unchanged — REQ: project-local OpenSpec guidance matches the live repository.
- [x] 4.4 Run `openspec validate "adapt-openspec-governance-to-surf-terminal" --strict` and `openspec status --change "adapt-openspec-governance-to-surf-terminal"`; verify all planning artifacts remain valid after implementation edits — REQ: project-local OpenSpec guidance matches the live repository.

## 5. Project quality and scope review

- [ ] 5.1 Run `dart format --set-exit-if-changed .`, `flutter analyze`, and `flutter test`; verify passes or report pre-existing/unrelated failures separately without changing unrelated production files — REQ: architecture instructions are authoritative.
- [x] 5.2 Review `git diff -- AGENT.md rules.md openspec/config.yaml openspec/schemas openspec/changes/adapt-openspec-governance-to-surf-terminal` and verify only approved governance/schema files changed, while `lib/main.dart`, `.idea`, `save-and-connect-ssh-profile`, runtime code, dependencies, and platform projects remain untouched — REQ: architecture instructions are authoritative.
- [x] 5.3 Confirm no new ADR is required because the implementation applies ADR-0006, ADR-0010, ADR-0011, and ADR-0012 without changing their decisions; record the check in the apply report — REQ: architecture instructions are authoritative.
- [x] 5.4 Reconcile every completed checkbox with actual command/file evidence, leave unproven checks open, and explicitly report whether the change is ready for a separate archive approval or requires continued work — REQ: project-local OpenSpec guidance matches the live repository; behavioral work records test-first verification.

## Verification Evidence

- Schema validation/resolution: `surf-terminal-sdd` is valid, resolves as `Source: project`, and all four templates resolve from `openspec/schemas/surf-terminal-sdd/templates/`.
- End-to-end disposable smoke: strict validation passed with `4/4` artifacts and apply tracking found `2` tasks; explicit-schema and configured-default changes both recorded `schema: surf-terminal-sdd`; all disposable files/directories were removed.
- Semantic audit: copied-project terms returned zero exact matches in `AGENT.md`, `rules.md`, `openspec/config.yaml`, and `openspec/schemas/surf-terminal-sdd/**`; required Surf Terminal concepts returned `49` schema/template matches.
- Active changes after cleanup: only `adapt-openspec-governance-to-surf-terminal` and `save-and-connect-ssh-profile`; the latter has no staged or unstaged diff.
- Formatting gate: `dart format --output=none --set-exit-if-changed .` exited `1` and identified five out-of-scope files; the original files were not modified.
- Analyzer gate: the real checkout hit an analysis-server JSON/LSP failure on the Cyrillic path (exit `255`); an exact ASCII scratch copy completed analysis and reported two existing `prefer_initializing_formals` infos in `lib/ui_layout/app/di/connect_coordinator.dart:9-10` (exit `1`).
- Test gate: full `flutter test` on the exact ASCII scratch copy did not complete within the tool limit of `420` seconds.
- Diff/safety: `git diff --check` passed; scoped governance files are staged consistently; unrelated `.idea` state and `lib/main.dart` remain untouched; focused secret-pattern scans returned zero matches.
- ADR review: no new ADR is required because this change implements ADR-0006, ADR-0010, ADR-0011, and ADR-0012 without changing their decisions.
- Outcome: **continue work**. Do not archive until task 5.1 is GREEN or its repository-wide formatter/analyzer/test blockers are resolved and re-run.
