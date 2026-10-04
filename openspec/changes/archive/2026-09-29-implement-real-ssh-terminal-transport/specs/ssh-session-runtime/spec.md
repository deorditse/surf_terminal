# Spec Delta

## Purpose

Defines the observable lifecycle and trust requirements for establishing, maintaining, and ending real SSH connections without hiding security decisions or network failures.

## ADDED Requirements

### Requirement: SSH connection lifecycle is explicit
Surf Terminal SHALL represent each real SSH session with explicit disconnected, connecting, verifying-host-key, authenticating, connected, reconnecting, and failed states. The interface MUST NOT display connected before server identity and user authentication have both succeeded.

#### Scenario: User selects a persisted profile
- **WHEN** the user selects an SSH profile from the home screen
- **THEN** a session enters connecting state and the terminal route shows current connection progress rather than synthetic output

#### Scenario: Authentication succeeds
- **WHEN** host-key verification and SSH authentication complete successfully
- **THEN** the session enters connected state and opens a remote interactive shell

#### Scenario: Connection fails
- **WHEN** DNS, TCP, protocol negotiation, authentication, or shell creation fails
- **THEN** the session enters a typed failure state with a safe actionable message that contains no credential material

### Requirement: Server host keys are verified before authentication
Every production SSH connection MUST supply a host-key verifier. An unknown host key SHALL require explicit confirmation of host, port, algorithm, and fingerprint before authentication continues. A changed fingerprint MUST block the connection and MUST NOT be silently accepted or overwritten.

#### Scenario: Host key is seen for the first time
- **WHEN** a server presents a valid host key for an endpoint with no known-host record
- **THEN** the session pauses in verifying-host-key state until the user trusts or rejects the displayed fingerprint

#### Scenario: User trusts a new fingerprint
- **WHEN** the user explicitly trusts the unknown fingerprint
- **THEN** the known-host record is persisted and that connection may continue to authentication

#### Scenario: Fingerprint matches the known host
- **WHEN** the server presents the same algorithm and fingerprint stored for that host and port
- **THEN** verification succeeds without prompting and authentication continues

#### Scenario: Fingerprint changed
- **WHEN** the presented fingerprint differs from the stored known-host record
- **THEN** connection is blocked with a high-severity warning and replacement requires a separate explicit user action

### Requirement: Authentication uses only transient credential access
The SSH runtime SHALL request a credential only when authenticating and SHALL keep it in memory for the minimum practical duration. Authentication failures MUST NOT reveal whether a stored password exists, echo password contents, or include secrets in diagnostics.

#### Scenario: Remembered password exists
- **WHEN** authentication starts for a profile with a secure credential reference
- **THEN** the runtime retrieves the password from secure storage and authenticates without showing or copying it into serialized state

#### Scenario: Password is not remembered
- **WHEN** a selected profile has no saved credential
- **THEN** the user is prompted for a password that is used for the connection without persistence unless secure saving is explicitly selected

#### Scenario: Password is rejected
- **WHEN** the server rejects password authentication
- **THEN** the session enters a safe authentication failure state and offers retry without logging or redisplaying the attempted password

### Requirement: Reconnect is bounded, visible, and cancellable
Unexpected transport loss MAY trigger a bounded reconnect policy with visible attempt state. Authentication failures, host-key failures, and manual disconnect MUST NOT trigger automatic reconnect.

#### Scenario: Connected socket is interrupted
- **WHEN** an active session loses transport unexpectedly
- **THEN** the session enters reconnecting state and performs at most three backoff attempts while allowing immediate cancellation

#### Scenario: Retry budget is exhausted
- **WHEN** all reconnect attempts fail
- **THEN** the session enters failed state and offers an explicit manual retry

#### Scenario: User disconnects
- **WHEN** the user requests disconnect or closes the terminal session
- **THEN** pending retries are cancelled, shell and socket resources are closed, and no automatic reconnect starts
