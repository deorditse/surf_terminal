# Proposal

## Why

Текущий новый SSH flow сохраняет profile до запуска transport, а transient password dialog может упасть во время закрытия из-за преждевременного dispose controller. Terminal workspace также расходует мобильную высоту на постоянные server tabs и status row вместо того, чтобы сразу показать реальный connection progress и отдать максимум пространства интерактивному terminal.

## What Changes

- **BREAKING** Изменить primary action нового host editor на connect-first: после локальной validation приложение сразу создаёт единственную активную SSH session и открывает terminal route; structured profile persistence не блокирует запуск transport.
- После запуска connection attempt сохранить новый profile и выбранную credential policy независимо от успешности SSH. DNS, transport, host-key, authentication или PTY failure MUST NOT отменять либо откатывать сохранение profile.
- Ошибка profile/secure-storage persistence MUST быть показана безопасно, но MUST NOT останавливать уже запущенную SSH session и MUST NOT раскрывать credential material.
- Для первой попытки использовать только transient opaque credential reference; при включённом remember отдельно сохранить password через secure storage для последующих подключений, а при выключенном remember оставить persisted profile без credential reference.
- Исправить lifecycle transient password dialog, чтобы dismiss animation не могла перестроить `TextField` с уже disposed controller.
- **BREAKING** Заменить tabbed multi-session workspace на одну активную session: новое подключение закрывает и освобождает предыдущее; верхний server tab strip отсутствует.
- Удалить постоянную session status row. Во время `connecting`, host-key verification, authentication и reconnect показывать центрированный `CircularProgressIndicator` с коротким lifecycle label; после connection отдать доступную область terminal viewport и сохранить нижнюю mobile special-key toolbar.
- **BREAKING** Оставить на Connections ровно одно действие создания host — `Add host` в AppBar. Удалить connection FAB и кнопку из empty state, устранить default `FloatingActionButton` Hero-tag collision между сохранёнными shell branches.
- Переработать management screens в сдержанном dark surfer-style: ocean-black/navy surfaces, cyan/teal accents, тонкие контуры и мягкий wave/gradient motif без preview/offline labels и без декоративной перегрузки.
- Сохранить terminal screen стандартным и функциональным: однотонная тёмная поверхность, monospace xterm, минимальная chrome и никаких surfer cards, gradients, waves или badges внутри terminal viewport.
- Поддержать Tailscale SSH check mode: распознавать trusted web-auth challenge из SSH user-auth banner, безопасно открывать одноразовый `https://login.tailscale.com/a/<opaque-token>` в системном браузере и показывать центрированное состояние ожидания browser authentication.
- На happy path сохранять текущий SSH transport открытым и позволять той же authentication attempt продолжиться после Tailscale approval; если transport завершился во время browser handoff, выполнить не более одной автоматической fresh attempt после возврата приложения с повторной host-key verification.
- Не открывать произвольные server-provided URLs и не сохранять, логировать, сериализовать либо помещать одноразовый authentication URL в route или BLoC state.
- Показывать connection failure как центрированное actionable state с retry/return actions, а не как постоянно занимающую высоту terminal status bar.
- Сохранить отдельный `Edit host → Save` workflow: он обновляет тот же profile без запуска новой session и без раскрытия password.
- Завершить замену устаревших canonical prototype requirements про offline/mock terminal и current-run-only profiles, сохранив dark/current-run settings contract и актуальную mobile toolbar.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `ssh-host-interface`: New-profile `Connect` starts transport immediately, profile persistence follows independently, edit remains separate, transient password UI is lifecycle-safe, and Connections exposes exactly one AppBar create action in a dark surfer-style management surface.
- `ssh-profile-persistence`: New profiles persist after connection launch regardless of SSH outcome; persistence failure no longer cancels an already-started session, while secret isolation remains mandatory.
- `ssh-session-runtime`: A new unsaved profile enters the real SSH lifecycle immediately, only one active session is retained, connection progress is centered on the terminal route, and trusted Tailscale check-mode challenges hand off to the system browser without exposing their one-time URL.
- `terminal-workspace-interface`: The tabbed workspace and persistent status row are retired in favor of one standard undecorated dark full-screen terminal, centered loading/failure surfaces, and the existing mobile toolbar.
- `terminal-settings-interface`: Preview/mock wording remains replaced with current-run settings applied to the real full-screen terminal; durable settings persistence is not added.

## Impact

- UI: host editor submission, transient password dialog, one AppBar-only host-create action, dark surfer-style management surfaces, a standard undecorated dark terminal route, connection/browser-auth progress and failure surfaces, and removal of FAB duplication, preview copy, server tabs and status row.
- Runtime/composition: connect-first orchestration, single-active-session replacement, independent best-effort profile/credential persistence, an ephemeral external-auth challenge coordinator and app lifecycle resume handling using existing Pure DI boundaries.
- Security: passwords and one-time authentication URLs remain excluded from routes, BLoC states/events, SQLite, secure storage, logs, fixtures, screenshots and diagnostics; only opaque credential/challenge references cross serializable or observable boundaries.
- Tests: strict RED/GREEN coverage for dialog disposal, connect-before-persist ordering, save-after-connection-failure, persistence-error non-cancellation, single-session replacement, exactly one host-create action, unique/no conflicting FAB Hero tags, surfer management styling, standard dark terminal presentation, centered progress, Tailscale banner parsing/browser handoff/bounded continuation and edit behavior; Android lifecycle and AsyncSSH harness remain acceptance gates.
- Specs: five existing capabilities are revised; archived changes and accepted ADR history remain immutable.
- Dependencies/public APIs: add a narrowly injected system-URL-launcher implementation (expected Flutter package: `url_launcher`) behind a UI-owned contract; no embedded web view, custom OAuth callback, Tailscale SDK or SFTP scope.
