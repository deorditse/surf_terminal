# Proposal: <change title>

## Why

<Explain the problem or opportunity in 1–2 paragraphs and why it matters now.>

## What Changes

- <Observable or governance change 1>
- <Observable or governance change 2>
- **BREAKING** <Compatibility break and migration expectation, if any>

## Non-goals

- <Explicitly excluded behavior, platform, refactor, or follow-up>

## Affected Surfaces

List only surfaces actually affected after inspecting the repository:

- Domain contracts/entities/values/failures: `lib/domain_layout/...`
- Business workflows/BLoCs: `lib/business_layout/...`
- Data adapters/persistence/SSH: `lib/data_layout/...`
- App composition/routes/theme: `lib/ui_layout/app/...`
- Pages/page-local UI: `lib/ui_layout/pages/...`
- Reused presentation: `lib/ui_layout/shared/...`
- Tests/harnesses: `test/...`, `integration_test/...`
- Platforms/assets/docs/OpenSpec: `<paths or “not affected”>`

## Capabilities

### New Capabilities

- `<capability-path>`: <behavior contract introduced by this change>

### Modified Capabilities

- `<existing-capability-path>`: <requirement whose behavior changes>

<!-- If no behavior requirement changes, remove both placeholder bullets, set
     skip_specs: true in .openspec.yaml, and explain why this is non-behavioral. -->

## Impact

- Security, credentials, host trust, logs: <impact or “not affected”>
- Persistence and migrations: <impact or “not affected”>
- UI, accessibility, terminal focus/keyboard: <impact or “not affected”>
- Dependencies and generated code: <impact or “not affected”>
- Compatibility and migration: <impact or “not affected”>
- Automated verification: <unit/BLoC/adapter/widget/golden/architecture gates>
- Environment-gated verification: <loopback SSH/platform/device smoke or “not required”>
- Active changes/ADRs/docs: <coordination required>
