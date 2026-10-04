# Spec Delta

## Purpose

Defines how SSH passwords are remembered, retrieved, replaced, and removed using platform-backed secure storage without entering ordinary structured data or diagnostics.

## ADDED Requirements

### Requirement: Remembered passwords use platform secure storage
A remembered SSH password MUST be stored only through platform-backed secure storage using iOS Keychain and Android Keystore-backed encryption. Structured storage SHALL contain at most an opaque credential reference and non-secret availability metadata.

#### Scenario: User saves a password securely
- **WHEN** the user saves a profile with secure password retention enabled
- **THEN** the password is written to secure storage and no password value is written to SQLite, logs, analytics, crash metadata, serialized workflow state, or route arguments

#### Scenario: Secure storage write fails
- **WHEN** the platform cannot persist the password
- **THEN** profile save does not claim that automatic authentication is available and the user receives a safe recoverable error

### Requirement: Password retention is explicit and reversible
The connection editor SHALL visibly identify whether a password will be remembered securely. New password-based profiles SHALL default to secure retention enabled, while the user SHALL be able to disable retention or explicitly remove an existing saved password.

#### Scenario: User disables retention before saving
- **WHEN** the user turns off secure password retention
- **THEN** the entered password is not persisted and later connections require transient entry

#### Scenario: Existing profile has a saved password
- **WHEN** the user edits that profile
- **THEN** the actual password is never prefilled or revealed and the editor shows only a non-secret saved-password indicator

#### Scenario: User replaces a saved password
- **WHEN** the user enters a new password and saves with retention enabled
- **THEN** the prior secure value is replaced atomically from the application's perspective

#### Scenario: User removes a saved password
- **WHEN** the user explicitly clears remembered authentication
- **THEN** the secure entry is deleted and the profile remains usable with transient password prompting

### Requirement: Secret identifiers are non-sensitive and collision-safe
Secure entries SHALL use opaque application-scoped identifiers derived from stable profile identity rather than host, username, display name, or password content. The application MUST NOT enumerate or export secrets as part of profile backup behavior.

#### Scenario: Profile endpoint is renamed
- **WHEN** host, username, or display name changes without changing profile identity
- **THEN** the credential reference remains stable and does not encode the old or new endpoint

#### Scenario: Diagnostic output is captured
- **WHEN** storage or authentication errors are logged in debug or release operation
- **THEN** output contains neither secret values nor secure-storage payloads

### Requirement: Secret access follows mobile lifecycle constraints
Secure values SHALL be requested only for profile save, authentication, replacement, or deletion and SHALL not remain in long-lived presentation state. Platform configuration MUST prevent insecure Android backup restoration of secure-storage ciphertext and MUST use an appropriate iOS Keychain accessibility class.

#### Scenario: Application returns from background
- **WHEN** a reconnect requires authentication after suspension
- **THEN** the credential is read again through the secure-store contract rather than retained indefinitely in UI or global state

#### Scenario: Device restores an Android backup
- **WHEN** application data is restored on a device without the original Keystore key
- **THEN** excluded secure-storage data does not produce a falsely usable remembered password
