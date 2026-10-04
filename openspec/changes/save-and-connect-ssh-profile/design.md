# Design

## Context

See `proposal.md` for motivation. Production already composes SQLite profiles, platform secure storage, `DartSshSessionFactory`, `SshSessionBloc`, a runtime registry and route-scoped xterm views. The partially applied flow currently waits for `CredentialCoordinator.save` before opening a runtime, keeps multiple runtimes in a tab strip, and renders lifecycle in a persistent status row. The transient password dialog creates a controller outside the dialog subtree and disposes it as soon as `showDialog` completes, which can race the route dismissal animation. `dartssh2` exposes SSH `USERAUTH_BANNER` through `onUserauthBanner`, but the production adapter does not currently subscribe to it and its fixed authentication timeout cannot represent a browser-mediated Tailscale check.

The project remains one Flutter package with Pure DI. Domain and business layers remain Flutter-free; concrete persistence and SSH adapters remain confined to app composition. Passwords MUST NOT enter routes, BLoC events/states, SQLite, logs, fixtures, screenshots or diagnostics.

## Goals / Non-Goals

**Goals:**

- Start real SSH immediately after validation without waiting for profile persistence.
- Persist the new profile and selected credential policy after launch regardless of SSH success or failure.
- Keep secret handling opaque and deterministically clean transient credentials.
- Enforce one active runtime and replace it safely when another connection starts.
- Maximize connected terminal space by removing server tabs and the persistent status row.
- Render real lifecycle progress and failures as centered route states.
- Expose exactly one host-create action in the Connections AppBar and remove FAB/empty-state duplication and Hero-tag collisions.
- Give management screens a restrained dark surfer identity while keeping the terminal screen visually standard, dark and undecorated.
- Recognize strictly validated Tailscale check-mode challenges, hand them to the system browser without exposing their URL, and continue authentication seamlessly.
- Make transient password input safe across dialog dismissal.
- Preserve separate same-identity edit-save behavior.

**Non-Goals:**

- Persist terminal settings across launches.
- Add general-purpose OAuth, arbitrary server-link handling, an embedded web view or a Tailscale account/API integration.
- Weaken SSH host-key verification, ordinary credential authentication or PTY policies.
- Decorate the terminal viewport with management-screen wave motifs, cards, gradients, badges or marketing copy.
- Add background multi-session navigation, SFTP, key import, jump-host transport or proxy transport.
- Rewrite archived OpenSpec changes or accepted ADR history.

## Decisions

### 1. Connection launch and profile persistence are independent outcomes

A valid new-profile submission creates a stable profile identity and starts two ordered branches. The connection branch prepares a transient opaque credential, replaces the current runtime, dispatches real SSH connection and opens the terminal route without awaiting structured profile persistence. After launch has been initiated, an app-scoped orchestration owner starts `CredentialCoordinator.save` for the same profile and selected retention policy. That save continues if DNS, transport, trust, authentication or PTY setup fails.

A persistence failure publishes a safe non-secret notice and refreshes no false saved state, but it does not cancel or downgrade the already-started session. A successful save refreshes SSH home. The two outcomes are reported independently.

Alternative considered: persist before transport. Rejected because the approved UX explicitly requires immediate connection. Alternative considered: persist only after successful SSH. Rejected because the user requires the profile to be saved even when connection fails.

### 2. The first attempt always uses a transient credential reference

The entered password is written only through the transient credential path before transport starts. The runtime receives that opaque reference; neither the password nor the reference is placed in route arguments or serialized BLoC state. If remember is enabled, the independent save branch writes a separate permanent secure entry and persists only its opaque reference for subsequent attempts. If remember is disabled, the saved profile has no permanent credential reference. The runtime-owned transient entry is deleted when the replaced, failed or closed session is disposed.

If transient preparation itself fails, SSH cannot start, but profile persistence is still attempted and the user receives separate safe connection/persistence outcomes. The form-held secret is cleared after both credential operations have captured what they need.

Alternative considered: let the runtime use the permanent reference produced by save. Rejected because it would restore save-before-connect ordering. Passing plaintext through navigation or BLoC is prohibited.

### 3. Connect-first orchestration outlives the editor route

Connection/persistence coordination is owned by app composition rather than a disposable editor widget. It captures only the draft profile, retention intent and opaque references needed for the operation, launches the terminal route, completes persistence, then emits non-secret completion/failure notifications through existing injected workflows. Duplicate submission is guarded until ownership transfers.

Alternative considered: leave an unawaited save closure in the editor state. Rejected because route replacement can dispose the state before persistence completion and make context-based reporting unsafe.

### 4. The runtime registry serializes single-session replacement

Opening a connection first closes and awaits cleanup of every existing runtime, dispatches the matching terminal-session closure, then opens exactly one new runtime. Replacement is serialized so rapid submissions cannot leave two sockets, focus nodes or transient credentials alive. The terminal route binds directly to its requested session identity; no tab selection UI is rendered.

Alternative considered: retain background sessions without tabs. Rejected because it makes active connections inaccessible and contradicts the chosen one-active-session model.

### 5. Terminal lifecycle uses mutually exclusive standard dark full-area surfaces

The terminal body no longer composes a server tab strip or persistent session status row. It uses a flat black/dark-charcoal surface and standard monospace xterm presentation rather than cards, waves, gradients, surfer badges or management-page decoration. `connecting`, `verifying-host-key`, `authenticating`, `waiting-for-external-authentication` and `reconnecting` render a centered `CircularProgressIndicator` and concise state label in the available body. `failed` and `disconnected` render centered actionable states. `connected` renders the xterm viewport expanded to all remaining space plus the existing bottom special-key toolbar. Host trust remains an explicit dialog over the verifying surface.

Alternative considered: overlay progress on an empty terminal. Rejected because an uninitialized terminal implies interactivity before PTY creation. Alternative considered: retain a compact status row. Rejected because it permanently consumes mobile terminal height after connection.

### 6. The password dialog owns its field lifecycle

The transient password prompt becomes a stateful dialog component whose field value/controller is owned and disposed by the dialog widget after its subtree is removed. Submission returns an immutable non-secret decision envelope plus the password only through the immediate callback boundary; dismiss animation cannot reference a controller disposed by the caller.

Alternative considered: delay caller-side dispose with a timer. Rejected because animation timing is framework-dependent and remains race-prone.

### 7. Existing edit and saved-profile flows remain explicit

`Edit host → Save` updates the same identity, never pre-fills a password and does not start a session. Selecting a saved profile uses its permanent credential when available or the lifecycle-safe transient password prompt otherwise, then enters the same single-session replacement path without re-saving unchanged metadata.

### 8. Tailscale browser checks are an explicit ephemeral authentication state

The `dartssh2` backend subscribes to `onUserauthBanner` and forwards banner text only to a narrow parser. A banner becomes a supported external-auth challenge only when it contains the expected Tailscale check marker and exactly one URI satisfying all of these conditions: `https` scheme, exact lowercase host `login.tailscale.com`, no user info, no explicit port, no query or fragment, and raw path matching `/a/<non-empty URL-safe opaque token>`. The parser rejects malformed, ambiguous and lookalike-host input and never falls back to opening an arbitrary URI.

The raw banner and URI are never emitted through BLoC events/states, routes, persistence, analytics or logs. A runtime-scoped external-auth coordinator stores the URI in memory under an opaque challenge reference, asks an injected UI-owned launcher to open it in the external system browser and immediately clears it after success, cancellation, terminal failure or runtime disposal. The observable SSH lifecycle carries only `waitingForExternalAuthentication` plus safe actions such as open-again and cancel. `url_launcher` is the expected platform adapter; an injected contract keeps tests and business/domain layers independent of Flutter plugins.

The existing SSH transport remains authoritative on the happy path. Tailscale holds authentication while the browser check runs and later completes the same user-auth exchange, so Surf Terminal does not proactively disconnect or duplicate the attempt. The adapter replaces the fixed ordinary-auth deadline with challenge-aware bounded timeout ownership: the ordinary deadline applies before a recognized challenge, then an external-auth deadline applies while waiting. Authentication success cancels both and proceeds to PTY/shell.

When the app resumes, it first observes the current attempt. If it is still authenticating, it continues waiting; if it succeeded, no reconnect occurs. If the transport or external-auth wait ended while the browser was foregrounded, the coordinator disposes stale resources and allows exactly one automatic fresh attempt. That fresh attempt re-runs mandatory host-key verification and uses the same opaque credential ownership rules. A second challenge/failure becomes an actionable terminal state rather than an infinite loop. Cancel closes the attempt and suppresses automatic retry.

Alternative considered: always reconnect after browser return. Rejected because it races the still-valid pending authentication and can create duplicate sockets. Alternative considered: receive an OAuth deep-link callback. Rejected because the Tailscale SSH server, not Surf Terminal, observes completion. Alternative considered: render the raw banner in xterm and require manual URL copying. Rejected because it leaks a one-time URL into terminal history and does not provide the approved mobile handoff.

### 9. Management surfaces own the surfer identity and one creation affordance

Connections keeps one `Add host` `IconButton` in the AppBar as the sole route to `/connections/new`. The page has no connection `FloatingActionButton`, and its empty state contains explanatory copy without another action button. This removes the duplicated affordance and also removes one default FAB Hero from the stateful shell. Any remaining FAB in another mounted shell branch receives a stable feature-specific `heroTag` or opts out of Hero animation so route transitions cannot discover duplicate default tags.

The management visual language uses existing dark-only Surf tokens refined into ocean-black/navy backgrounds, restrained cyan/teal focus accents, thin low-contrast outlines and an optional subtle wave/gradient motif confined to non-terminal headers or empty-state illustration. It removes `Local preview`, offline/mock copy and oversized promotional hierarchy. Profile cards, search and sort remain compact and accessible, with endpoint text treated as secondary monospace content and no real endpoint data in goldens.

Alternative considered: keep the extended FAB only. Rejected because the user explicitly selected the AppBar action and the FAB obscures list space. Alternative considered: apply surfer decoration to every route. Rejected because a terminal should remain familiar, dense and distraction-free.

### 10. Prototype contracts are retired without overstating settings durability

The old tabbed workspace and offline synthetic terminal requirements are removed with migrations to the new single full-screen real-session contract. Dark terminal settings continue to apply only within the current run because the settings repository remains in-memory. The mobile special-key toolbar remains canonical.

## Risks / Trade-offs

- **[Connection starts but profile persistence fails]** → Keep SSH running, show a safe persistence notice and leave SSH home unchanged rather than claiming durability.
- **[Connection fails before save finishes]** → Allow the independent save to complete and list the profile for correction/retry.
- **[Remembered save and transient runtime duplicate a secret briefly]** → Use separate opaque references, clear form ownership promptly and delete the transient entry on runtime disposal.
- **[Rapid replacement races cleanup]** → Serialize close/open and test that only one runtime, socket and session entry survives.
- **[Dialog dismissal regresses]** → Add a widget test that submits and pumps the complete reverse animation before asserting no framework exception.
- **[Full-screen layout hides lifecycle truth]** → Use mutually exclusive centered progress/failure surfaces driven only by `SshSessionBloc` state; never add synthetic delay.
- **[Surfer branding reduces terminal readability]** → Confine waves/gradients and decorative identity to management surfaces; enforce a flat dark terminal golden.
- **[Duplicate create actions return]** → Assert one AppBar create action and no Connections FAB/empty-state button in empty and populated widget states.
- **[Stateful shell reports duplicate default FAB Hero tags]** → Remove the Connections FAB and give any remaining mounted FAB a unique feature tag or disable its Hero participation; exercise route transitions in a regression test.
- **[A malicious SSH server emits a phishing URL]** → Require the exact Tailscale marker and strict URI allowlist, reject ambiguous banners, use the external browser and display the trusted hostname before launch.
- **[The one-time URL leaks through diagnostics/state]** → Keep it only in a runtime-scoped ephemeral coordinator behind an opaque challenge reference and add route/state/log/persistence scans.
- **[App suspension closes the pending transport]** → Observe the original attempt on resume and permit one fresh, fully verified retry only after stale cleanup; cancellation and the second failure suppress retry.
- **[Ordinary authentication waits too long]** → Keep a short ordinary deadline and switch to a separate bounded deadline only after a validated challenge.
- **[Widget tests do not prove protocol reality]** → Retain the localhost AsyncSSH production-adapter harness as a separate gate.

## Migration Plan

1. Reset superseded save-before-connect/tabbed-workspace test expectations and add focused RED tests for the revised behavior and controller crash.
2. Implement lifecycle-safe password prompting, app-owned connect/persist orchestration and serialized single-runtime replacement.
3. Add strict Tailscale banner parsing, ephemeral challenge coordination, external-browser launch, challenge-aware timeout ownership and bounded resume continuation.
4. Remove duplicate host-create affordances and FAB Hero collisions, apply the restrained surfer language to management screens, and remove preview/offline copy.
5. Replace tabs/status-row composition with standard dark centered lifecycle surfaces and an expanded undecorated terminal, then update only visually reviewed goldens.
6. Run focused persistence, credential, runtime, workspace, external-auth, create-action/Hero and architecture tests; run Android browser/resume lifecycle smoke and AsyncSSH real-protocol challenge integration separately.
7. Run generation reproducibility, formatting, full tests, analysis, Android/iOS builds, secret/size scans and strict OpenSpec validation.
8. After separate archive approval, merge all five deltas and verify the obsolete tabbed/mock canonical requirements are absent.

Rollback restores the prior UI/orchestration while retaining compatible SQLite profiles, known hosts and permanent secure credential references. Any live transient reference is cleaned through runtime disposal before rollback.
