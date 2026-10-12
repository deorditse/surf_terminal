# Spec Delta: <capability>

<!-- New capability only: add a 50+ character `## Purpose` before ADDED Requirements.
     Existing capability deltas must not add Purpose. -->

## ADDED Requirements

### Requirement: <stable requirement name>
The system MUST <observable, testable behavior without implementation details>.

#### Scenario: <successful or primary behavior>
- **GIVEN** <initial state>
- **WHEN** <user/system action>
- **THEN** <observable result>

#### Scenario: <error, cancellation, empty, retry, or lifecycle behavior>
- **GIVEN** <initial state>
- **WHEN** <action or failure>
- **THEN** <safe and observable result>

## MODIFIED Requirements

<!-- Copy each canonical requirement in full, including every existing scenario,
     then edit it. Partial MODIFIED blocks replace and lose omitted content on archive. -->

## REMOVED Requirements

### Requirement: <exact removed requirement name>
**Reason:** <why the behavior is removed>
**Migration:** <how users/callers/data move forward>

## RENAMED Requirements

- **FROM:** `<old exact requirement name>`
- **TO:** `<new requirement name>`

## Non-goals

- <Behavior explicitly outside this capability delta>

## Verification Traceability

| Requirement | Automated evidence | Environment/manual evidence |
| --- | --- | --- |
| `<requirement name>` | `<focused test or static/schema check>` | `<device/harness smoke or not required>` |
