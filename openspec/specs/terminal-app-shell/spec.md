# terminal-app-shell Specification

## Purpose
Определяет корневую навигацию, адаптивность, dark-only визуальную идентичность и native launch experience мобильного Surf Terminal на iOS и Android.

## Requirements

### Requirement: Primary navigation exposes three product areas
Приложение SHALL предоставлять постоянную навигацию между SSH, Snippets и Settings и SHALL визуально обозначать активный раздел. SFTP MUST NOT присутствовать как destination, route или placeholder.

#### Scenario: Пользователь переключает основной раздел
- **WHEN** пользователь выбирает другую вкладку основной навигации
- **THEN** отображается соответствующая страница и активное состояние навигации обновляется

#### Scenario: Пользователь возвращается на вкладку
- **WHEN** пользователь покидает вкладку и затем возвращается к ней
- **THEN** её локальная позиция прокрутки и presentation-состояние сохраняются в пределах текущего запуска приложения

#### Scenario: Проверяется набор destinations
- **WHEN** shell отображается на compact или expanded ширине
- **THEN** доступны только SSH, Snippets и Settings без SFTP action

### Requirement: Layout adapts to supported mobile sizes
Интерфейс MUST корректно работать на поддерживаемых размерах экранов iOS и Android, учитывать safe areas, системную клавиатуру, text scaling и ориентацию без overflow или недоступных controls.

#### Scenario: Экран имеет компактную ширину
- **WHEN** приложение отображается на компактном мобильном экране
- **THEN** основные действия и навигация остаются полностью видимыми без горизонтального overflow

#### Scenario: Включён увеличенный системный шрифт
- **WHEN** пользователь увеличивает text scale средствами ОС
- **THEN** ключевые labels и actions остаются читаемыми и доступными без обрезания критического смысла

### Requirement: Surf Terminal has an original dark visual identity
Интерфейс MUST использовать только тёмную app theme и собственные design tokens, тексты, иконографику и component styling Surf Terminal. Он MUST NOT копировать название, логотип, proprietary assets, платные ограничения, App Store UI или точные визуальные параметры приложения-референса.

#### Scenario: UI сравнивается с референсом
- **WHEN** выполняется visual review
- **THEN** функциональная композиция может быть узнаваемой как SSH-клиент, но branding, assets, tokens и детали компонентов принадлежат Surf Terminal

#### Scenario: Система запрашивает светлую тему
- **WHEN** устройство использует light mode
- **THEN** Surf Terminal продолжает отображать утверждённую тёмную app theme без светлой поверхности

### Requirement: Native splash matches Surf Terminal branding
Android и iOS launch surfaces MUST использовать оригинальный dark Surf Terminal splash с согласованным background, centered mark и bottom branding. Splash assets MUST NOT содержать third-party branding или screenshots.

#### Scenario: Приложение запускается холодным стартом
- **WHEN** native launch screen отображается до первого Flutter frame
- **THEN** пользователь видит тёмный Surf Terminal splash без белой вспышки и чужих assets

#### Scenario: Splash проверяется на Android 12
- **WHEN** система применяет Android 12 splash masking
- **THEN** основной mark остаётся различимым внутри safe central area на утверждённом тёмном фоне

### Requirement: Application icon matches Surf Terminal branding
iOS и Android app icons MUST использовать оригинальный Surf Terminal mark, согласованный с dark splash и визуальной системой приложения. Android adaptive icon MUST сохранять знак в safe zone для системных masks, а iOS icon MUST содержать все требуемые размеры без alpha channel.

#### Scenario: Android применяет adaptive mask
- **WHEN** launcher отображает icon с circle, squircle или другой поддерживаемой mask
- **THEN** wave/prompt mark остаётся читаемым и не обрезается по смысловым границам

#### Scenario: iOS проверяет AppIcon catalog
- **WHEN** iOS build валидирует generated AppIcon assets
- **THEN** все требуемые размеры присутствуют, используют собственный Surf mark и не содержат прозрачности

### Requirement: Interactive elements are accessible
Все основные actions MUST иметь semantic labels, достаточные touch targets и различимые selected, focused, disabled и error states.

#### Scenario: Интерфейс используется screen reader
- **WHEN** пользователь перемещается по основным controls через accessibility service
- **THEN** назначение, состояние и действие каждого control объявляются понятным текстом

### Requirement: Presentation modules are decomposed by responsibility
Каждая route-level поверхность MUST иметь короткий composition-oriented `*_page.dart`, а самостоятельные sections, widgets, dialogs, forms и state modules MUST находиться в feature-local каталогах. Несвязанные workflows MUST NOT управляться единым cross-feature Cubit или храниться в одном implementation-файле.

#### Scenario: Route-level page проходит structural review
- **WHEN** проверяется реализация страницы
- **THEN** page-файл только собирает route-level layout и делегирует самостоятельные визуальные блоки feature-local components

#### Scenario: Handwritten Dart-файл становится крупным
- **WHEN** handwritten файл превышает 200 строк либо объединяет три и более самостоятельных components или responsibilities
- **THEN** он разделяется по ответственности или получает явное обоснование исключения в design/review до завершения change

#### Scenario: Presentation state пересекает features
- **WHEN** profiles, terminal sessions, snippets и settings требуют независимых transitions
- **THEN** каждый workflow принадлежит отдельному injected Cubit/state module, а composition root связывает их без service-locator access из widgets
