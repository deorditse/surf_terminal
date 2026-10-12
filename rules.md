# Surf Terminal Operational Rules

`AGENT.md` is authoritative. Canonical behavior is in `openspec/specs/`; rationale is in accepted `docs/adr/`. This file is the short checklist for daily implementation. On conflict, follow canonical specs, then accepted ADRs, then `AGENT.md`, then this file.

## 1. Before editing

- Read the active change under `openspec/changes/<change>/`, `AGENT.md`, relevant canonical specs, applicable ADRs, and the live source/tests.
- Capture `git status`; never overwrite unrelated user changes.
- Verify paths, symbols, dependencies, commands, and package versions from the repository instead of guessing.
- Planning approval, apply approval, and archive approval are separate.
- Stop for a planning update if implementation changes scope, behavior, architecture, security, migration, compatibility, or acceptance criteria.

## 2. File placement

- `lib/domain_layout`: pure Dart entities, values, failures, result types, policies, and contracts.
- `lib/business_layout`: BLoCs, events, states, use cases, and orchestration; domain dependency only.
- `lib/data_layout`: DTOs, mappers, sqflite, protected storage, SSH, and platform adapters; domain dependency only.
- `lib/ui_layout/app`: bootstrap, lifecycle, router, theme, and concrete dependency composition.
- `lib/ui_layout/pages`: routed pages and page-local widgets.
- `lib/ui_layout/shared`: only genuinely reused presentation components.
- UI/BLoCs MUST NOT import concrete data adapters. Domain MUST NOT import Flutter or infrastructure.

## 3. BLoC and generated models

- Use explicit immutable events/states; prefer Freezed unions when consistent with neighbouring code.
- Inject contracts through constructors/providers; no hidden infrastructure lookup.
- Select `droppable`, `restartable`, or `sequential` intentionally when event ordering matters.
- Reject stale async completions and dispose every owned stream/session/controller.
- Never edit `*.freezed.dart` or `*.g.dart` manually.
- After annotation changes run `dart run build_runner build` and verify generation is non-empty and reproducible.

## 4. SSH, security, and persistence

- Keep dartssh2 types in `data_layout`; expose domain-owned session types.
- Production host verification is mandatory. Unknown hosts require explicit fingerprint confirmation; mismatches block connection.
- Passwords, private keys, passphrases, and tokens belong only in protected storage or short-lived memory.
- SQLite stores structured non-secrets and opaque secret references only.
- No secrets in state `toString()`, logs, fixtures, screenshots, exceptions, or persisted terminal history.
- Preserve useful remote/SSH error meaning in terminal output while redacting secret material.
- Database schema changes require transactional migrations and upgrade tests.
- Automated SSH tests use fakes or a disposable localhost harness, never user credentials or public hosts.

## 5. Cupertino and terminal UI

- Keep `CupertinoApp.router` as the app root.
- Prefer Cupertino app chrome. Isolate any Material compatibility wrapper to the smallest necessary boundary.
- Keep terminal pages strictly dark, continuous with the background, and as close to full-screen as possible.
- Compact terminal controls are icon-only overlays where understandable; provide semantics/tooltips.
- Transparent management app bars allow content to scroll underneath.
- Preserve terminal focus, selection, scrolling, software/hardware keyboard input, IME resize, safe areas, and accessibility.
- Enter sends exactly one carriage return byte (`13`).
- Update goldens only for an approved visual change and inspect the rendered result.

## 6. RED → GREEN

- For deterministic production behavior, add one focused test first and run it to the expected RED failure.
- Implement the smallest approved slice, run GREEN, then relevant regressions.
- Bug fixes keep the reproducing test as regression coverage.
- Configuration/docs/generated/device-only work may use justified substitute evidence only when recorded in design/tasks.
- A skipped or unavailable device/external check is not a pass.

## 7. Verification

Default gates:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
openspec validate "<change>" --strict
```

As applicable:

```bash
dart run build_runner build
flutter pub get
flutter pub outdated
flutter build apk --debug
flutter build ios --debug --no-codesign
```

Also run focused BLoC/adapter/architecture/widget/golden/integration checks named by `tasks.md`. Report actual results and pre-existing failures separately.

## 8. Requires separate approval

- Creating/editing OpenSpec planning artifacts, apply, and archive.
- Dependency or build-pipeline changes.
- Security, credential, host-trust, session lifecycle, or persistence-policy changes.
- Breaking route/domain/storage contracts and migrations.
- Bulk deletion, destructive external-system operations, commit/push/history rewrite.
- Mass refactors or visual redesign outside the approved change.

At completion reconcile every checkbox with evidence and state one outcome: **ready for separate archive approval** or **continue work**.
