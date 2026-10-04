# Proposal

## Why

Surf Terminal currently saves profiles only for the running process and opens a synthetic offline terminal. Users need persisted SSH profiles that connect to real servers, retain an explicitly saved password in platform secure storage, verify server identity, and open an interactive terminal directly from the SSH home screen.

## What Changes

- Replace the offline-only profile launch path with a real SSH session lifecycle that exposes connecting, host-key verification, authentication, connected, reconnecting, disconnected, and failure states.
- Replace all handwritten feature Cubits with explicit `Bloc<Event, State>` workflows and Freezed sealed event/state unions, including profiles, snippets, settings, terminal tabs, and SSH sessions.
- Persist non-secret SSH profile and known-host metadata in SQLite so user-created connections survive application restarts.
- Store remembered passwords only in iOS Keychain or Android Keystore-backed secure storage; keep only opaque secret references in structured profile data.
- Make selecting a profile on SSH home start a connection immediately when a remembered password exists, while prompting safely when it does not.
- Require explicit trust for an unknown host key and block changed fingerprints until the user makes a deliberate replacement decision.
- Replace the synthetic viewport with an interactive terminal emulator connected to a remote PTY, including tap-to-focus system keyboard activation, input, output, resize, common mobile keys, disconnect, and bounded reconnect behavior.
- Add layered tests plus an integration test against a disposable loopback SSH server; never place real credentials or user endpoints in fixtures, logs, screenshots, or goldens.
- Keep xTerminal as a functional reference only; Surf Terminal retains original branding, assets, architecture, and interaction details.

## Capabilities

### New Capabilities

- `ssh-session-runtime`: Real SSH connection lifecycle, host-key verification, authentication, disconnect, and bounded reconnect behavior.
- `ssh-profile-persistence`: Durable non-secret SSH profiles and known-host records, including immediate connection selection from SSH home.
- `secure-ssh-credentials`: Platform-backed password retention, retrieval, replacement, and deletion without secret leakage.
- `interactive-ssh-terminal`: Interactive remote PTY rendering, input, output, resize, multi-session ownership, and lifecycle behavior.

### Modified Capabilities

None. The active presentation change explicitly limits its offline behavior until a separately approved transport change; these new runtime capabilities provide that separate implementation without changing canonical governance requirements.

## Impact

- Domain: asynchronous profile, known-host, credential, SSH session, terminal stream, and typed failure contracts.
- Business: Freezed `Bloc<Event, State>` workflows for persistent profiles, snippets, settings, terminal tabs, and per-session lifecycle control with explicit event concurrency, user-mediated host-key decisions, and reconnect policy.
- Data: `sqflite`, `flutter_secure_storage`, and `dartssh2` adapters hidden behind domain contracts.
- UI: connection editor secret controls, SSH-home connect flow, host-key dialogs, real `xterm` viewport, connection status, retry, and disconnect actions.
- Platform: Android network and secure-storage backup policy; iOS Keychain entitlements/configuration as required by the selected plugin.
- Dependencies: latest stable compatible `dartssh2`, `xterm`, `flutter_secure_storage`, `sqflite`, `freezed_annotation`, `freezed`, `build_runner`, and `bloc_concurrency` versions, pinned without `any` or dependency overrides.
- Generated code: Freezed outputs are produced by `build_runner`, checked by generation verification, and never edited manually.
- Documentation: a project-specific ADR that applies the already accepted transport and persistence decisions to concrete contracts, trust flow, secret lifecycle, and verification.
