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
- Maximize connected terminal space with an edge-to-edge canvas by removing server tabs, the ordinary AppBar, the persistent status row and the opaque toolbar band.
- Render real lifecycle progress and failures as centered route states.
- Expose exactly one host-create action in the Connections `CupertinoNavigationBar` and remove FAB/empty-state duplication and Hero-tag collisions.
- Give management screens a restrained glass/server-infrastructure identity while keeping the terminal canvas opaque, dark and familiar to macOS Terminal users; render only compact navigation and special-key controls as floating glass overlays.
- Use Cupertino-first composition for app chrome and management interactions while preserving xterm as the terminal renderer and Liquid Glass as the bounded floating-control layer.
- Default password retention on, handle explicit repeated server password challenges in a secure dialog over the terminal route, and support mobile text selection/copy without leaking transcript data.
- Preserve remote shell stdout/stderr verbatim in xterm while keeping local connection/authentication failures safe and outside the remote terminal buffer.
- Recognize strictly validated Tailscale check-mode challenges, hand them to the system browser without exposing their URL, and continue authentication seamlessly.
- Make transient password input safe across dialog dismissal.
- Preserve separate same-identity edit-save behavior.

**Non-Goals:**

- Persist terminal settings across launches.
- Add general-purpose OAuth, arbitrary server-link handling, an embedded web view or a Tailscale account/API integration.
- Weaken SSH host-key verification, ordinary credential authentication or PTY policies.
- Decorate the terminal viewport with management-screen wave motifs, cards, gradients, badges or marketing copy.
- Add background multi-session navigation, SFTP, SSH key import/generation, jump-host transport or proxy transport. Mobile SSH-key UX is deferred to a separate researched OpenSpec revision.
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

### 5. Terminal lifecycle uses mutually exclusive edge-to-edge standard dark surfaces

The terminal route no longer composes a server tab strip, ordinary AppBar, persistent session status row or opaque bottom toolbar band. A `Stack` paints a flat black/dark-charcoal xterm canvas edge-to-edge behind system insets. Terminal content receives dynamic safe-area and IME padding so glyphs and the input cursor remain reachable, while the opaque canvas itself fills the display. `connecting`, `verifying-host-key`, `authenticating`, `waiting-for-external-authentication` and `reconnecting` render a centered `CupertinoActivityIndicator` and concise state label. `failed` and `disconnected` render centered Cupertino-first actionable states. `connected` renders xterm as `Positioned.fill`; compact top navigation/session actions and bottom special-key/copy actions float in safe-area-aware overlays. Host trust remains an explicit `CupertinoAlertDialog` over the verifying surface.

Alternative considered: overlay progress on an empty terminal. Rejected because an uninitialized terminal implies interactivity before PTY creation. Alternative considered: retain a compact status row, ordinary AppBar or opaque toolbar band. Rejected because each permanently consumes mobile terminal space.

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

### 9. Management surfaces own the glass/server identity and one creation affordance

Connections keeps one `Add host` Cupertino navigation-bar action as the sole route to `/connections/new`. The page has no connection `FloatingActionButton`, and its empty state contains explanatory copy without another action button. This removes the duplicated affordance and also removes one default FAB Hero from the stateful shell. Any remaining legacy Material FAB in another mounted shell branch receives a stable feature-specific `heroTag` or opts out of Hero animation so route transitions cannot discover duplicate default tags until that branch is migrated to a Cupertino action.

The management visual language uses dark-only glass layers with restrained translucency, blur and edge highlights over an opaque ocean-black base. Server-infrastructure cues are limited to subtle rack, node, link and status-light motifs; cyan/teal remains a restrained operational accent. It removes `Local preview`, offline/mock copy and oversized promotional hierarchy. Profile cards, search and sort remain compact and accessible, with endpoint text treated as secondary monospace content and no real endpoint data in goldens. The terminal route never inherits glass or infrastructure decoration.

Alternative considered: keep the extended FAB only. Rejected because the user explicitly selected the AppBar action and the FAB obscures list space. Alternative considered: apply surfer decoration to every route. Rejected because a terminal should remain familiar, dense and distraction-free.

### 10. Prototype contracts are retired without overstating settings durability

The old tabbed workspace and offline synthetic terminal requirements are removed with migrations to the new single full-screen real-session contract. Dark terminal settings continue to apply only within the current run because the settings repository remains in-memory. The mobile special-key toolbar remains canonical.

### 11. Password retention defaults on without changing transient-first launch

Every new-password control starts with secure retention enabled. The user may explicitly disable it before submission. The first attempt still uses a transient opaque reference; the independent persistence branch creates a distinct permanent Keychain/Keystore-backed reference and stores only that reference in SQLite. A default does not permit plaintext in profile entities, SSH configuration objects, routes, BLoC state, logs or terminal output.

### 12. Explicit server password challenges use a secure terminal-route dialog

SSH authentication owns password requests. When the server explicitly permits another password attempt after rejection or issues a keyboard-interactive password prompt, the runtime emits only a non-secret challenge identity and safe prompt classification. UI presents a lifecycle-safe obscured system dialog over the terminal route. Submitted text returns directly to the pending authentication callback through an ephemeral coordinator; it is never written to xterm or modeled as a profile field. Retention is enabled by default, and a successful retained submission replaces the permanent secure reference independently. Cancellation fails the authentication attempt safely; retries are bounded by the server/authentication policy and cannot loop indefinitely.

### 13. Terminal output selection is local-only and macOS-Terminal-like

The connected viewport uses xterm selection/controller APIs: long-press starts selection, drag handles extend it, and the platform context menu exposes `Copy`. `Copy selection` in the floating special-key controls copies only non-empty selected output and announces success accessibly. Selection and copying never send bytes to the SSH session, never persist a transcript and never include hidden password input. The terminal canvas remains flat and opaque with familiar monospace metrics and subdued ANSI-compatible colors; glass is limited to compact controls layered above it.

### 14. Liquid Glass is a presentation-only, bounded control layer

Use `liquid_glass_widgets` `1.8.1` for compact terminal navigation, copy and special-key controls and for the approved management chrome. The package is compatible with the current Flutter toolchain and provides one cross-platform Flutter rendering path for iOS and Android. It MUST remain confined to `ui_layout`; domain, business and data layers do not depend on it. The terminal uses a custom edge-to-edge `Stack` rather than package-owned full-screen backgrounds so the xterm canvas stays authoritative and opaque.

Every glass surface is clipped to its pill/control bounds and uses a bounded area; no full-screen backdrop blur is allowed. Controls use a dark translucent tint, subtle edge highlight and readable foreground contrast over terminal output. When reduced transparency/high contrast is requested, shader quality is unavailable, or runtime performance falls below the acceptance target, the same layout falls back first to a built-in clipped `BackdropFilter` frosted surface and then to an opaque high-contrast surface without changing semantics or hit targets. Reduce Motion disables decorative morph/jelly motion. The implementation records this dependency and fallback decision in a new ADR rather than rewriting accepted ADR history.

Alternatives considered: Flutter `BackdropFilter`/`ImageFilterConfig.blur` alone. Selected as the fallback but not the primary treatment because it provides frosted blur rather than the requested iPhone-like refractive control language. `liquid_glass_renderer` was rejected because its current release is prerelease and explicitly experimental. Native UIKit glass packages were rejected as the shared primary implementation because Surf Terminal also targets Android and platform-view controls add composition and performance costs.

### 15. Remote output and local lifecycle failures remain separate

After PTY/shell creation, both remote stdout and stderr are terminal-owned byte streams. The SSH adapter forwards their payloads to the runtime in transport delivery order, and the runtime writes them to xterm without rewriting wording, stripping ANSI/control sequences, translating errors or wrapping them in application cards. Remote command errors therefore appear exactly where the remote process emitted them and remain selectable/copyable like other terminal output.

DNS, TCP, protocol, host-key, authentication and PTY/shell setup failures are local lifecycle failures rather than remote shell output. They render in the terminal route's macOS-like failure surface using a normalized safe `SshFailure` message and retry/return controls, but are never appended to the xterm buffer. Password prompts, entered secrets, raw auth banners and Tailscale challenge URLs are neither remote output nor displayable lifecycle detail and remain excluded from both surfaces. This separation preserves terminal fidelity without turning raw exceptions into a secret-disclosure channel.

Alternative considered: append every local exception into xterm. Rejected because no remote PTY may exist yet, it falsifies the provenance of terminal output and can expose endpoint, credential or one-time authentication data.

### 16. Application presentation is Cupertino-first

The application root uses `CupertinoApp.router` with a dark `CupertinoThemeData`. Management and editor routes use `CupertinoPageScaffold` and `CupertinoNavigationBar`; user actions, destructive confirmations, password/host-key dialogs, toggles and lifecycle loading prefer `CupertinoButton`, `CupertinoAlertDialog`, `CupertinoSwitch` and `CupertinoActivityIndicator`. Safe transient notices use a Cupertino-compatible overlay owned by app composition instead of `ScaffoldMessenger`/`SnackBar`.

This rule concerns visible application chrome, not every Flutter type import. xterm remains the terminal renderer. `liquid_glass_widgets` remains the primary bounded renderer for floating terminal controls and approved glass management surfaces, with clipped `BackdropFilter` and solid high-contrast fallbacks. A Material widget is allowed only when Flutter exposes no suitable Cupertino equivalent or a dependency requires an interoperability wrapper; every such exception must be narrow, visually neutral and covered by the presentation scan. Shared primitives such as `Color`, `Text`, `Icon`, `SafeArea`, `Form`, `TextEditingController` and layout widgets are not Material presentation exceptions and should be imported from narrower Flutter libraries where practical.

Alternative considered: keep `MaterialApp` and only restyle individual controls to resemble iOS. Rejected because it leaves route scaffolds, navigation, dialogs, progress and feedback semantics Material-first. Alternative considered: ban every `material.dart` import mechanically. Rejected because some framework/dependency interoperability may require a Material type even when no Material visual is rendered; the acceptance criterion targets instantiated production presentation widgets and requires explicit justification for exceptions.

## Risks / Trade-offs

- **[Connection starts but profile persistence fails]** → Keep SSH running, show a safe persistence notice and leave SSH home unchanged rather than claiming durability.
- **[Connection fails before save finishes]** → Allow the independent save to complete and list the profile for correction/retry.
- **[Remembered save and transient runtime duplicate a secret briefly]** → Use separate opaque references, clear form ownership promptly and delete the transient entry on runtime disposal.
- **[Rapid replacement races cleanup]** → Serialize close/open and test that only one runtime, socket and session entry survives.
- **[Dialog dismissal regresses]** → Add a widget test that submits and pumps the complete reverse animation before asserting no framework exception.
- **[Full-screen layout hides lifecycle truth]** → Use mutually exclusive centered progress/failure surfaces driven only by `SshSessionBloc` state; never add synthetic delay.
- **[Glass controls obscure terminal text or reduce performance]** → Keep xterm edge-to-edge and opaque, clip glass work to compact overlay bounds, provide built-in frosted and solid fallbacks, respect reduced motion/transparency/high contrast, profile iOS and Android, and never blur the full glyph grid.
- **[Repeated password prompts leak or loop]** → Keep plaintext in the immediate auth callback boundary, obscure UI, default secure retention on, bound retries and exclude prompt/password data from xterm and observable state.
- **[Terminal copy sends text remotely]** → Separate selection/controller commands from terminal input and assert copied output produces no `SshSessionEvent.inputSent`.
- **[Remote output is rewritten or reordered]** → Keep stdout/stderr on the session output path, test exact payload and ordering including ANSI sequences, and prohibit application error decoration in xterm.
- **[Raw local exceptions leak sensitive data]** → Map lifecycle failures to safe typed messages and assert they render outside xterm while passwords, prompts, banners and challenge URLs remain absent from both UI and durable state.
- **[Material presentation returns during maintenance]** → Add widget/source coverage for the Cupertino root and primary controls, maintain a narrow exception allowlist, and fail on unjustified Material scaffolds, navigation, dialogs, toggles, progress or feedback surfaces.
- **[Duplicate create actions return]** → Assert one `CupertinoNavigationBar` create action and no Connections FAB/empty-state button in empty and populated widget states.
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
4. Migrate the application root and management/editor chrome to Cupertino-first presentation, remove duplicate host-create affordances and FAB Hero collisions, apply the restrained glass/server language, and remove preview/offline copy.
5. Replace AppBar/tabs/status-row/opaque-toolbar composition with an edge-to-edge macOS-Terminal-like opaque canvas, centered Cupertino lifecycle surfaces, safe-area/IME-aware floating Liquid Glass controls, verbatim remote stdout/stderr, isolated safe lifecycle failures, Cupertino password challenge UI and selectable copy actions; add the presentation dependency/ADR only during approved apply, then update only visually reviewed goldens.
6. Run focused persistence, credential, runtime, workspace, external-auth, create-action/Hero and architecture tests; run Android browser/resume lifecycle smoke and AsyncSSH real-protocol challenge integration separately.
7. Run generation reproducibility, formatting, full tests, analysis, Android/iOS builds, secret/size scans and strict OpenSpec validation.
8. After separate archive approval, merge all five deltas and verify the obsolete tabbed/mock canonical requirements are absent.

Rollback restores the prior UI/orchestration while retaining compatible SQLite profiles, known hosts and permanent secure credential references. Any live transient reference is cleaned through runtime disposal before rollback.
