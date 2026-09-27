# ADR-0008: Use sqflite for structured data and secure storage for secrets

Status: Accepted
Date: 2026-09-26

Supersedes: [ADR-0005](ADR-0005-drift-and-secure-storage.md)

## Context

Surf Terminal stores connection profiles, labels, known-host fingerprints, snippets, settings, and non-sensitive session metadata. These records need transactions, constraints, indexed queries, and controlled schema evolution. Passwords, private keys, passphrases, and sensitive tokens require platform-backed protection and must not be placed in an ordinary application database.

The project needs a widely used direct SQLite integration while keeping storage details behind domain-owned repository contracts.

## Decision

Use `sqflite` as the direct SQLite adapter inside `packages/data` for structured, non-secret data. SQL, table names, database DTOs, and sqflite types do not cross the data boundary.

Maintain an explicit schema version. Implement ordered `onCreate` and `onUpgrade` migrations transactionally. Enable foreign keys when opening the database. Test migrations from every supported prior version and cover uniqueness, referential integrity, transactions, and rollback in repository integration tests.

Use `flutter_secure_storage` for passwords, private keys, passphrases, and sensitive tokens. SQLite stores only opaque references to secure entries. Profile deletion coordinates deletion in both stores and reports partial failures through typed domain failures.

Known-host records persist host, port, algorithm, fingerprint, first-seen, and last-confirmed metadata independently from credentials. Unknown fingerprints require explicit confirmation; mismatches block connection pending an explicit safe decision. Terminal transcripts are not persisted by default.

## Alternatives

- **Drift.** It provides compile-time typed queries, reactive streams, migrations, and code generation. Replaced because Surf Terminal selected the more widely used direct SQLite API and accepts responsibility for explicit SQL and migration tests.
- **Hive legacy.** Rejected because its stable package line is not compatible with the project's current Dart SDK.
- **Hive CE.** Rejected because its key-value/document model and fork maintenance model are a weaker fit for related profiles, labels, known hosts, snippets, and schema constraints.
- **SharedPreferences for structured data.** Rejected because it does not provide relational constraints, transactions, or robust schema migrations.
- **SQLite for secrets.** Rejected because an ordinary database is not Keychain/Keystore-backed secret storage.
- **Secure storage for every field.** Rejected because platform secure key-value stores are not designed for relational queries and migrations.

## Consequences

Surf Terminal gets standard SQLite transactions, constraints, and indexing with a small direct adapter surface. Secrets remain protected separately, and domain/business-logic packages stay independent from persistence technology.

Compared with Drift, SQL and row mapping receive fewer compile-time guarantees. The data package must centralize statements, migrations, and mapping and compensate with focused integration and migration tests. Repositories must coordinate two stores, handle partial failures, and ensure backups never contain secrets.
