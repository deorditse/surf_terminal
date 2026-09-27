# Design

## Context

См. `proposal.md`. Текущий репозиторий — минимальный Flutter-проект под iOS/Android с Dart 3.13.4 и Flutter 3.47.5. Ранний вариант контракта ошибочно закрепил feature-first слои внутри одного приложения. После исследования package-based и feature-based Flutter-проектов целевой контракт Surf Terminal уточнён: независимость ключевых слоёв обеспечивается локальными packages, presentation остаётся в корневом приложении и организуется через явные pages. Референсные проекты служат только исследовательским материалом и не являются частью архитектуры или ADR Surf Terminal.

## Goals / Non-Goals

**Goals:**

- Создать один корневой документ, достаточный для одинаковых архитектурных решений людьми и AI-агентами.
- Зафиксировать собственную архитектуру Surf Terminal с физически проверяемыми package boundaries.
- Установить проверяемые границы Clean Architecture и правила безопасности.
- Сделать OpenSpec обязательным approval gate перед любым apply.
- Зафиксировать политику актуальных стабильных зависимостей без превращения документа в быстро устаревающий lock-файл.

**Non-Goals:**

- Не реализовывать фичи SSH-клиента в этом change.
- Не менять `pubspec.yaml`, исходный код или платформенные настройки.
- Не дробить проект на дополнительные packages без независимой ответственности и отдельного ADR.
- Не копировать архитектурные нарушения, продуктовый UI, branding или assets исследованных приложений.

## Decisions

### 1. Корневой `AGENT.md` как архитектурный контракт

Документ будет содержать обязательные правила, decision log и команды проверки. Он должен быть достаточно конкретным для code review, но не дублировать весь OpenSpec.

**Альтернатива:** хранить правила только в OpenSpec specs. Отклонено: агентам и разработчикам нужен короткий входной документ, применяемый к каждой задаче.

### 2. Package-based Clean Architecture для Surf Terminal

Целевая структура:

```text
lib/
├── main.dart
└── ui/
    ├── app/
    │   ├── bootstrap/
    │   ├── di/
    │   ├── lifecycle/
    │   ├── router/
    │   └── theme/
    ├── pages/
    │   ├── connections/
    │   ├── connection_editor/
    │   ├── terminal/
    │   ├── sftp/
    │   ├── snippets/
    │   ├── snippet_editor/
    │   ├── known_hosts/
    │   └── settings/
    └── shared/

packages/
├── domain/
├── data/
└── business_logic/
```

Dependency direction:

```text
business_logic → domain
data → domain
root Flutter app → domain + data + business_logic
```

`domain` остаётся pure Dart и владеет entities, value objects, failures, result types и contracts. `data` содержит SSH, persistence и secure-storage adapters и реализует domain contracts. `business_logic` содержит BLoC, use cases и policies, но не знает о `data`. Composition root в `lib/ui/app/di` — единственное место, где реализации связываются с интерфейсами. Pages используют BLoC через constructor/provider composition и не создают infrastructure dependencies.

**Альтернативы:** single-package feature-first отклонён, поскольку не обеспечивает требуемой физической изоляции; packages `application`, `infrastructure` и `design_system` дополнительно к выбранным слоям отклонены как преждевременное усложнение. Три внутренних package дают проверяемые границы без лишней декомпозиции.

### 3. BLoC + Freezed

`flutter_bloc` управляет пользовательскими workflow и состоянием сессий. Freezed используется для immutable events/states и sealed unions. `bloc_concurrency` применяется осознанно: `droppable` для повторного connect, `restartable` для поиска/фильтров, `sequential` для операций, где важен порядок.

Терминальные байты не складываются в BLoC state. BLoC содержит статус, метаданные, ошибки и user intent; raw I/O идёт через session adapter в buffer xterm.

**Альтернатива:** Riverpod. Технически пригоден, но отклонён ради соответствия проверенному стеку референсного проекта и явной event/state модели SSH lifecycle.

### 4. GetIt только в composition root

`get_it` используется как контейнер регистрации, но классы получают зависимости через constructors. Внутри BLoC, repositories и services запрещены вызовы `GetIt.I.get()`.

**Альтернатива:** глобальный service locator, как часть Gigalegal. Отклонено из-за скрытых зависимостей и сложных тестов.

### 5. SSH и терминальный стек

- `dartssh2` — SSH transport, shell, PTY и authentication adapter.
- `xterm` — terminal emulator и buffer.
- Domain-контракт `SshSession` скрывает конкретную библиотеку.
- Каждая вкладка терминала имеет отдельный `sessionId`, BLoC/controller и disposable session scope.
- Resize terminal вызывает PTY resize с debounce.
- Lifecycle допускает разрыв TCP в background и явный reconnect.

### 6. Storage и безопасность

- `flutter_secure_storage` — пароль, passphrase, приватные ключи и другие секреты.
- `sqflite` — прямой SQLite persistence adapter для профилей подключений, labels, known hosts, snippets, настроек и истории несекретных метаданных; терминальный transcript по умолчанию не сохраняется.
- Схема имеет явную версию. Все изменения проходят последовательные `onCreate`/`onUpgrade` migrations, выполняются транзакционно и покрываются migration tests с предыдущих поддерживаемых версий.
- Foreign keys включаются при открытии БД; repository integration tests проверяют constraints, transactions и rollback. SQL, имена таблиц и `sqflite` types не выходят за пределы `packages/data`.
- Secure values связываются с profile ID через opaque reference и не дублируются в SQLite.
- Known-host проверка обязательна; first-use fingerprint показывается пользователю, mismatch блокирует соединение.
- Логирование выполняется через централизованный redacting logger.

**Альтернативы:** Drift даёт compile-time typed queries, reactive streams и code generation, но отклонён ради более распространённого прямого SQLite API и меньшего persistence abstraction surface. Hive legacy несовместим с текущим Dart SDK, а Hive CE остаётся key-value/document-oriented fork и хуже соответствует связанной схеме profiles/labels/known hosts/snippets. SharedPreferences для всех данных отклонён из-за отсутствия структурированных запросов, constraints и надёжных schema migrations.

### 7. Навигация

`go_router` определяет typed route conventions для connections, editor, terminal session, known hosts и settings. Авторизационный redirect не нужен, пока нет отдельной продуктовой потребности.

### 8. Result и ошибки

Domain операции возвращают явный `Result<T, Failure>` или эквивалентный sealed type проекта. Исключения от библиотек перехватываются на data boundary и преобразуются в типизированные failures. Stack trace сохраняется для диагностического логирования после redaction.

Не добавляется сторонний functional package без необходимости: небольшой sealed Result можно реализовать средствами Dart/Freezed.

### 9. Версии зависимостей

`AGENT.md` укажет два уровня:

1. утверждённые package names и роли;
2. снимок проверенных стабильных версий для первоначальной установки.

Перед фактическим изменением `pubspec.yaml` версии повторно проверяются через pub.dev или resolver, потому что «latest» изменяется со временем. На момент обновления design pub.dev подтверждает `sqflite 2.4.4` с требованиями Dart `^3.12.0` и Flutter `>=3.44.0`, совместимыми с Dart 3.13.4 и Flutter 3.47.5. Остальной ранее проверенный snapshot: `bloc_concurrency 0.3.0`, `freezed_annotation 3.1.0`, `json_serializable 6.14.1`, `json_annotation 4.12.0`, `build_runner 2.16.1`, `get_it 9.3.0`, `go_router 18.0.1`, `dartssh2 4.1.0`, `xterm 4.0.0`, `flutter_secure_storage 11.2.0`, `path_provider 2.1.6`, `uuid 4.6.0`, `logger 2.8.0`, `mocktail 1.0.5`, `flutter_lints 6.0.0`. Версии `flutter_bloc`, `freezed` и всего полного graph должны быть повторно подтверждены resolver-ом во время соответствующего dependency apply.

`any` запрещён. Overrides допускаются только как временное документированное решение с issue/причиной и планом удаления.

### 11. Architecture Decision Records Surf Terminal

`AGENT.md` хранит действующие правила проекта, а `docs/adr/` объясняет, почему значимые архитектурные решения были приняты, какие альтернативы рассматривались и какие последствия приняты командой.

Структура каталога:

```text
docs/adr/
├── README.md
├── template.md
├── ADR-0001-feature-first-clean-architecture.md        # Superseded
├── ADR-0002-flutter-bloc-and-freezed.md
├── ADR-0003-getit-constructor-injection.md
├── ADR-0004-dartssh2-and-xterm.md
├── ADR-0005-drift-and-secure-storage.md               # Superseded
├── ADR-0006-openspec-approval-workflow.md
├── ADR-0007-package-based-clean-architecture.md        # Accepted
└── ADR-0008-sqflite-and-secure-storage.md              # Accepted
```

Шаблон сохраняется в согласованной форме:

```markdown
# ADR-NNNN: Decision title

Status: Proposed | Accepted | Deprecated | Superseded
Date: YYYY-MM-DD

## Context

Почему вообще нужно было принять решение.

## Decision

Что выбрали.

## Alternatives

Какие варианты рассматривали.

## Consequences

Что это дает и какие ограничения появляются.
```

Правила:

- номера последовательные и не переиспользуются;
- каждый ADR формулирует проблему и решение Surf Terminal; названия референсных проектов не являются решением и допускаются только как источник альтернатив при необходимости;
- новые ADR сначала могут иметь `Proposed`, а после approve — `Accepted`;
- принятый ADR не переписывается для изменения решения: создаётся новый ADR, старый получает `Superseded` и ссылку на замену;
- дата фиксируется на этапе apply по фактической дате принятия;
- локальные детали реализации без долгосрочного архитектурного влияния ADR не требуют;
- `README.md` содержит индекс ADR и их статусы;
- `AGENT.md` ссылается на `docs/adr/` как на журнал обоснований.

**Альтернатива:** хранить rationale только в OpenSpec design. Отклонено: change после archive отражает конкретное изменение, тогда как ADR нужен как устойчивый хронологический журнал решений между изменениями.

### 12. OpenSpec workflow

Любая задача проходит:

```text
request
  → announce planning command and expected effect
  → user approves planning write
  → openspec propose/update
  → review/approval by user
  → announce apply command and expected effect
  → explicit apply approval
  → implementation + tests
  → verification
  → user review
  → announce archive command and expected effect
  → explicit archive approval
```

Approval policy:

- `list`, `context`, `status`, `show`, `instructions`, `validate` и другие read-only discovery commands выполняются после предварительного показа команды и цели;
- создание change и запись/изменение planning artifacts требуют approve;
- apply требует отдельного approve после review всех planning artifacts;
- archive и destructive operations требуют отдельного approve с точной командой и описанием эффекта;
- если apply обнаруживает material scope change, работа останавливается, planning artifacts обновляются только после approve и затем проходят повторное согласование;
- после команд агент показывает фактический результат, а не только утверждает успех.

### 13. Code generation and quality gates

Стандартная команда генерации:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Обязательные проверки перед завершением apply:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

После изменения dependencies дополнительно:

```bash
flutter pub get
flutter pub outdated
```

Generated-файлы не редактируются вручную. Политика коммита generated-файлов должна быть единой: для приложения рекомендуется коммитить их, чтобы сборка была воспроизводимой без генератора в runtime pipeline.

Глобальный каталог `lib/generated` не создается как заготовка. Он допустим только при наличии явно настроенного генератора, который пишет в этот путь; иначе generated-файлы остаются рядом с исходниками или в стандартных output-путях конкретного генератора.

## Risks / Trade-offs

- **[AGENT.md устареет относительно pub.dev]** → точные версии являются snapshot; перед изменением `pubspec.yaml` resolver обязан перепроверить latest stable и совместимость.
- **[BLoC может получать слишком частые события от терминала]** → raw stream идёт напрямую в xterm buffer, BLoC хранит только control-plane state.
- **[Clean Architecture создаёт boilerplate]** → use case создаётся только при наличии бизнес-правила или повторного использования; простые repository calls не оборачиваются механически.
- **[GetIt снова превратится в service locator]** → доступ к контейнеру разрешён только в bootstrap/composition root; зависимости передаются constructors.
- **[Ручной SQL и migrations в sqflite дают меньше compile-time гарантий, чем Drift]** → локализовать SQL в `packages/data`, централизовать schema/migrations и покрыть repository, constraint и migration tests.
- **[Мобильная ОС прерывает SSH в background]** → не обещать постоянную background-сессию, моделировать disconnect/reconnect явно.
- **[OpenSpec замедляет мелкие задачи]** → масштаб артефактов пропорционален изменению, но announcement и approval gates сохраняются для всех project writes.
- **[ADR могут дублировать OpenSpec design]** → ADR фиксирует только долговечное архитектурное решение и связывается с change; временные детали остаются в design.
- **[Слишком много approval prompts]** → read-only discovery не требует отдельного approve после объявления; approve обязателен только для planning writes, apply, archive и destructive operations.

## Migration Plan

1. После нового apply approval обновить `AGENT.md` под package-based архитектуру и явные pages.
2. Создать `ADR-0007-package-based-clean-architecture.md`, пометить ADR-0001 как `Superseded`, связать документы и обновить ADR index.
3. Создать `ADR-0008-sqflite-and-secure-storage.md`, пометить ADR-0005 как `Superseded`, добавить reciprocal links и обновить ADR index; историческое содержание ADR-0005 сохранить.
4. Обновить активный storage contract в `AGENT.md`: sqflite остаётся внутри `packages/data`, а SSH-секреты — только в platform secure storage.
5. Проверить, что ADR-0002…ADR-0008 описывают только решения Surf Terminal; исправлять factual wording разрешается без изменения принятого решения, а изменение решения требует нового superseding ADR.
6. Проверить документы на полноту относительно proposal/spec/design, последовательность ADR-номеров и ссылки между `AGENT.md` и ADR index.
7. Не изменять зависимости, исходный код или платформенные настройки в рамках этого change.
8. Последующие изменения структуры и `pubspec.yaml` оформить отдельными OpenSpec changes с ADR для новых значимых решений.
