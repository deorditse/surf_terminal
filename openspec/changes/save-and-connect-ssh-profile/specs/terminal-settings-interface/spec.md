# Spec Delta

## MODIFIED Requirements

### Requirement: Terminal appearance settings are dark and interactive
Settings SHALL использовать `CupertinoPageScaffold`, `CupertinoNavigationBar` и Cupertino-first selection/toggle controls и SHALL позволять выбирать только тёмные terminal color palettes, font size, cursor style и cursor blink. Активные значения MUST быть визуально различимы и применяться к full-screen terminal viewport реальной active session в пределах текущего запуска приложения. App-level light, auto или system theme control MUST NOT предлагаться.

#### Scenario: Выбирается terminal palette
- **WHEN** пользователь выбирает доступную dark palette tile
- **THEN** tile получает selected state и full-screen terminal viewport использует соответствующую тёмную palette

#### Scenario: Выбирается cursor style
- **WHEN** пользователь выбирает block, underline или bar
- **THEN** выбранный style отмечается и используется terminal viewport реальной active session

#### Scenario: Проверяется app theme control
- **WHEN** пользователь открывает Terminal settings
- **THEN** отсутствует control, способный переключить приложение в light или system theme

#### Scenario: Проверяется presentation settings
- **WHEN** пользователь открывает Settings и изменяет selection либо toggle
- **THEN** page/navigation/action/toggle presentation является Cupertino-first, включая `CupertinoSwitch`, без Material scaffold, app bar, dialog, progress или snackbar surface кроме документированного fallback

### Requirement: Connection behavior settings expose valid choices
Settings SHALL предоставлять Cupertino-first controls для emulation type, keepalive interval, keepalive count и keep-awake. Числовые значения MUST ограничиваться безопасными отображаемыми диапазонами и иметь пояснения. Выбранные значения SHALL применяться к поддерживаемому behavior SSH-сессий в пределах текущего запуска; capability MUST NOT заявлять persistence между запусками без отдельного durable settings contract.

#### Scenario: Меняется keepalive interval
- **WHEN** пользователь выбирает interval из допустимого списка
- **THEN** выбранное значение отображается в settings summary и применяется к последующим поддерживаемым SSH-сессиям текущего запуска

#### Scenario: Keep awake переключается
- **WHEN** пользователь изменяет keep-awake switch
- **THEN** switch обновляет presentation state и поддерживаемую runtime policy без заявления о persistence между запусками
