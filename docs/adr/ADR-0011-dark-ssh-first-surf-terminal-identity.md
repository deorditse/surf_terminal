# ADR-0011: Dark SSH-first Surf Terminal identity

Status: Accepted
Date: 2026-09-27

Supersedes: [ADR-0009](ADR-0009-surf-terminal-presentation-system.md)

## Context

Surf Terminal has narrowed its primary mobile product surface to SSH connections, snippets, and settings. The initial presentation prototype included SFTP, seeded demonstration hosts, light/system theme paths, and generic platform launch assets. Those choices no longer match the product scope or the requirement that first launch contain only user-created connections.

The application also needs a coherent original identity at launch and on the device home screen without copying xTerminal branding, screenshots, icons, or assets.

## Decision

Use a dark-only Material 3 presentation system with Surf Terminal's ocean palette, wave motif, and terminal prompt mark. The primary shell contains only SSH, Snippets, and Settings on both compact bottom navigation and expanded navigation rail layouts. SFTP is removed from routes, navigation, presentation, business logic, data, domain contracts, and tests.

The default SSH profile repository is empty. SSH home shows a branded create-host state until the user creates a profile. Until the separately approved real-transport change is implemented, opening an explicitly injected or user-created profile is labeled as an offline preview and never claims a successful network connection.

Generate native launch resources from original `assets/branding/splash-mark.png` and `assets/branding/splash-branding.png` with `flutter_native_splash`. Generate iOS and Android launcher icons from the original Surf wave/prompt artwork with `flutter_launcher_icons`. The iOS master icon has no alpha channel; Android uses a dark adaptive background and a transparent safe-zone foreground. Generated platform resources are produced by the tools and are not edited manually.

## Alternatives

- Retain light and system theme modes. Rejected because the approved product identity is dark-only and separate theme modes increase unsupported visual states.
- Keep SFTP as a hidden route or future placeholder. Rejected because removed capabilities must not remain reachable or imply availability.
- Seed fictional SSH cards for visual richness. Rejected because the home screen must represent only connections the user created.
- Reuse xTerminal or supplied third-party launch artwork. Rejected because Surf Terminal requires an original brand and independent assets.
- Hand-maintain every platform icon and splash rendition. Rejected because deterministic generators reduce omissions and make platform output reproducible.

## Consequences

The app launches and renders consistently in a dark Surf identity, presents an honest empty-first SSH experience, and avoids unsupported SFTP or light-theme surfaces. Platform projects gain generated splash and launcher resources that must be regenerated when branding configuration changes.

Golden tests intentionally change for all representative surfaces. Brand assets and generated resources increase repository size. Real SSH transport, persistence, credentials, and host-key verification remain governed by their separate OpenSpec change and must replace offline labels only after verified implementation.
