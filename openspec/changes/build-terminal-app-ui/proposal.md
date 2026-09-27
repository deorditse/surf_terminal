# Proposal

## Why

Surf Terminal пока содержит стандартный Flutter counter screen и не имеет согласованного пользовательского интерфейса SSH-клиента. Нужен целостный мобильный presentation layer для iOS и Android, который покрывает основные экраны терминального приложения, использует предоставленные xTerminal screenshots только как функциональный и композиционный референс и при этом имеет собственную визуальную систему Surf Terminal.

## What Changes

- Заменить demo counter на адаптивный Surf Terminal app shell с разделами SSH, SFTP, Snippets и Settings.
- Добавить явные страницы в `lib/ui/pages` для списка SSH hosts, редактора host, terminal workspace, SFTP, snippets, редактора snippet и settings.
- Декомпозировать каждую route-level страницу по ответственности на composition-only `*_page.dart` и локальные `widgets`, `sections`, `dialogs`, `form` либо `modules`; не оставлять самостоятельные визуальные блоки и workflow в раздутых page-файлах.
- Разделить общий presentation state, модели и reusable widgets на feature-oriented модули вместо единого cross-feature Cubit и файлов-агрегаторов с несвязанными классами.
- Реализовать навигацию между страницами, сохранение состояния основных вкладок и интерактивные presentation-состояния без реального SSH/SFTP transport.
- Добавить terminal workspace с mock terminal content, несколькими вкладками сессий и дополнительной клавиатурной панелью.
- Реализовать формы host и snippet с локальной валидацией, безопасным password field и platform-adaptive controls.
- Реализовать settings для темы терминала, размера шрифта, cursor style/blink, emulation type, keepalive и keep-awake.
- Создать собственные design tokens и reusable widgets Surf Terminal; не копировать branding, логотипы, assets, платные ограничения, App Store UI или точные визуальные параметры xTerminal.
- Добавить widget и golden tests для ключевых экранов, адаптивности и интерактивных состояний.
- Зафиксировать долгосрочное presentation-решение отдельным ADR Surf Terminal.

## Capabilities

### New Capabilities

- `terminal-app-shell`: Корневая навигация Surf Terminal, устойчивое состояние вкладок, адаптивный layout и собственная визуальная система.
- `ssh-host-interface`: Список SSH hosts, empty/data states и форма создания/редактирования профиля с локальной валидацией.
- `terminal-workspace-interface`: Терминальная рабочая область, mock session tabs и дополнительная клавиатурная панель.
- `sftp-interface`: Базовая файловая поверхность SFTP с состояниями empty/loading/data/error без сетевого transport.
- `snippets-interface`: Список, empty state и редактор командных snippets.
- `terminal-settings-interface`: Настройки внешнего вида и поведения терминала с локальными интерактивными состояниями.

### Modified Capabilities

Нет.

## Impact

- Будут созданы декомпозированные presentation-модули в `lib/ui/app`, `lib/ui/pages` и `lib/ui/shared`; route files останутся точками композиции, а feature-specific элементы — рядом со своей страницей.
- `pubspec.yaml` будет изменён только для зависимостей, необходимых утверждённой архитектуре, routing/state management и тестированию; существующие пользовательские изменения должны быть сохранены.
- Будут добавлены assets только собственной разработки либо системные/Material/Cupertino icons с допустимой лицензией.
- Будут добавлены widget/golden tests и test fixtures без реальных адресов, имён пользователей, паролей или ключей из предоставленных screenshots.
- Реальные SSH authentication, host-key verification, SFTP I/O, persistence и secure storage не реализуются в этом UI change и требуют отдельных OpenSpec changes.
