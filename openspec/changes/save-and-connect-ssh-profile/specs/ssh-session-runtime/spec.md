# Spec Delta

## MODIFIED Requirements

### Requirement: SSH connection lifecycle is explicit
Surf Terminal SHALL represent the single active real SSH session with explicit disconnected, connecting, verifying-host-key, authenticating, waiting-for-password, waiting-for-external-authentication, connected, reconnecting, and failed states. During incomplete setup the terminal route SHALL show a centered `CupertinoActivityIndicator` and concise lifecycle label. After PTY/shell creation, remote stdout and stderr SHALL be forwarded verbatim to xterm in transport delivery order. Local DNS, transport, protocol, host-key, authentication and PTY/shell failures SHALL use safe normalized Cupertino-first lifecycle messages outside the remote xterm buffer. An explicit repeated server password challenge SHALL use an obscured `CupertinoAlertDialog` over the terminal route and MUST NOT echo password material into xterm or observable workflow state. A Tailscale check-mode challenge SHALL open only a strictly validated `https://login.tailscale.com/a/<opaque-token>` URI in the external system browser, keep its raw banner and URI ephemeral, and continue the current SSH authentication attempt when possible. The interface MUST NOT display connected or expose an interactive terminal before server identity, user authentication and remote PTY/shell creation have succeeded.

#### Scenario: Server requests another password
- **WHEN** password authentication is rejected and the SSH server explicitly permits another password or password-classified keyboard-interactive response
- **THEN** an obscured lifecycle-safe dialog appears over the terminal route, retention is enabled by default, and submitted text returns only to the pending SSH authentication callback

#### Scenario: Password challenge is cancelled
- **WHEN** the user cancels the secure password dialog
- **THEN** authentication ends in a safe actionable state without writing the prompt or password to terminal output, profile fields, routes, persistence logs or BLoC state

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

#### Scenario: Remote shell emits stdout and stderr
- **WHEN** connected remote PTY/shell emits ordinary output, error output or ANSI/control sequences
- **THEN** the session output contract forwards the exact payloads to xterm in transport delivery order without application rewriting or lifecycle decoration

#### Scenario: Connection fails
- **WHEN** DNS, TCP, protocol negotiation, authentication or shell creation fails
- **THEN** the session enters a centered actionable terminal-style failure state with retry and return controls and a safe normalized message containing no credential, prompt, raw banner or one-time URL material, and that local failure is not appended to xterm
