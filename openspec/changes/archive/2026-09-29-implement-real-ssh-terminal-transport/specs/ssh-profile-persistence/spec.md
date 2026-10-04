# Spec Delta

## Purpose

Defines durable storage and retrieval of non-secret SSH profiles and trusted host metadata so user-created connections remain available safely across application launches.

## ADDED Requirements

### Requirement: User-created SSH profiles persist across launches
Surf Terminal SHALL persist user-created non-secret profile fields in structured local storage. A first launch with no stored profiles SHALL remain empty, and production defaults MUST NOT create demonstration hosts.

#### Scenario: User saves a valid profile
- **WHEN** the user saves name, host, port, username, and supported non-secret options
- **THEN** the profile appears on SSH home and remains available after the application is restarted

#### Scenario: Application has no profiles
- **WHEN** structured storage contains no SSH profiles
- **THEN** SSH home displays the create-host empty state without synthetic connections

#### Scenario: User edits a profile
- **WHEN** the user changes non-secret profile fields and saves
- **THEN** the same profile identity is updated transactionally and subsequent connections use the new endpoint values

### Requirement: Selecting a profile initiates its connection
A primary selection of an SSH profile on the home screen SHALL start a connection for that profile and navigate to its terminal session. Edit and delete SHALL remain separate explicit actions.

#### Scenario: Profile has a remembered password
- **WHEN** the user selects the profile and its secure credential is available
- **THEN** Surf Terminal begins the SSH lifecycle immediately without asking the user to re-enter the password

#### Scenario: Profile has no remembered password
- **WHEN** the user selects the profile and no secure credential is available
- **THEN** Surf Terminal requests a transient password before authentication and does not falsely show connected state

### Requirement: Known-host metadata is durable and endpoint-scoped
Known-host records SHALL store host, port, key algorithm, fingerprint, first-seen timestamp, and last-confirmed timestamp independently from credentials. Matching SHALL be scoped to the normalized host and port.

#### Scenario: User trusts an unknown host
- **WHEN** the user confirms a first-seen fingerprint
- **THEN** the record is saved independently of the password and profile display data

#### Scenario: Profile endpoint changes
- **WHEN** a profile is edited to a different host or port
- **THEN** trust for the former endpoint is not implicitly transferred to the new endpoint

### Requirement: Profile deletion coordinates related records safely
Deleting a profile SHALL remove its structured profile record and request deletion of its associated secure credential. A partial deletion failure MUST be reported and MUST NOT expose the secret.

#### Scenario: Profile and credential deletion succeed
- **WHEN** the user confirms deletion of a profile with a remembered password
- **THEN** the profile disappears from SSH home and its secure credential is removed

#### Scenario: Secure credential deletion fails
- **WHEN** the profile operation cannot remove the related secure entry
- **THEN** Surf Terminal reports a typed cleanup failure and preserves enough non-secret information to retry cleanup safely
