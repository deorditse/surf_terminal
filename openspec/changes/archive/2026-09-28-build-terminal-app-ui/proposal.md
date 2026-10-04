# Proposal

## Why

Surf Terminal уже имеет рабочий prototype UI и утверждённые `*_layout` boundaries, но продуктовая поверхность всё ещё содержит полностью фиктивный SFTP-раздел, предзаполненные demo SSH hosts и светлую тему, которые создают ложное впечатление готовых подключений и размывают тёмную идентичность терминального приложения. Нужен честный SSH-first интерфейс: без вымышленных подключений, без SFTP и с оригинальным dark-only Surf Terminal branding от native splash до terminal workspace.

## What Changes

- **BREAKING:** полностью удалить SFTP из primary navigation, routing, UI, business/domain/data layouts, DI и тестов.
- Изменить SSH home так, чтобы новый запуск не содержал demo hosts; список показывает только профили, созданные пользователем в текущем prototype workflow.
- Сохранить создание, редактирование, валидацию и удаление SSH profiles, но не утверждать, что offline prototype выполняет сетевое соединение.
- Перевести приложение в принудительный dark-only режим и удалить light/system app-theme behavior; terminal palettes остаются только тёмными вариантами.
- Уточнить оригинальный Surf Terminal visual language: глубокие ocean/graphite surfaces, surf-blue/cyan accents, terminal-focused typography и собственная иконографика без копирования xTerminal branding/assets.
- Добавить оригинальные splash assets Surf Terminal, настроить `flutter_native_splash` для тёмного fullscreen launch screen с centered mark и bottom branding и сгенерировать Android/iOS launch resources.
- Добавить оригинальную app icon Surf Terminal для iOS и Android, включая Android adaptive foreground/background, и сгенерировать platform icon sets через `flutter_launcher_icons`.
- Сохранить три primary areas: SSH, Snippets и Settings; terminal workspace и editors остаются отдельными routes.
- Пересоздать goldens и тесты для empty-first SSH, трёхсекционной навигации, dark-only theme и splash configuration.
- Зафиксировать замену presentation decision новым ADR без переписывания истории ADR-0009.

## Capabilities

### New Capabilities

- `terminal-app-shell`: Корневая трёхсекционная навигация, адаптивный dark-only layout, оригинальная визуальная идентичность и native splash Surf Terminal.
- `ssh-host-interface`: Empty-first список только пользовательских SSH profiles и форма создания/редактирования без demo hosts.
- `terminal-workspace-interface`: Терминальная рабочая область, offline session tabs и дополнительная клавиатурная панель.
- `snippets-interface`: Список, empty state и редактор командных snippets.
- `terminal-settings-interface`: Тёмные terminal palettes и настройки поведения без light/system app-theme переключения.

### Modified Capabilities

Нет: эти capabilities ещё не архивированы и пересогласуются внутри текущего change до первого продвижения в canonical specs.

## Impact

- Удаляются `lib/**/sftp*`, SFTP exports/contracts/adapters/state, `/sftp` route и соответствующие тесты.
- Меняются `PreviewFixtureSource`, profile repository defaults, app shell/router/DI, theme/settings UI, goldens и тестовые fixtures.
- В `pubspec.yaml` добавляются совместимые pinned/caret dev dependencies `flutter_native_splash` и `flutter_launcher_icons`, собственные splash/icon assets и configurations; выполняется генерация Android/iOS launch и icon resources.
- Presentation paths остаются в `lib/ui_layout`, business/domain/data ownership — в утверждённых layout directories.
- xTerminal используется только как функциональный ориентир для зрелого SSH-клиента; название, логотип, assets и точные визуальные параметры не копируются.
- Реальный SSH transport, authentication, host-key verification, persistence и secure storage не входят в этот UI change и требуют отдельных OpenSpec changes.
