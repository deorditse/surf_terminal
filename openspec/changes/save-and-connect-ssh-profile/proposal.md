# Proposal

## Why

Текущий новый SSH flow сохраняет profile до запуска transport, а transient password dialog может упасть во время закрытия из-за преждевременного dispose controller. Terminal workspace также расходует мобильную высоту на постоянные server tabs и status row вместо того, чтобы сразу показать реальный connection progress и отдать максимум пространства интерактивному terminal.

## What Changes

- **BREAKING** Изменить primary action нового host editor на connect-first: после локальной validation приложение сразу создаёт единственную активную SSH session и открывает terminal route; structured profile persistence не блокирует запуск transport.
- После запуска connection attempt сохранить новый profile и выбранную credential policy независимо от успешности SSH. DNS, transport, host-key, authentication или PTY failure MUST NOT отменять либо откатывать сохранение profile.
- Ошибка profile/secure-storage persistence MUST быть показана безопасно, но MUST NOT останавливать уже запущенную SSH session и MUST NOT раскрывать credential material.
- Для первой попытки использовать только transient opaque credential reference; при включённом remember отдельно сохранить password через secure storage для последующих подключений, а при выключенном remember оставить persisted profile без credential reference.
- Secure retention SHALL быть включён по умолчанию во всех password prompts и new-host editor; пользователь может явно отключить его до подключения.
- При явном повторном password challenge или отказе password authentication показывать отдельный lifecycle-safe secure dialog поверх terminal route. Password MUST NOT отображаться, эхоироваться или записываться в terminal buffer; повторная отправка разрешена только в SSH authentication layer.
- Исправить lifecycle transient password dialog, чтобы dismiss animation не могла перестроить `TextField` с уже disposed controller.
- **BREAKING** Заменить tabbed multi-session workspace на одну активную session: новое подключение закрывает и освобождает предыдущее; верхний server tab strip отсутствует.
- Удалить обычные terminal AppBar, постоянную session status row и непрозрачную нижнюю toolbar-панель. Terminal canvas SHALL рисоваться edge-to-edge на весь экран; системные safe areas и IME ограничивают размещение текста и controls, но не фон terminal. Во время `connecting`, host-key verification, authentication и reconnect показывать центрированный `CupertinoActivityIndicator` с коротким lifecycle label.
- **BREAKING** Оставить на Connections ровно одно действие создания host — `Add host` в `CupertinoNavigationBar`. Удалить connection FAB и кнопку из empty state, устранить default `FloatingActionButton` Hero-tag collision между сохранёнными shell branches.
- **BREAKING** Перевести app chrome и management UI на Cupertino-first composition: корень использует `CupertinoApp.router`; routes — `CupertinoPageScaffold`/`CupertinoNavigationBar`; primary actions, dialogs, toggles и lifecycle progress используют `CupertinoButton`, `CupertinoAlertDialog`, `CupertinoSwitch` и `CupertinoActivityIndicator`. Material widgets допустимы только как документированный interoperability fallback либо когда Flutter не предоставляет подходящего Cupertino-аналога; terminal остаётся xterm, а floating glass controls — `liquid_glass_widgets` с approved fallback chain.
- Переработать management screens в restrained dark glass/server-infrastructure style: translucent layered surfaces, restrained blur/highlight, rack/network topology motifs и cyan status accents без preview/offline labels и без декоративной перегрузки.
- Сохранить terminal canvas функционально и визуально близким к стандартному macOS Terminal: flat opaque dark background, системно-знакомая monospace typography и никаких gradients, waves, cards или badges. Navigation, copy и special-key controls SHALL быть компактными плавающими Liquid Glass overlays поверх canvas, а не отдельными bars; glass blur/refraction MUST быть clipped формой controls и MUST NOT применяться ко всему terminal glyph grid.
- Добавить mobile-friendly terminal selection: long-press начинает выделение, drag handles расширяют selection, системное context menu предоставляет `Copy`, а special-key toolbar содержит `Copy selection`; копирование не отправляет input на сервер и не сохраняет transcript.
- Сохранять remote shell `stdout` и `stderr` как terminal-owned output: передавать их в xterm дословно, в порядке получения transport, включая ANSI/control sequences, без локализации, карточек или подмены текста. Ошибки DNS/transport/host-key/authentication/PTY SHALL оставаться безопасными terminal-style lifecycle states и MUST NOT записываться в remote terminal buffer.
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

- `ssh-host-interface`: New-profile `Connect` starts transport immediately, profile persistence follows independently, secure password retention defaults on, edit remains separate, password UI is lifecycle-safe, and Connections exposes exactly one `CupertinoNavigationBar` create action in a dark glass/server management surface.
- `ssh-profile-persistence`: New profiles persist after connection launch regardless of SSH outcome; persistence failure no longer cancels an already-started session, while secret isolation remains mandatory.
- `ssh-session-runtime`: A new unsaved profile enters the real SSH lifecycle immediately, only one active session is retained, connection progress is centered on the terminal route, explicit password challenges use a secure dialog over that route, trusted Tailscale check-mode challenges hand off to the system browser without exposing their one-time URL, and local lifecycle failures remain separate from the remote output stream.
- `terminal-workspace-interface`: The tabbed workspace, ordinary AppBar, persistent status row and opaque toolbar band are retired in favor of one edge-to-edge macOS-Terminal-like opaque canvas, centered Cupertino lifecycle surfaces, verbatim remote stdout/stderr, selectable/copyable output, and floating Liquid Glass controls respecting safe areas and IME.
- `terminal-settings-interface`: Preview/mock wording remains replaced with current-run settings applied to the real full-screen terminal; settings controls use Cupertino-first presentation and durable settings persistence is not added.

## Impact

- UI: `CupertinoApp.router` root, Cupertino-first page/navigation/action/dialog/toggle/progress chrome, host editor submission, secure password challenge dialogs, one `CupertinoNavigationBar`-only host-create action, dark glass/server management surfaces, an edge-to-edge macOS-Terminal-like opaque terminal canvas with floating glass controls, output selection/copy, connection/browser-auth progress and failure surfaces, and removal of FAB duplication, preview copy, ordinary terminal AppBar, server tabs, opaque toolbar band and status row.
- Runtime/composition: connect-first orchestration, single-active-session replacement, independent best-effort profile/credential persistence, an ephemeral external-auth challenge coordinator and app lifecycle resume handling using existing Pure DI boundaries.
- Security: passwords remain confined to transient memory boundaries and Keychain/Keystore-backed secure storage; passwords and one-time authentication URLs remain excluded from routes, BLoC states/events, SQLite, logs, fixtures, screenshots and diagnostics; only opaque credential/challenge references cross serializable or observable boundaries.
- Tests: strict RED/GREEN coverage for Cupertino-first root/routes/navigation/actions/dialogs/toggles/progress, absence of unjustified Material presentation widgets, dialog disposal, default secure retention, repeated password challenge, connect-before-persist ordering, save-after-connection-failure, persistence-error non-cancellation, single-session replacement, exactly one host-create action, unique/no conflicting FAB Hero tags, glass/server management styling, edge-to-edge macOS-Terminal-like presentation, clipped floating Liquid Glass controls, safe-area/IME behavior, verbatim ordered stdout/stderr, lifecycle-error isolation, selection/copy, centered progress, accessibility fallback, Tailscale banner parsing/browser handoff/bounded continuation and edit behavior; Android lifecycle and AsyncSSH harness remain acceptance gates.
- Specs: five existing capabilities are revised; archived changes and accepted ADR history remain immutable.
- Dependencies/public APIs: add a narrowly injected system-URL-launcher implementation (expected Flutter package: `url_launcher`) behind a UI-owned contract and pin compatible `liquid_glass_widgets` `1.8.1` for the presentation-only floating control layer. Glass keeps a built-in bounded `BackdropFilter` frosted fallback and a solid high-contrast fallback; no embedded web view, custom OAuth callback, Tailscale SDK or SFTP scope.
