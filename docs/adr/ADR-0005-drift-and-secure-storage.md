# ADR-0005: Separate structured data from secrets

Status: Superseded
Date: 2026-09-26

Superseded by: [ADR-0008](ADR-0008-sqflite-and-secure-storage.md)

## Context

The client needs connection profiles, known-host records, settings, identifiers, and schema migrations. It also handles passwords, private keys, and passphrases. These categories have different query, migration, and security requirements.

A key-value store is insufficient for relational profile/known-host data and migration history. A regular application database is not an acceptable place for raw SSH secrets. Host-key verification must be persistent and independent from credential storage.

## Decision

Use Drift with `drift_flutter` for structured, non-secret application data: connection profiles, known-host metadata, settings, and non-sensitive session metadata. Use explicit migrations and migration tests.

Use `flutter_secure_storage` for passwords, private keys, passphrases, and sensitive tokens. Drift stores only opaque references to secure entries. Domain entities remain free of Drift annotations; data-layer DTOs and mappers bridge persistence and domain.

Known-host records store host, port, algorithm, fingerprint, first-seen, and last-confirmed metadata. Unknown hosts require confirmation before authentication. Fingerprint mismatch blocks connection until an explicit safe user decision.

Terminal transcripts are not persisted by default.

## Alternatives

- **SharedPreferences for all local data.** Rejected because it lacks structured queries, constraints, and reliable schema migrations.
- **Drift for secrets as well as profiles.** Rejected because a normal application database is not a Keychain/Keystore-backed secret store.
- **Secure storage for every field.** Rejected because secure key-value stores are not designed for structured queries and migrations.
- **Do not persist known hosts.** Rejected because users could not detect server-key changes between sessions.

## Consequences

Structured data is queryable and migratable, while secrets receive platform-backed protection. Known-host verification survives restarts without coupling fingerprints to credentials.

Repositories must coordinate two storage systems and handle partial failures. Deleting profiles must also remove referenced secure entries. Database backups must not contain secrets, and secure-storage availability/errors require typed handling.

The separation between structured data and secrets remains valid, but the selected structured persistence library was replaced by sqflite in [ADR-0008](ADR-0008-sqflite-and-secure-storage.md).
