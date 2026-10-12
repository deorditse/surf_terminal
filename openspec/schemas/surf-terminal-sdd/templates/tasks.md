# Tasks: <change title>

## 1. Baseline and RED

- [ ] 1.1 Capture git/OpenSpec baseline and verify the approved scope excludes unrelated user changes — outside requirements
- [ ] 1.2 Add or update the focused automated scenario for <requirement>, run `<RED command>`, and record failure caused by the missing/incorrect behavior — <requirement>

## 2. Domain and Business

- [ ] 2.1 Implement the approved domain contract/value/failure changes and verify focused pure-Dart tests pass — <requirement or not affected>
- [ ] 2.2 Implement explicit Freezed BLoC events/states, concurrency, cancellation, and disposal, then verify focused BLoC tests pass — <requirement or not affected>

## 3. Data and Runtime Adapters

- [ ] 3.1 Implement persistence/secure-storage/SSH adapter changes behind domain contracts and verify repository/adapter tests pass without real user credentials — <requirement or not affected>
- [ ] 3.2 Verify host-key checks, secret isolation, sanitized errors/logs, migration/partial-failure behavior, and loopback SSH integration as applicable — <requirement or not affected>

## 4. UI and Terminal

- [ ] 4.1 Implement Cupertino-first page/dialog/lifecycle behavior through injected business/domain APIs and verify focused widget tests pass — <requirement or not affected>
- [ ] 4.2 Verify terminal stream, focus, software keyboard, toolbar input, safe-area/IME resize, scrolling, semantics, and affected goldens as applicable — <requirement or not affected>

## 5. GREEN and Generated Code

- [ ] 5.1 Run `<GREEN command>` for each RED scenario and verify the approved behavior plus relevant regressions pass — <requirements>
- [ ] 5.2 Run `dart run build_runner build` when annotations changed, verify the generated inventory is non-empty and reproducible, and never edit generated files manually — outside requirements / not required
- [ ] 5.3 Run `test/architecture/layout_boundaries_test.dart` and related convention checks; verify forbidden imports/service-locator access are absent — outside requirements

## 6. Platform and Environment Evidence

- [ ] 6.1 Run applicable Android/iOS builds and verify the current checkout compiles on each required platform — outside requirements / not required
- [ ] 6.2 Run required device/emulator keyboard smoke and/or disposable localhost SSH harness, record prerequisites and actual result separately from default tests, and do not count skipped evidence as passed — <requirement or not required>

## 7. Context and Final Gates

- [ ] 7.1 Update AGENT.md, rules.md, ADRs, docs, canonical references, and OpenSpec traceability only where the approved behavior/decision changed; verify no stale contradiction remains — outside requirements
- [ ] 7.2 Run `dart format --set-exit-if-changed .`, `flutter analyze`, and `flutter test`; report environment-gated checks and pre-existing failures separately — outside requirements
- [ ] 7.3 Run strict OpenSpec validation/status, review the final scoped diff and secret scan, reconcile every checkbox with evidence, and explicitly report “ready for separate archive approval” or “continue work” — outside requirements
