# Spec Delta

## Purpose

Устанавливает обязательный процесс планирования, архитектурные ограничения и проверяемые критерии качества для разработки мобильного Flutter SSH-клиента.

## ADDED Requirements

### Requirement: OpenSpec workflow is transparent and approval-gated
Все задачи, изменяющие исходный код, зависимости, конфигурацию, платформенные проекты или проектную документацию, MUST сначала оформляться как OpenSpec change с требуемыми артефактами. Перед выполнением OpenSpec-команды агент MUST показать команду, её цель и ожидаемый эффект. Read-only discovery MAY выполняться после такого объявления без отдельного approve. Создание или изменение planning artifacts, apply, archive и destructive operations MUST выполняться только после явного approve пользователя. Реализация MUST начинаться только после одобрения proposal и отдельного запроса на apply.

#### Scenario: Выполняется read-only discovery
- **WHEN** агенту нужно прочитать status, context, instructions или список specs/changes
- **THEN** агент заранее показывает команду и цель, после чего может выполнить её без отдельного approve

#### Scenario: Новая задача ещё не согласована
- **WHEN** пользователь описывает изменение, но ещё не одобрил OpenSpec proposal
- **THEN** агент показывает предлагаемый planning scope и не создаёт или не изменяет planning artifacts до явного approve

#### Scenario: Пользователь одобрил planning write
- **WHEN** пользователь явно одобряет создание или изменение перечисленных OpenSpec-артефактов
- **THEN** агент изменяет только одобренные planning artifacts и после этого показывает validation/status commands и их результаты

#### Scenario: Пользователь одобрил предложение
- **WHEN** пользователь явно одобряет подготовленные артефакты и отдельно просит применить изменение
- **THEN** агент объявляет apply command и выполняет реализацию в пределах согласованных requirements, design и tasks

#### Scenario: Во время реализации нужен выход за согласованный scope
- **WHEN** обнаруживается необходимость изменить внешнее поведение, архитектурное решение или acceptance criteria вне утверждённых артефактов
- **THEN** агент останавливает соответствующую часть реализации, показывает необходимое изменение OpenSpec и запрашивает повторный approve

#### Scenario: Требуется archive или destructive operation
- **WHEN** change готов к archive либо команда может удалить или необратимо изменить данные
- **THEN** агент показывает точную команду и ожидаемый эффект и ждёт отдельного approve

### Requirement: Architecture instructions are authoritative
Проект MUST содержать корневой `AGENT.md`, который определяет архитектурные границы, утверждённый стек, правила безопасности и quality gates. Все новые изменения MUST соответствовать этому документу либо явно предлагать его изменение через OpenSpec.

#### Scenario: Добавляется новая фича
- **WHEN** проектируется или реализуется новая функциональность
- **THEN** её структура и зависимости соответствуют правилам `AGENT.md`

#### Scenario: Требуется архитектурное исключение
- **WHEN** задача не может быть корректно реализована в установленных границах
- **THEN** исключение документируется и согласуется в OpenSpec до изменения реализации

### Requirement: Significant architecture decisions are recorded as ADRs
Проект MUST хранить обоснованные архитектурные решения в `docs/adr/`. Каждый ADR MUST иметь уникальный последовательный номер и kebab-case slug в имени `ADR-NNNN-<slug>.md`, а также разделы `Status`, `Date`, `Context`, `Decision`, `Alternatives` и `Consequences`. Значимое новое решение или изменение принятого решения MUST быть отражено новым ADR либо superseding ADR; существующая история MUST NOT переписываться задним числом.

#### Scenario: Принимается новое значимое решение
- **WHEN** OpenSpec change выбирает архитектурный паттерн, основную библиотеку, способ хранения, security policy или межслойный контракт
- **THEN** tasks включают создание ADR с контекстом, выбранным вариантом, рассмотренными альтернативами и последствиями

#### Scenario: Изменяется ранее принятое решение
- **WHEN** новое решение заменяет уже принятый ADR
- **THEN** создаётся новый ADR со ссылкой на заменяемый документ, а предыдущий ADR получает статус `Superseded` без удаления исторического содержания

#### Scenario: Решение является локальной деталью реализации
- **WHEN** выбор не влияет на архитектурные границы, публичные контракты, безопасность, данные или долгосрочную сопровождаемость
- **THEN** отдельный ADR не требуется

#### Scenario: Проверяется формат ADR
- **WHEN** ADR готов к review
- **THEN** его имя, номер и обязательные разделы соответствуют принятому шаблону

### Requirement: Clean Architecture dependency direction
Проект MUST физически разделять слои на `packages/domain`, `packages/data`, `packages/business_logic` и корневой Flutter presentation. `domain` MUST быть pure Dart и не зависеть от Flutter, UI, DI, storage, SSH implementations или platform packages. `business_logic` MUST зависеть только от `domain`; `data` MUST зависеть только от `domain` и реализовывать его контракты. Корневое приложение MUST связывать реализации и абстракции в composition root. Зависимости `business_logic → data`, `data → business_logic` и скрытое получение зависимостей через service locator MUST быть запрещены.

#### Scenario: Presentation запускает SSH-соединение
- **WHEN** пользователь инициирует подключение
- **THEN** presentation вызывает domain-контракт, не создавая конкретный SSH-клиент или secure storage напрямую

#### Scenario: Data implementation заменяется fake-реализацией
- **WHEN** domain-контракт подменяется в тесте
- **THEN** BLoC и domain-логика тестируются без реального SSH-сервера и платформенного хранилища

#### Scenario: Проверяются физические package boundaries
- **WHEN** выполняется анализ package manifests и импортов
- **THEN** dependency graph соответствует `business_logic → domain`, `data → domain`, `app → domain + data + business_logic` и не содержит обратных зависимостей

### Requirement: Presentation exposes explicit pages
Корневой Flutter presentation MUST быть организован через `lib/ui/app`, `lib/ui/pages` и `lib/ui/shared`. Каждая маршрутизируемая пользовательская поверхность MUST иметь явную страницу в `lib/ui/pages/<page>/`, а page-specific widgets MUST находиться рядом с этой страницей. Composition, routing, theme и lifecycle MUST находиться в `lib/ui/app`, а действительно переиспользуемые UI-компоненты — в `lib/ui/shared`.

#### Scenario: Добавляется маршрутизируемый экран
- **WHEN** создаётся новая пользовательская страница
- **THEN** её page widget и локальные компоненты размещаются в отдельном каталоге `lib/ui/pages/<page>/`, а маршрут регистрируется через app routing

#### Scenario: UI-компонент используется несколькими страницами
- **WHEN** один компонент действительно переиспользуется разными страницами
- **THEN** он размещается в `lib/ui/shared`, не перенося туда page-specific business behavior

### Requirement: Explicit session state
Жизненный цикл SSH-сессии MUST представляться явными immutable состояниями и событиями. Состояния MUST различать как минимум отключение, подключение, проверку host key, аутентификацию, активное соединение, переподключение и ошибку.

#### Scenario: Host key неизвестен
- **WHEN** сервер предъявляет fingerprint, отсутствующий в known hosts
- **THEN** сессия переходит в состояние подтверждения host key и не продолжает аутентификацию без решения пользователя

#### Scenario: Приложение возвращается из background
- **WHEN** мобильная ОС прервала сетевое соединение в фоне
- **THEN** состояние отражает потерю соединения и позволяет контролируемое переподключение

### Requirement: SSH secrets remain protected
Пароли, passphrase и приватные ключи MUST храниться только в защищённом системном хранилище или в памяти на минимально необходимое время. Реализация MUST проверять host key и MUST NOT безусловно принимать любой fingerprint. Секреты MUST NOT попадать в логи, аналитику, crash reports или сериализованные состояния.

#### Scenario: Профиль подключения сохраняется
- **WHEN** пользователь сохраняет профиль с секретом
- **THEN** несекретные параметры сохраняются отдельно, а секрет передаётся в защищённое хранилище

#### Scenario: Fingerprint сервера изменился
- **WHEN** сохранённый fingerprint не совпадает с предъявленным сервером
- **THEN** соединение блокируется до явного безопасного решения пользователя

### Requirement: Dependencies are reproducible and verified
Проект MUST использовать явные версии последних стабильных совместимых релизов на момент принятия изменения. `any` и необоснованные `dependency_overrides` MUST NOT использоваться. После изменения зависимостей проект MUST успешно проходить dependency resolution, статический анализ и автоматические тесты.

#### Scenario: Добавляется библиотека
- **WHEN** новая зависимость включается в проект
- **THEN** её актуальная стабильная версия и совместимость с текущими Flutter/Dart проверяются перед фиксацией lock-файла

#### Scenario: Проверка изменения завершена
- **WHEN** реализация готова к завершению
- **THEN** `flutter pub get`, `flutter analyze` и `flutter test` выполняются без ошибок

### Requirement: Terminal stream avoids global rebuilds
Высокочастотный терминальный вывод MUST передаваться непосредственно в terminal buffer или специализированный stream adapter и MUST NOT храниться как постоянно растущий глобальный BLoC state.

#### Scenario: Сервер выдаёт большой объём stdout
- **WHEN** SSH-сессия получает поток терминальных данных
- **THEN** данные поступают в terminal buffer без создания нового глобального состояния на каждый chunk

### Requirement: Quality is covered by layered tests
Domain-логика и BLoC MUST иметь unit-тесты, репозитории и адаптеры MUST иметь contract/integration tests, а критические пользовательские сценарии MUST иметь widget tests. Сетевые тесты MUST использовать управляемый тестовый SSH-сервер или fake transport, а не внешнюю нестабильную инфраструктуру.

#### Scenario: Реализован reconnect
- **WHEN** добавляется политика переподключения
- **THEN** тесты покрывают успешное восстановление, исчерпание retry и ручное отключение без повторного подключения
