# Design

## Context

См. `proposal.md`. Проект содержит стандартный Flutter counter app и пока не имеет presentation architecture. Параллельный change `establish-project-architecture-guidelines` устанавливает целевую структуру `lib/ui/app`, `lib/ui/pages`, `lib/ui/shared` и package-based boundaries. Предоставленные screenshots показывают полезную продуктовую композицию SSH-клиента, но содержат чужой branding, App Store chrome и пользовательские данные, которые нельзя переносить в проект или fixtures.

## Goals / Non-Goals

**Goals:**

- Создать целостный, навигируемый и визуально согласованный mobile UI Surf Terminal.
- Продемонстрировать все ключевые экраны и состояния на безопасных локальных fixtures.
- Сделать интерфейс адаптивным, доступным и тестируемым на iOS/Android.
- Подготовить presentation boundaries для последующего подключения BLoC, repositories и реального SSH/SFTP transport.

**Non-Goals:**

- Реальное SSH/SFTP соединение, authentication, host-key verification и remote file operations.
- Постоянное хранение profiles, snippets или settings и работа с secure storage.
- Копирование xTerminal branding, assets, платной модели, App Store UI либо pixel-perfect reproduction.
- Реализация batch execute, LAN scan, cloud backup, subscription и contact workflows.

## Decisions

### 1. Оригинальная визуальная система Surf Terminal

UI использует Material 3 как cross-platform foundation с собственной тёмной палитрой Surf Terminal: почти чёрный canvas, elevated graphite surfaces, холодный surf-blue accent, высококонтрастный terminal text и спокойные muted labels. Компоненты используют общие spacing, radius, elevation, typography и motion tokens из `lib/ui/app/theme`.

Функциональная композиция референса сохраняется там, где она ожидаема для SSH-клиента: app sections, host list, terminal tabs, special-key toolbar и grouped settings. Точные размеры, gradients, branding, labels и proprietary assets не копируются.

**Альтернатива:** pixel-perfect clone. Отклонена из-за отсутствия собственной идентичности, platform inconsistencies и рисков копирования чужого оформления.

### 2. Presentation structure with explicit pages

```text
lib/
├── main.dart
└── ui/
    ├── app/
    │   ├── app.dart
    │   ├── router/
    │   └── theme/
    ├── pages/
    │   ├── shell/
    │   ├── connections/
    │   │   ├── connections_page.dart
    │   │   ├── widgets/
    │   │   └── dialogs/
    │   ├── connection_editor/
    │   │   ├── connection_editor_page.dart
    │   │   ├── form/
    │   │   └── sections/
    │   ├── terminal/
    │   │   ├── terminal_page.dart
    │   │   └── widgets/
    │   ├── sftp/
    │   │   ├── sftp_page.dart
    │   │   └── widgets/
    │   ├── snippets/
    │   │   ├── snippets_page.dart
    │   │   ├── widgets/
    │   │   └── dialogs/
    │   ├── snippet_editor/
    │   │   ├── snippet_editor_page.dart
    │   │   └── form/
    │   └── settings/
    │       ├── settings_page.dart
    │       ├── sections/
    │       └── widgets/
    └── shared/
        ├── models/
        └── widgets/
```

Каждый route-level widget находится в `pages`; `*_page.dart` остаётся точкой композиции и не содержит самостоятельные карточки, секции, dialogs или сложные form modules. Локальные widgets остаются рядом со страницей. Только элементы, доказанно используемые несколькими pages, переходят в `shared`.

Из Gigalegal используется принцип `page → modules/widgets/src` и коротких composition pages. Его конкретные widgets, naming, service-locator access и dependency violations не копируются. Surf Terminal применяет более строгие границы:

- route-level page SHOULD укладываться в 150 handwritten строк;
- любой handwritten Dart-файл MUST укладываться в 200 строк, если в design/review нет явного обоснования исключения;
- три и более самостоятельных widget-класса либо несколько несвязанных responsibilities в одном файле требуют разделения;
- barrel-файл MAY только экспортировать элементы и не должен скрывать реализацию нескольких responsibilities;
- generated-файлы и декларативные tables являются исключениями только при зафиксированном обосновании.

### 3. Stateful shell and routing

Корневой shell содержит четыре branches: SSH, SFTP, Snippets, Settings. Каждая branch сохраняет собственный navigator/scroll state. Host editor, snippet editor и terminal workspace открываются поверх shell как отдельные routes. Routing следует утверждённому `go_router` convention; dependencies создаются composition root.

**Альтернатива:** один `IndexedStack` без router. Отклонена, поскольку editor/workspace routes и deep-link-ready structure важны для дальнейшего развития.

### 4. UI state through injected BLoC/Cubit boundaries

Shell selection, in-memory profiles, snippets, terminal preview sessions, SFTP fixtures и settings представлены отдельными feature-oriented Cubit/state modules. Один cross-feature `AppCubit` не владеет несвязанными workflows. Composition root подключает feature Cubits через providers; widgets не обращаются к GetIt. Generated Freezed unions применяются там, где есть взаимоисключающие loading/data/error states; простой локальный selection не требует искусственного event boilerplate.

Presentation models разделяются по самостоятельным понятиям (`SshProfile`, `CommandSnippet`, `PreviewSession`, `TerminalPreferences`, SFTP state). Shared widgets также хранятся по одному responsibility на файл; feature-specific components не поднимаются в `shared` ради сокращения page-файла.

Raw terminal transport отсутствует. Mock terminal lines являются immutable fixture и не моделируют успешное сетевое соединение.

### 5. Safe fixtures

Fixtures используют зарезервированные documentation domains/IP ranges и вымышленные labels. Ни один host, username, credential, key, avatar или иной пользовательский фрагмент со screenshots не переносится в source, tests, goldens или docs. Password fixtures остаются пустыми.

### 6. Page composition

- **SSH:** original header, search/sort controls, profile cards, empty state and add action.
- **Host editor:** sectioned scrollable form with inline validation, secure password control and advanced collapsed sections.
- **Terminal:** session tab strip, offline preview banner, terminal viewport and horizontally scrollable special-key toolbar.
- **SFTP:** host selector plus fixture file browser with explicit empty/loading/data/error samples.
- **Snippets:** empty/list/search states and editor route.
- **Settings:** grouped cards for help, terminal appearance, connection behavior and about; unsupported commercial/cloud tools are omitted.

### 7. Responsive and platform behavior

`SafeArea`, keyboard insets and bounded content widths are mandatory. Compact phones use bottom navigation; larger widths may use NavigationRail while preserving the same destinations. Controls retain at least platform-recommended touch target sizes. Cupertino-like interaction conventions may be used on iOS where they improve native behavior, but design tokens remain shared.

### 8. Testing strategy

- Widget tests cover tab navigation, route transitions, empty/data/error states and form validation.
- Golden tests cover compact iOS-like and Android-like viewport sizes for shell, host editor, terminal, snippets and settings.
- Accessibility tests verify semantics for navigation, switches, secure fields and primary actions.
- Overflow tests use increased text scale.
- Fixtures and goldens are reviewed to ensure no real credentials or copyrighted screenshots are embedded.

### 9. ADR

Apply creates `ADR-0009-surf-terminal-presentation-system.md`. It records original design tokens, explicit page organization, adaptive shell, fixture-only UI boundary and the rejected pixel-perfect clone alternative. It is an ADR about Surf Terminal; reference products are not treated as architecture authorities.

## Risks / Trade-offs

- **[Mock interactions may be mistaken for real transport]** → Persistent offline/preview semantics and no success language implying a live connection.
- **[UI change grows too broad]** → Keep network, persistence and platform side effects out; require separate OpenSpec changes.
- **[Golden tests become brittle across platforms]** → Pin fonts/test surface sizes and keep a small set of representative goldens.
- **[Bottom navigation competes with the keyboard]** → Terminal workspace is a separate route and may hide root navigation while preserving session tabs and toolbar.
- **[Reference similarity is too high]** → Use original tokens, component geometry, copy and icons; perform a visual review before acceptance.
- **[Architecture change is not applied first]** → Treat approved architecture update as a prerequisite and do not implement UI against the obsolete feature-first contract.
- **[Mechanical splitting creates excessive indirection]** → Extract only independently understandable sections, controls and workflows; keep tiny one-use layout fragments private when the owning file remains within the size and responsibility guardrails.

## Migration Plan

1. Apply and verify the revised architecture-guidelines change first.
2. Resolve latest stable compatible dependencies without overwriting existing user edits in `pubspec.yaml`.
3. Add app theme, router and shell foundation.
4. Implement pages and in-memory presentation state incrementally, with tests per capability.
5. Decompose pages into local widgets/sections/dialogs/forms, split shared aggregators and replace cross-feature state ownership with feature Cubits without changing visible behavior.
6. Replace the demo entry point only after the shell and navigation tests pass.
7. Create ADR-0009 and update the ADR index.
8. Run structural checks, format, analyze, unit/widget tests and selected golden tests on supported test surfaces.
9. Roll back by restoring the demo entry point and removing only files introduced by this change; preserve unrelated user-owned files.
