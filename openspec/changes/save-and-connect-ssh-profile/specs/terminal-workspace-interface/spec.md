# Spec Delta

## ADDED Requirements

### Requirement: Terminal workspace prioritizes one full-screen active session
Terminal workspace SHALL display exactly one active real SSH session without a server tab strip or persistent session status row. Starting another connection MUST close and release the previous runtime before presenting the replacement. A connected session SHALL expand its terminal viewport to all body space not required by navigation/safe areas and the mobile special-key toolbar. The terminal surface SHALL use a standard flat black/dark-charcoal presentation with monospace xterm content and MUST NOT include surfer management decoration such as waves, gradients, cards, preview badges or promotional copy.

#### Scenario: Открывается profile
- **WHEN** пользователь выбирает сохранённый profile либо отправляет новый profile через `Connect`
- **THEN** открывается full-screen terminal workspace, связанная только с новой real SSH session

#### Scenario: Запускается другая session
- **WHEN** пользователь начинает подключение к другому SSH profile при существующей active session
- **THEN** прежний runtime, transport, focus resources и transient credential освобождаются до открытия единственной replacement session

#### Scenario: Session подключена
- **WHEN** host-key verification, authentication и PTY/shell creation завершены
- **THEN** server tabs и persistent status row отсутствуют, а стандартный undecorated dark terminal viewport занимает всю оставшуюся доступную высоту над mobile toolbar

#### Scenario: Session устанавливает соединение
- **WHEN** session находится в connecting, verifying-host-key, authenticating или reconnecting state
- **THEN** в центре доступной terminal body отображаются `CircularProgressIndicator` и фактический lifecycle label

#### Scenario: Session завершается ошибкой
- **WHEN** connection lifecycle переходит в failed state
- **THEN** вместо постоянной status row отображается центрированное actionable error state с retry и возвратом к profiles

#### Scenario: Terminal presentation проверяется
- **WHEN** terminal route отображает setup, connected или failure state
- **THEN** его background остаётся flat dark, terminal text остаётся monospace, а surfer waves, gradients, cards, preview badges и management marketing copy отсутствуют

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
