# Spec Delta

## ADDED Requirements

### Requirement: Terminal workspace prioritizes one full-screen active session
Terminal workspace SHALL display exactly one active real SSH session without a server tab strip, ordinary AppBar, persistent session status row or opaque toolbar band. Starting another connection MUST close and release the previous runtime before presenting the replacement. The terminal canvas SHALL fill the display edge-to-edge behind system insets and SHALL remain visually and behaviorally close to standard macOS Terminal: flat opaque black/dark-charcoal, familiar monospace metrics and restrained ANSI-compatible colors. Terminal content and interactive controls MUST respect safe areas and software-keyboard insets. Setup/failure/dialog presentation SHALL be Cupertino-first. Compact navigation, copy and mobile special-key controls SHALL float above the canvas as clipped Liquid Glass overlays with built-in frosted and solid accessibility fallbacks. Glass MUST NOT blur or refract the full terminal glyph grid and the route MUST NOT include infrastructure motifs, waves, gradients, cards, preview badges or promotional copy.

#### Scenario: Открывается profile
- **WHEN** пользователь выбирает сохранённый profile либо отправляет новый profile через `Connect`
- **THEN** открывается full-screen terminal workspace, связанная только с новой real SSH session

#### Scenario: Запускается другая session
- **WHEN** пользователь начинает подключение к другому SSH profile при существующей active session
- **THEN** прежний runtime, transport, focus resources и transient credential освобождаются до открытия единственной replacement session

#### Scenario: Session подключена
- **WHEN** host-key verification, authentication и PTY/shell creation завершены
- **THEN** AppBar, server tabs, persistent status row и opaque toolbar band отсутствуют, а opaque dark terminal canvas заполняет экран edge-to-edge под плавающими controls

#### Scenario: Controls учитывают safe area
- **WHEN** terminal отображается на устройстве с вырезом, home indicator либо открытой software keyboard
- **THEN** canvas остаётся edge-to-edge, terminal glyphs/input cursor не перекрываются системными областями, а floating controls перемещаются внутри доступной safe/IME области без резервирования постоянной полосы

#### Scenario: Terminal controls используют Liquid Glass
- **WHEN** отображаются back/session, copy или special-key actions
- **THEN** они представлены компактными floating glass pills, blur/refraction clipped их bounds, а остальной terminal glyph grid остаётся opaque и не фильтруется

#### Scenario: Glass effect недоступен или отключён
- **WHEN** включён reduced transparency/high contrast, glass shader недоступен либо выбран performance fallback
- **THEN** controls сохраняют layout, semantics и touch targets с built-in clipped frosted либо solid high-contrast surface без full-screen blur

#### Scenario: Session устанавливает соединение
- **WHEN** session находится в connecting, verifying-host-key, authenticating или reconnecting state
- **THEN** в центре доступной terminal body отображаются `CupertinoActivityIndicator` и фактический lifecycle label

#### Scenario: Session завершается ошибкой
- **WHEN** connection lifecycle переходит в failed state
- **THEN** вместо постоянной status row отображается центрированное actionable error state с retry и возвратом к profiles

#### Scenario: Terminal presentation проверяется
- **WHEN** terminal route отображает setup, connected или failure state
- **THEN** canvas остаётся flat opaque dark и edge-to-edge, terminal text остаётся familiar monospace, а glass ограничен floating controls; server motifs, waves, gradients, cards, preview badges и management marketing copy отсутствуют

#### Scenario: Remote command пишет ошибку
- **WHEN** открытый PTY/shell получает remote stdout и stderr, включая error text и ANSI/control sequences
- **THEN** payload отображается в xterm дословно и в transport delivery order без локализации, application cards, изменения wording либо переноса в lifecycle surface

#### Scenario: Локальный SSH lifecycle завершается ошибкой
- **WHEN** DNS, transport, host-key, authentication либо PTY/shell setup завершается ошибкой до или вне remote command output
- **THEN** terminal route отображает безопасное нормализованное сообщение в terminal-style failure surface с retry/return controls и не записывает эту ошибку в xterm buffer

#### Scenario: Чувствительная authentication data не становится output
- **WHEN** authentication обрабатывает password prompt, password response, raw banner либо одноразовый external-auth URL
- **THEN** эти данные отсутствуют и в remote xterm buffer, и в отображаемом lifecycle error detail

### Requirement: Terminal output supports local mobile selection and copy
Connected terminal output SHALL support long-press selection with draggable handles, platform context-menu `Copy`, and a `Copy selection` action in the floating special-key controls. Copying SHALL operate only on the current non-empty selection, MUST NOT send terminal input to the remote session, and MUST NOT persist a transcript.

#### Scenario: Пользователь копирует выделение
- **WHEN** пользователь long-press/drag выделяет terminal output и выбирает system `Copy` либо `Copy selection` в toolbar
- **THEN** selected plain text помещается в system clipboard, никакие bytes не отправляются в SSH session и selection остаётся локальной UI state

#### Scenario: Выделение отсутствует
- **WHEN** terminal selection пустая
- **THEN** `Copy selection` disabled либо безопасно ничего не делает и clipboard не перезаписывается

## MODIFIED Requirements

### Requirement: Terminal preferences affect preview
Выбранная terminal theme, font size, cursor style и cursor blink state SHALL отражаться в full-screen terminal viewport единственной активной реальной сессии в пределах текущего запуска приложения.

#### Scenario: Изменён размер шрифта
- **WHEN** пользователь меняет terminal font size в Settings и возвращается в workspace
- **THEN** full-screen terminal viewport активной сессии использует выбранный размер

## REMOVED Requirements

### Requirement: Terminal workspace displays session tabs
**Reason**: Постоянный server tab strip расходует ограниченную высоту мобильного terminal и противоречит выбранной модели одной active session.

**Migration**: Использовать `Terminal workspace prioritizes one full-screen active session`; запуск нового подключения сериализованно закрывает предыдущий runtime вместо добавления вкладки.

### Requirement: Terminal content is clearly non-networked in this change
**Reason**: Offline synthetic terminal content был временным prototype-контрактом и противоречит реализованным real SSH lifecycle и interactive PTY terminal.

**Migration**: Использовать `ssh-session-runtime` для connection lifecycle, `interactive-ssh-terminal` для remote PTY behavior и `Terminal workspace prioritizes one full-screen active session` для presentation contract. Tests MAY применять injected fakes, но production workspace MUST NOT подменять real session synthetic output.
