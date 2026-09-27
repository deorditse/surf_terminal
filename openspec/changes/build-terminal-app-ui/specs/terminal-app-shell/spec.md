# Spec Delta

## Purpose

Определяет корневую навигацию, адаптивность и визуальную идентичность мобильного интерфейса Surf Terminal на iOS и Android.

## ADDED Requirements

### Requirement: Primary navigation exposes four product areas
Приложение SHALL предоставлять постоянную навигацию между SSH, SFTP, Snippets и Settings и SHALL визуально обозначать активный раздел.

#### Scenario: Пользователь переключает основной раздел
- **WHEN** пользователь выбирает другую вкладку основной навигации
- **THEN** отображается соответствующая страница и активное состояние навигации обновляется

#### Scenario: Пользователь возвращается на вкладку
- **WHEN** пользователь покидает вкладку и затем возвращается к ней
- **THEN** её локальная позиция прокрутки и presentation-состояние сохраняются в пределах текущего запуска приложения

### Requirement: Layout adapts to supported mobile sizes
Интерфейс MUST корректно работать на поддерживаемых размерах экранов iOS и Android, учитывать safe areas, системную клавиатуру, text scaling и ориентацию без overflow или недоступных controls.

#### Scenario: Экран имеет компактную ширину
- **WHEN** приложение отображается на компактном мобильном экране
- **THEN** основные действия и навигация остаются полностью видимыми без горизонтального overflow

#### Scenario: Включён увеличенный системный шрифт
- **WHEN** пользователь увеличивает text scale средствами ОС
- **THEN** ключевые labels и actions остаются читаемыми и доступными без обрезания критического смысла

### Requirement: Surf Terminal has an original visual identity
Интерфейс MUST использовать собственные design tokens, тексты, иконографику и component styling Surf Terminal. Он MUST NOT копировать название, логотип, proprietary assets, платные ограничения, App Store UI или точные визуальные параметры приложения-референса.

#### Scenario: UI сравнивается с референсом
- **WHEN** выполняется visual review
- **THEN** функциональная композиция может быть узнаваемой как SSH-клиент, но branding, assets, tokens и детали компонентов принадлежат Surf Terminal

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
- **WHEN** profiles, terminal sessions, SFTP, snippets и settings требуют независимых transitions
- **THEN** каждый workflow принадлежит отдельному injected Cubit/state module, а composition root связывает их без service-locator access из widgets
