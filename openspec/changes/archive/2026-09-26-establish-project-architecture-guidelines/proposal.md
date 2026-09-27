# Proposal

## Why

Проекту мобильного SSH-клиента Surf Terminal нужен единый архитектурный контракт, который физически изолирует domain, data и business logic, оставляет presentation понятным через явные страницы и не допускает скрытых зависимостей. Контракт также должен закрепить безопасную работу с SSH-секретами, согласованный Flutter-стек и обязательный OpenSpec workflow до реализации.

## What Changes

- Добавить корневой `AGENT.md` как обязательное руководство по архитектуре и инженерным решениям проекта.
- Зафиксировать package-based Clean Architecture: `packages/domain`, `packages/data`, `packages/business_logic` и корневой Flutter presentation в `lib/ui`.
- Организовать presentation через `lib/ui/app`, `lib/ui/pages` и `lib/ui/shared`, с отдельным каталогом каждой пользовательской страницы.
- Стандартизировать Flutter BLoC, Freezed, GetIt с constructor injection, go_router, dartssh2, xterm, `sqflite` для структурированных несекретных данных и `flutter_secure_storage` для SSH-секретов.
- Определить границы зависимостей, правила моделей, репозиториев, SSH-сессий, терминального потока, безопасности и lifecycle iOS/Android.
- Зафиксировать тестовую стратегию, кодогенерацию, линтинг и критерии готовности изменений.
- Зафиксировать обязательный OpenSpec workflow: сначала proposal/spec/design/tasks, затем явное одобрение пользователя, и только после отдельного запроса — apply.
- Сделать OpenSpec workflow прозрачным: перед выполнением показывать команду, её цель и ожидаемый эффект; запрашивать approve перед изменением planning artifacts, apply, archive и destructive operations.
- Добавить `docs/adr/` для решений именно Surf Terminal, единый ADR-шаблон и проектные ADR по архитектуре, SSH-сессиям, DI, storage и delivery workflow; изменение принятого storage-решения оформлять новым superseding ADR без переписывания истории.
- Не выдавать устройство референсных приложений за решение Surf Terminal: внешние проекты используются только как исследовательский материал, а ADR описывают контекст, выбор и последствия текущего проекта.
- Указать, что версии библиотек выбираются по последним стабильным совместимым релизам и проверяются через `flutter pub get`, `flutter analyze` и тесты; не использовать `any` и беспричинные `dependency_overrides`.

## Capabilities

### New Capabilities

- `project-development-governance`: Архитектурные границы, утверждённый Flutter-стек, правила безопасности SSH-клиента, quality gates и обязательный OpenSpec approval workflow.

### Modified Capabilities

Нет.

## Impact

- Добавляются документация `AGENT.md` в корне проекта и каталог `docs/adr/` с шаблоном и начальными архитектурными решениями.
- Меняется ожидаемый процесс всех будущих задач: OpenSpec-команды объявляются заранее, а planning writes, apply, archive и destructive operations требуют явного approve.
- Будущие зависимости и структура `lib/` и `packages/` должны соответствовать утверждённому package graph и Clean Architecture.
- На этапе планирования исходный код, `pubspec.yaml` и платформенные проекты не изменяются.
