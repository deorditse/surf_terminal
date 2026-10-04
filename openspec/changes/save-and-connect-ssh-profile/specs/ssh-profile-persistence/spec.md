# Spec Delta

## MODIFIED Requirements

### Requirement: User-created SSH profiles persist across launches
Surf Terminal SHALL persist user-created non-secret profile fields in structured local storage. For a new `Connect` submission, SSH startup SHALL NOT wait for that persistence; save SHALL proceed independently after launch has been initiated and SHALL be attempted regardless of connection success or failure. A first launch with no stored profiles SHALL remain empty, and production defaults MUST NOT create demonstration hosts.

#### Scenario: User saves a valid profile
- **WHEN** the user saves name, host, port, username, and supported non-secret options
- **THEN** the profile appears on SSH home and remains available after the application is restarted

#### Scenario: User creates and connects a valid profile
- **WHEN** the user submits a valid new profile with `Connect`
- **THEN** the real SSH lifecycle starts without waiting for structured profile persistence, and persistence continues independently for the same profile identity

#### Scenario: Connection fails while profile save is pending
- **WHEN** DNS, transport, host-key, authentication or PTY setup fails before profile persistence finishes
- **THEN** persistence still completes or reports its own safe failure, and the connection failure does not roll back a successfully saved profile

#### Scenario: Application has no profiles
- **WHEN** structured storage contains no SSH profiles
- **THEN** SSH home displays the create-host empty state without synthetic connections

#### Scenario: User edits a profile
- **WHEN** the user changes non-secret profile fields and saves
- **THEN** the same profile identity is updated transactionally and subsequent connections use the new endpoint values

#### Scenario: Profile save fails after connection launch
- **WHEN** structured or requested permanent secure credential persistence fails after SSH startup has been initiated
- **THEN** the active SSH lifecycle continues, the interface reports a separate safe persistence error, and SSH home does not falsely claim the profile was saved

## ADDED Requirements

### Requirement: Immediate connection respects credential retention
A new profile connection SHALL authenticate through a transient opaque credential reference prepared for the first attempt. Profile persistence SHALL follow the selected retention policy independently: remembered passwords MUST be stored only through a separate permanent secure-storage reference, while retention-disabled profiles MUST persist without a credential reference. Password material MUST NOT be stored in the profile record, route arguments, serialized workflow state, diagnostics, fixtures or screenshots.

#### Scenario: User connects and remembers a password
- **WHEN** the user submits a new profile with a non-empty password and secure retention enabled
- **THEN** the first SSH attempt starts with a transient credential, a permanent secure reference is saved independently for subsequent connections, and the profile contains only that permanent opaque reference

#### Scenario: User connects without remembering a password
- **WHEN** the user submits a new profile with a non-empty password and secure retention disabled
- **THEN** the first SSH attempt receives a transient credential, the non-secret profile is saved without a credential reference, and subsequent connections request another transient password

#### Scenario: Transient credential preparation fails
- **WHEN** the first-attempt transient credential cannot be prepared
- **THEN** no SSH transport starts, profile persistence is still attempted according to the selected policy, and reported errors contain no secret material
