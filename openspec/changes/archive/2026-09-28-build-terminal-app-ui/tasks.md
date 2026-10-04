# Tasks

## 1. Baseline and scope reconciliation

- [x] 1.1 Capture Git status, current navigation/routes, SFTP symbols, SSH fixture defaults, theme paths and platform launch resources; verify unrelated and generated-like user files are classified before edits
- [x] 1.2 Confirm `implement-physical-clean-architecture` is archived and canonical `*_layout` boundaries are active before UI changes
- [x] 1.3 Resolve the latest stable `flutter_native_splash` and `flutter_launcher_icons` versions compatible with Flutter 3.47.5/Dart 3.13.4 and verify dependency resolution without `any` or overrides

## 2. Remove SFTP completely

- [x] 2.1 Remove SFTP destination and branch from compact/expanded shell navigation and verify only SSH, Snippets and Settings remain with stable branch state
- [x] 2.2 Remove `/sftp` routing and all SFTP pages/widgets, then verify repository-wide route/path scan finds no reachable SFTP UI
- [x] 2.3 Remove SFTP Cubit/state, domain entity/contract, data repository/fixtures, public exports and DI ownership, then verify no SFTP symbol remains in handwritten Dart
- [x] 2.4 Remove/replace SFTP tests and update architecture tests to reject reintroduced SFTP modules, then verify shell and architecture suites pass

## 3. Empty-first SSH profiles

- [x] 3.1 Remove production SSH profile fixtures and make the default profiles repository empty, then verify repository tests distinguish empty default from explicitly injected test data
- [x] 3.2 Refine the dark Surf Terminal SSH empty state and create-host CTA without fake connection cards, then verify the first rendered destination contains no host/IP/username fixture
- [x] 3.3 Preserve create, edit, validation, password reveal and delete workflows, then verify a user-created profile appears and deleting the final profile restores the empty state
- [x] 3.4 Preserve explicit offline terminal-preview language for user-created profiles and verify no UI copy claims a successful live connection
- [x] 3.5 Scan source, tests and regenerated goldens for `Atlas Lab`, `Edge Sandbox`, fixture endpoints, credentials and screenshot-derived user data

## 4. Dark-only Surf Terminal theme

- [x] 4.1 Remove app light/system theme paths and force `ThemeMode.dark`, then verify widget tests cannot select or render a light app theme
- [x] 4.2 Remove `autoTheme` from terminal preferences, repository/state/settings controls and tests, then verify domain/business APIs contain no orphaned app-theme state
- [x] 4.3 Refine dark Surf color, surface, typography, navigation, input and feedback tokens while retaining original identity, then verify contrast-critical pairs meet at least 4.5:1
- [x] 4.4 Verify compact/expanded, keyboard, orientation and increased-text-scale surfaces have no overflow and all primary actions remain accessible

## 5. Native splash and branding

- [x] 5.1 Create original transparent `assets/branding/splash-mark.png` and `assets/branding/splash-branding.png` with dark Surf Terminal wave/prompt identity, then visually verify safe margins and no third-party assets
- [x] 5.2 Add assets and `flutter_native_splash` dark fullscreen configuration including Android 12 values to `pubspec.yaml`, then verify YAML and asset paths resolve
- [x] 5.3 Run `dart run flutter_native_splash:create`, record exact generated Android/iOS targets and verify launch resources use the configured dark background and assets
- [x] 5.4 Build Android debug and iOS simulator targets and verify generated splash resources link without manual edits or signing requirements

## 6. App icon generation

- [x] 6.1 Create original `assets/branding/app-icon.png` and adaptive `app-icon-foreground.png` using the Surf wave/prompt identity, then visually verify small-size readability, safe margins and absence of third-party assets
- [x] 6.2 Add `flutter_launcher_icons` configuration for iOS, Android and adaptive icon background/foreground, then verify YAML and asset paths resolve
- [x] 6.3 Run `dart run flutter_launcher_icons`, record exact generated Android/iOS targets and verify all required icon sizes are produced without manual platform edits
- [x] 6.4 Inspect representative Android circle/squircle masks and iOS icons, then verify foreground clipping is absent and iOS output has no alpha channel

## 7. Settings, navigation and presentation consistency

- [x] 7.1 Remove SFTP and app auto-theme references from settings/help/about copy and verify unsupported actions do not imply available functionality
- [x] 7.2 Verify snippets, editors and terminal workspace remain reachable from the three-destination shell and preserve feature-specific state isolation; the later approved `implement-real-ssh-terminal-transport` change supersedes Cubits with Freezed BLoCs
- [x] 7.3 Audit route pages and feature modules after removals; verify route pages stay within 150 lines and all handwritten Dart files within 200 unless explicitly justified
- [x] 7.4 Create ADR-0011 for dark SSH-first branding, native splash and app icon, mark ADR-0009 superseded without rewriting its history, and update the ADR index

## 8. Regression and acceptance verification

- [x] 8.1 Update widget tests for three-destination navigation, empty-first SSH, user-created populated state and forced dark mode; verify all branch tests pass
- [x] 8.2 Regenerate only affected dark goldens after visual review and verify no demo host, real data, third-party screenshot or SFTP surface appears
- [x] 8.3 Run architecture/import/SFTP-absence and fixture-secret scans, then verify the accepted layout graph and composition-root rules remain intact
- [x] 8.4 Run dependency resolution, formatting, `git diff --check`, ASCII-path `flutter analyze` workaround and full tests; verify every command exits successfully
- [x] 8.5 Run Android and iOS simulator builds, inspect generated splash/icon artifacts, and verify no stale SFTP or light-theme platform/resource reference remains
- [x] 8.6 Compare implementation against the five revised capability specs and confirm actual SSH transport/persistence are owned by the separately approved `implement-real-ssh-terminal-transport` change rather than this UI baseline
