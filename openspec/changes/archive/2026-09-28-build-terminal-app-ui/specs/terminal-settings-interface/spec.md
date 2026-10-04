# Spec Delta

## Purpose

Определяет интерактивные настройки тёмного terminal preview и connection behavior в Surf Terminal без light app theme, постоянного хранения и системных side effects.

## ADDED Requirements

### Requirement: Terminal appearance settings are dark and interactive
Settings SHALL позволять выбирать только тёмные terminal color palettes, font size, cursor style и cursor blink. Активные значения MUST быть визуально различимы и применяться к terminal preview текущего запуска. App-level light, auto или system theme control MUST NOT предлагаться.

#### Scenario: Выбирается terminal palette
- **WHEN** пользователь выбирает доступную dark palette tile
- **THEN** tile получает selected state и terminal preview использует соответствующую тёмную palette

#### Scenario: Выбирается cursor style
- **WHEN** пользователь выбирает block, underline или bar
- **THEN** выбранный style отмечается и используется в terminal preview

#### Scenario: Проверяется app theme control
- **WHEN** пользователь открывает Terminal settings
- **THEN** отсутствует control, способный переключить приложение в light или system theme

### Requirement: Connection behavior settings expose valid choices
Settings SHALL предоставлять controls для emulation type, keepalive interval, keepalive count и keep-awake. Числовые значения MUST ограничиваться безопасными отображаемыми диапазонами и иметь пояснения.

#### Scenario: Меняется keepalive interval
- **WHEN** пользователь выбирает interval из допустимого списка
- **THEN** выбранное значение отображается в settings summary текущего запуска

#### Scenario: Keep awake переключается
- **WHEN** пользователь изменяет keep-awake switch
- **THEN** switch обновляет presentation state без изменения системной политики устройства в рамках этого UI change

### Requirement: Settings are grouped and scrollable
Настройки SHALL быть сгруппированы как Help, Terminal, Connection и About, а длинный контент MUST прокручиваться независимо от доступной основной навигации. SFTP MUST NOT упоминаться как доступный section или feature.

#### Scenario: Экран недостаточно высокий
- **WHEN** все settings sections не помещаются по вертикали
- **THEN** пользователь может прокрутить до каждого control, а основная навигация остаётся доступной

### Requirement: Unsupported future tools are honest
Tools, backup, account, subscription, network-scan или transport actions, не реализуемые данным change, MUST NOT выглядеть как работающие функции.

#### Scenario: Future action показано в интерфейсе
- **WHEN** дизайн включает действие вне текущего scope
- **THEN** оно скрыто либо явно disabled/labeled as coming later без ложного результата
