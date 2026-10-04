# Spec Delta

## MODIFIED Requirements

### Requirement: SSH connection lifecycle is explicit
Surf Terminal SHALL represent the single active real SSH session with explicit disconnected, connecting, verifying-host-key, authenticating, waiting-for-external-authentication, connected, reconnecting, and failed states. During incomplete setup the terminal route SHALL show a centered `CircularProgressIndicator` and concise lifecycle label. A Tailscale check-mode challenge SHALL open only a strictly validated `https://login.tailscale.com/a/<opaque-token>` URI in the external system browser, keep its raw banner and URI ephemeral, and continue the current SSH authentication attempt when possible. The interface MUST NOT display connected or expose an interactive terminal before server identity, user authentication and remote PTY/shell creation have succeeded.

#### Scenario: User selects a persisted profile
- **WHEN** the user selects an SSH profile from the home screen
- **THEN** any previous active session is closed, the new session enters connecting state, and the terminal route shows centered real connection progress rather than synthetic output

#### Scenario: User connects a new profile
- **WHEN** local validation succeeds after the user submits a new profile with `Connect`
- **THEN** its session enters connecting state immediately without waiting for profile persistence and the terminal route shows centered connection progress

#### Scenario: Connection advances
- **WHEN** the session moves through connecting, verifying-host-key, authenticating or reconnecting
- **THEN** the centered progress label reflects the actual current lifecycle state without a synthetic delay or persistent status row

#### Scenario: Trusted Tailscale check is required
- **WHEN** SSH authentication emits one user-auth banner containing the expected Tailscale check marker and one URI with `https` scheme, exact `login.tailscale.com` host, no user info, no explicit port, no query, no fragment, and a valid `/a/<opaque-token>` path
- **THEN** the session enters waiting-for-external-authentication, shows centered progress, and opens that URI in the external system browser without placing the raw banner or URI in route, BLoC state, persistence or logs

#### Scenario: Server banner contains an untrusted URI
- **WHEN** an SSH banner contains an alternate scheme, host, port, credentials, query, fragment, malformed path, multiple candidate URIs or lacks the expected Tailscale marker
- **THEN** Surf Terminal does not open it and transitions to a safe actionable authentication failure without rendering or persisting the URI

#### Scenario: Browser authentication completes on the pending transport
- **WHEN** the system browser check succeeds while the original SSH authentication attempt remains alive
- **THEN** Surf Terminal keeps that attempt, receives its authentication success and proceeds to PTY/shell without opening a duplicate transport

#### Scenario: Original attempt ends during browser authentication
- **WHEN** the app returns from the browser after the original transport or bounded external-auth wait ended
- **THEN** Surf Terminal disposes stale resources and performs at most one automatic fresh attempt with mandatory host-key verification before exposing the terminal

#### Scenario: User cancels browser authentication
- **WHEN** the user cancels the waiting external-authentication state
- **THEN** the current attempt closes, the ephemeral challenge is erased and no automatic retry starts

#### Scenario: Authentication succeeds
- **WHEN** host-key verification and SSH authentication complete successfully and the server grants the PTY/shell
- **THEN** the session enters connected state and exposes the expanded remote interactive terminal

#### Scenario: Connection fails
- **WHEN** DNS, TCP, protocol negotiation, authentication or shell creation fails
- **THEN** the session enters a centered actionable failure state with retry and return controls and a safe message containing no credential material
