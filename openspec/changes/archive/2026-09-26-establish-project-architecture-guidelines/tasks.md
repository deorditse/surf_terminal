# Tasks

## 1. Dependency snapshot

- [x] 1.1 Re-resolve the latest stable versions compatible with Flutter 3.47.5 and Dart 3.13.4 for every approved runtime and development package, including `sqflite`, record authoritative pub.dev/resolver results, and verify no dependency is expressed as `any` or an unexplained override

## 2. Architecture contract

- [x] 2.1 Create the root `AGENT.md` with the mandatory OpenSpec workflow, command announcement rules and approval gates, and verify it requires approve before planning writes, apply, archive and destructive operations while allowing announced read-only discovery
- [x] 2.2 Replace the obsolete single-package feature-first guidance in `AGENT.md` with `domain`, `data`, and `business_logic` packages plus root Flutter presentation, and verify every allowed and forbidden dependency direction is explicit
- [x] 2.3 Replace Drift guidance in `AGENT.md` with the approved `sqflite` structured-persistence boundary, refresh the verified stable version snapshot and package roles, and verify secure storage remains separate from SQLite
- [x] 2.4 Document SSH session lifecycle, terminal stream handling, mobile lifecycle, multi-session ownership and typed failure handling, and verify the required states and disposal responsibilities are explicit
- [x] 2.5 Document security rules for secrets, host-key verification, known hosts and redacted logging, and verify unconditional fingerprint acceptance and secret logging are explicitly prohibited
- [x] 2.6 Document model, repository, BLoC, routing, storage and code-generation conventions, and verify generated files are marked as non-editable by hand
- [x] 2.7 Document the layered testing strategy, required commands and definition of done, and verify `dart format --set-exit-if-changed .`, `flutter analyze` and `flutter test` are mandatory quality gates
- [x] 2.8 Document `lib/ui/app`, `lib/ui/pages`, and `lib/ui/shared` in `AGENT.md`, including concrete page locations and composition responsibilities, and verify every routed surface has an explicit page placement
- [x] 2.9 Link `AGENT.md` to the ADR index and document when a new or superseding ADR is required, then verify the active rules and historical rationale have distinct responsibilities

## 3. Architecture Decision Records

- [x] 3.1 Create `docs/adr/README.md` with naming, numbering, status and superseding rules plus an index, and verify it lists every initial ADR with status `Accepted`
- [x] 3.2 Create `docs/adr/template.md` using the approved `Status`, `Date`, `Context`, `Decision`, `Alternatives` and `Consequences` structure, and verify placeholders can be copied without editing the template itself
- [x] 3.3 Create `ADR-0001-feature-first-clean-architecture.md` and verify it records the layered feature-first decision, package-split alternative and consequences
- [x] 3.4 Create `ADR-0002-flutter-bloc-and-freezed.md` and verify it records state-machine rationale, Riverpod alternative and terminal-stream limitation
- [x] 3.5 Create `ADR-0003-getit-constructor-injection.md` and verify it permits GetIt only in the composition root and rejects hidden service-locator access
- [x] 3.6 Create `ADR-0004-dartssh2-and-xterm.md` and verify it records transport/emulator boundaries, alternatives and mobile lifecycle consequences
- [x] 3.7 Create `ADR-0005-drift-and-secure-storage.md` and verify it separates structured non-secret data from secrets and covers known-host persistence
- [x] 3.8 Create `ADR-0006-openspec-approval-workflow.md` and verify it records command visibility, read-only discovery policy and explicit approval gates
- [x] 3.9 Create `ADR-0007-package-based-clean-architecture.md` for Surf Terminal, mark ADR-0001 as `Superseded` with a reciprocal link, and verify the new ADR records package ownership, dependency direction, explicit pages and rejected alternatives
- [x] 3.10 Create `ADR-0008-sqflite-and-secure-storage.md`, mark ADR-0005 as `Superseded` with reciprocal links, update the ADR index, and verify the new ADR records versioned SQLite migrations, constraints, repository tests and separate secure storage
- [x] 3.11 Review ADR-0002 through ADR-0008 and the ADR index, and verify every active ADR is framed as a decision for Surf Terminal rather than a copied decision about a reference project

## 4. Verification

- [x] 4.1 Compare `AGENT.md` and all ADRs against proposal, design and `project-development-governance` requirements, and verify every requirement is represented without introducing implementation outside the approved scope
- [x] 4.2 Verify ADR filenames use unique sequential numbers and kebab-case slugs, every ADR contains all required sections, dates reflect the apply date and the README index links resolve
- [x] 4.3 Verify only `AGENT.md`, `docs/adr/*` and OpenSpec tracking artifacts are changed, confirm `pubspec.yaml`, source code and platform projects remain untouched, and present the completed documents for user review
