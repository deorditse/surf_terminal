# terminal-workspace-interface Specification

## Purpose
Определяет интерактивную terminal workspace Surf Terminal с несколькими presentation-сессиями и мобильной панелью специальных клавиш.

## Requirements

### Requirement: Terminal workspace displays session tabs
Terminal workspace SHALL отображать одну или несколько вкладок сессий, активную вкладку, действия добавления и закрытия и отдельную terminal viewport для активной вкладки.

#### Scenario: Открывается profile
- **WHEN** пользователь выбирает SSH profile в UI change
- **THEN** открывается terminal workspace с mock session, связанной с display name profile, без сетевого подключения

#### Scenario: Добавляется сессия
- **WHEN** пользователь нажимает действие новой сессии
- **THEN** появляется новая вкладка и становится активной

#### Scenario: Закрывается активная сессия
- **WHEN** пользователь закрывает активную вкладку
- **THEN** активируется соседняя вкладка либо показывается пустое состояние workspace, если вкладок не осталось

### Requirement: Terminal content is clearly non-networked in this change
Terminal viewport SHALL использовать безопасный synthetic fixture и MUST NOT заявлять об успешном SSH connection, исполнять команды или отображать credentials из screenshots.

#### Scenario: Mock terminal отображается
- **WHEN** workspace открыта в рамках данного change
- **THEN** пользователь видит terminal-like content и явное состояние preview/offline без утверждения, что соединение установлено

### Requirement: Mobile terminal toolbar exposes common keys
Над системной клавиатурой SHALL быть доступна горизонтально прокручиваемая панель специальных действий, включающая как минимум Escape, Control, Alt, Tab, стрелки, paste и keyboard dismissal.

#### Scenario: Пользователь выбирает modifier
- **WHEN** пользователь активирует Control или Alt
- **THEN** control отображает выбранное состояние до следующего совместимого input либо явной отмены

#### Scenario: Недостаточно ширины
- **WHEN** все terminal keys не помещаются по ширине
- **THEN** toolbar прокручивается горизонтально, не уменьшая touch targets ниже доступного размера

### Requirement: Terminal preferences affect preview
Выбранная terminal theme, font size, cursor style и cursor blink state SHALL отражаться в mock terminal viewport текущего запуска.

#### Scenario: Изменён размер шрифта
- **WHEN** пользователь меняет terminal font size в Settings и возвращается в workspace
- **THEN** mock terminal viewport использует выбранный размер
