# Spec Delta

## MODIFIED Requirements

### Requirement: Clean Architecture dependency direction
Проект MUST физически разделять ответственность внутри единственного Flutter package на `lib/domain_layout`, `lib/data_layout`, `lib/business_layout` и `lib/ui_layout`. `domain_layout` MUST быть pure Dart и не зависеть от Flutter, UI, DI, storage, SSH implementations или platform packages. `business_layout` MUST зависеть только от `domain_layout` и разрешённых Dart business-logic libraries; `data_layout` MUST зависеть только от `domain_layout` и реализовывать его контракты. `ui_layout` MUST связывать реализации и абстракции в composition root. Зависимости `business_layout → data_layout`, `data_layout → business_layout`, прямые импорты `data_layout` из страниц и скрытое получение зависимостей через service locator MUST быть запрещены. Поскольку единый manifest не обеспечивает эти границы, проект MUST проверять направления импортов автоматическим architecture test.

#### Scenario: Presentation запускает SSH-соединение
- **WHEN** пользователь инициирует подключение
- **THEN** presentation вызывает domain-контракт, не создавая конкретный SSH-клиент или secure storage напрямую

#### Scenario: Data implementation заменяется fake-реализацией
- **WHEN** domain-контракт подменяется в тесте
- **THEN** BLoC и domain-логика тестируются без реального SSH-сервера и платформенного хранилища

#### Scenario: Проверяются физические package boundaries
- **WHEN** выполняется анализ импортов единственного Flutter package
- **THEN** dependency graph соответствует `business_layout → domain_layout`, `data_layout → domain_layout`, `ui_layout → domain_layout + data_layout + business_layout` и не содержит запрещённых обратных зависимостей

#### Scenario: Страница запрашивает concrete repository
- **WHEN** route page или page-specific widget получает зависимость
- **THEN** он использует domain/business API, а concrete data implementation создаётся только в `lib/ui_layout/app/di`

### Requirement: Presentation exposes explicit pages
Корневой Flutter presentation MUST быть организован через `lib/ui_layout/app`, `lib/ui_layout/pages` и `lib/ui_layout/shared`. Каждая маршрутизируемая пользовательская поверхность MUST иметь явную страницу в `lib/ui_layout/pages/<page>/`, а page-specific widgets MUST находиться рядом с этой страницей. Composition, routing, theme и lifecycle MUST находиться в `lib/ui_layout/app`, а действительно переиспользуемые UI-компоненты — в `lib/ui_layout/shared`.

#### Scenario: Добавляется маршрутизируемый экран
- **WHEN** создаётся новая пользовательская страница
- **THEN** её page widget и локальные компоненты размещаются в отдельном каталоге `lib/ui_layout/pages/<page>/`, а маршрут регистрируется через app routing

#### Scenario: UI-компонент используется несколькими страницами
- **WHEN** один компонент действительно переиспользуется разными страницами
- **THEN** он размещается в `lib/ui_layout/shared`, не перенося туда page-specific business behavior
