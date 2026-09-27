# Tasks

## 1. Prerequisites and dependency resolution

- [ ] 1.1 Complete and verify the approved `establish-project-architecture-guidelines` update before UI implementation, and confirm `AGENT.md`, ADR-0007 and explicit page/package boundaries match its validated artifacts
- [ ] 1.2 Capture the current Git status and preserve user-owned changes in `pubspec.yaml`, then verify the apply diff does not overwrite unrelated content
- [ ] 1.3 Resolve the latest stable mutually compatible versions of the approved routing, state-management, code-generation and golden-test packages against Flutter 3.47.5/Dart 3.13.4, merge them into `pubspec.yaml`, and verify `flutter pub get` succeeds without `any` or unexplained overrides

## 2. Application foundation

- [ ] 2.1 Create the `lib/ui/app`, `lib/ui/pages` and `lib/ui/shared` presentation structure and verify every route-level surface has an explicit page directory
- [ ] 2.2 Implement Surf Terminal color, spacing, radius, typography and motion tokens with dark and light app themes, and verify theme tests cover contrast-critical foreground/background pairs
- [ ] 2.3 Implement the router and stateful app shell with SSH, SFTP, Snippets and Settings destinations, and verify widget tests cover switching destinations and preserving branch state
- [ ] 2.4 Add adaptive bottom navigation/navigation rail, safe-area and keyboard-inset handling, and verify compact and expanded widget tests render without overflow
- [ ] 2.5 Add reusable section cards, rows, empty states, search controls and primary actions with semantics, and verify shared-widget tests cover selected, disabled and error states
- [ ] 2.6 Decompose every route surface into a composition-oriented `*_page.dart` plus feature-local `widgets`, `sections`, `dialogs`, `form` or `modules`, split shared model/widget aggregators by responsibility, and verify no handwritten Dart file exceeds 200 lines or contains three independent responsibilities without a documented exception
- [ ] 2.7 Replace the cross-feature presentation Cubit with separately injected profiles, terminal-sessions, SFTP, snippets and settings Cubit/state modules, and verify feature transitions remain isolated while cross-page settings propagation still works

## 3. SSH host interface

- [ ] 3.1 Implement safe in-memory SSH profile fixtures and state without real credentials, and verify a repository-wide fixture scan finds no values copied from the supplied screenshots
- [ ] 3.2 Implement the SSH hosts page with empty and populated states, search/sort affordances, profile actions and add action, and verify widget tests cover both states and navigation to the editor
- [ ] 3.3 Implement the scrollable host editor sections and secure password reveal behavior, and verify widget tests cover obscured-by-default input and all specified controls
- [ ] 3.4 Implement host, username and port validation plus create/update flows in current-run presentation state, and verify tests cover missing required values, ports outside 1–65535 and successful save
- [ ] 3.5 Implement explicit delete confirmation and profile removal, and verify deleting the final profile returns the SSH page to its empty state

## 4. Terminal workspace

- [ ] 4.1 Implement the terminal workspace route with an explicit offline/preview indicator and synthetic terminal fixture, and verify no UI copy claims a live connection
- [ ] 4.2 Implement add, select and close behavior for mock session tabs, and verify widget tests cover active-tab transitions and the zero-session state
- [ ] 4.3 Implement the horizontally scrollable special-key toolbar with Escape, Control, Alt, Tab, arrows, paste and keyboard dismissal, and verify semantics and modifier selected states
- [ ] 4.4 Connect terminal theme, font size, cursor style and blink presentation settings to the preview, and verify settings changes are observable after returning to the workspace
- [ ] 4.5 Verify terminal workspace handles the software keyboard, compact landscape and increased text scale without clipped viewport-critical controls

## 5. SFTP interface

- [ ] 5.1 Implement SFTP empty, loading, data and error fixtures with an explicit non-networked state, and verify widget tests render every state
- [ ] 5.2 Implement fixture path navigation, parent navigation and file/folder rows, and verify opening a fixture directory updates the breadcrumb and listing locally
- [ ] 5.3 Implement disabled or preview-only file context actions, and verify no filesystem, network, upload, download or delete side effect is reachable

## 6. Snippets interface

- [ ] 6.1 Implement snippets empty/list/search states with add, edit, copy and delete actions, and verify search filters title, command and labels
- [ ] 6.2 Implement the snippet editor with required title/command validation and optional description/labels, and verify create and update widget tests pass
- [ ] 6.3 Implement copy feedback and delete confirmation, and verify clipboard interaction is mocked in tests and deleting the final item restores the empty state

## 7. Settings interface

- [ ] 7.1 Implement grouped Help, Terminal, Connection and About sections in a scrollable settings page, and verify every implemented control remains reachable above the persistent app navigation
- [ ] 7.2 Implement auto theme, terminal palette, font size, cursor style and cursor blink controls with visible selected states, and verify state and terminal preview tests pass
- [ ] 7.3 Implement emulation type, keepalive interval/count and keep-awake presentation controls with explanations and bounded values, and verify invalid values cannot be selected
- [ ] 7.4 Omit or explicitly disable unsupported cloud, subscription, batch-execute and network-scan actions, and verify no unsupported action presents a false success result

## 8. Entry point, ADR and quality verification

- [ ] 8.1 Replace the Flutter counter entry point with the composed Surf Terminal app only after shell tests pass, and verify a smoke test renders the SSH destination first
- [ ] 8.2 Create `docs/adr/ADR-0009-surf-terminal-presentation-system.md` and update the ADR index, then verify the ADR describes Surf Terminal design tokens, explicit pages, adaptive shell and fixture-only boundary rather than documenting a reference application
- [ ] 8.3 Add representative compact iOS-like and Android-like golden tests for shell, host editor, terminal, snippets and settings, and verify approved goldens contain no third-party screenshots or user data
- [ ] 8.4 Run the structural file-size/responsibility audit, `dart format --set-exit-if-changed .`, code generation where required, `flutter analyze` and `flutter test`, and verify all commands exit successfully
- [ ] 8.5 Run the app on at least one available iOS simulator and one available Android emulator/device when both platforms are available, capture actual screenshots for review, and report any unavailable platform honestly
- [ ] 8.6 Compare the final implementation against all six capability specs and the original-identity requirement, and verify no real SSH/SFTP transport, persistence, credential, copyrighted asset or unrelated file change entered the scope
