# ADR-0009: Surf Terminal presentation system

Status: Accepted
Date: 2026-09-26

## Context

Surf Terminal needs a complete mobile presentation layer for SSH profiles, terminal workspaces, SFTP browsing, snippets, and settings before production transports and persistence are connected. The interface must preserve explicit route-level pages, work on compact and expanded surfaces, remain testable without network access, and establish an original product identity rather than reproducing another terminal application's branding or assets.

## Decision

Use Material 3 as the cross-platform foundation for an original Surf Terminal presentation system. Central theme code defines the dark and light color schemes, spacing, radii, typography, and shared component treatment. Route-level surfaces live under `lib/ui/pages`, reusable presentation components live under `lib/ui/shared`, and router, state, and theme composition live under `lib/ui/app`.

The root shell exposes SSH, SFTP, Snippets, and Settings through adaptive bottom navigation on compact surfaces and a navigation rail on expanded surfaces. Editors and the terminal workspace are separate routes above the shell. Presentation state is injected through Flutter BLoC/Cubit boundaries; widgets do not resolve dependencies from GetIt.

Until transport and persistence changes are separately approved, interactions operate only on safe in-memory fixtures. Terminal and SFTP surfaces identify themselves as offline or non-networked previews. Fixtures use fictional labels, documentation domains, and reserved IP ranges, and contain no passwords, private keys, passphrases, copied screenshots, or user data.

## Alternatives

- Build a pixel-perfect clone of a reference SSH client. Rejected because it would weaken Surf Terminal's identity and risk copying proprietary branding, assets, geometry, and product-specific behavior.
- Use one non-routed `IndexedStack`. Rejected because editors, terminal workspaces, branch state, and future deep links require explicit routes.
- Put all presentation widgets in feature folders without an explicit pages boundary. Rejected because Surf Terminal's architecture requires route-level surfaces to be immediately discoverable under `lib/ui/pages`.
- Connect real SSH, SFTP, SQLite, and secure-storage implementations during this UI change. Rejected because those side effects require internal contracts, adapters, security review, and separate OpenSpec approval.

## Consequences

Surf Terminal gains one visual language, explicit page ownership, adaptive navigation, and deterministic widget and golden tests. Presentation behavior can be reviewed without credentials, network access, or device storage, and later production adapters can replace fixtures without moving route-level UI.

The current UI must not be represented as a working SSH/SFTP client: state resets between runs and no remote or persistence side effect is available. Theme or shell-wide visual changes require updating representative goldens. Future transport and persistence work must preserve the offline-preview distinction until real state machines and adapters are connected and verified.
