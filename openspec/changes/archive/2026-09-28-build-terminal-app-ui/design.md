# Design

## Context

См. `proposal.md`. Текущая реализация уже использует `domain_layout`, `business_layout`, `data_layout` и `ui_layout`, пять feature Cubits и декомпозированные страницы. Однако SFTP является полностью локальной демонстрацией, SSH home загружается двумя fixture profiles, app theme может стать светлой, а native splash остаётся стандартным Flutter. Эти элементы должны быть удалены или заменены без нарушения принятых layout boundaries.

## Goals / Non-Goals

**Goals:**

- Сделать Surf Terminal честным SSH-first prototype без предзаполненных подключений и SFTP.
- Зафиксировать dark-only продуктовую идентичность на app и native splash уровнях.
- Сохранить forms, terminal preview, snippets, settings, адаптивность и декомпозицию.
- Обеспечить воспроизводимую генерацию splash resources и тестируемую конфигурацию.

**Non-Goals:**

- Реальное SSH-соединение, authentication, host-key verification, persistence или secure storage.
- SFTP UI, contracts или подготовительные placeholders.
- Копирование xTerminal logo, screenshots, assets, exact colors/geometry или коммерческих функций.
- Светлая либо системно переключаемая app theme.

## Decisions

### 1. SSH-first shell содержит три destinations

Primary shell содержит SSH, Snippets и Settings. Compact layout использует `NavigationBar`, expanded layout — `NavigationRail`. Terminal workspace, host editor и snippet editor остаются routes поверх shell.

SFTP удаляется целиком, а не скрывается feature flag: route, branch, navigation destination, page, domain values/contracts, business Cubit/state, data adapter/fixtures, DI and tests удаляются. Это предотвращает мёртвый API и ложное обещание remote files.

### 2. SSH home является empty-first

`InMemoryProfilesRepository` по умолчанию начинает с пустого списка. `PreviewFixtureSource` больше не создаёт SSH profiles. Populated state достигается только через host editor текущего запуска или явно injected test repository.

Empty state остаётся основной стартовой поверхностью с заметным действием создания host. Tests используют synthetic profile только там, где проверяется populated state, и никогда не подмешивают его в production defaults.

Нажатие на profile может открыть offline terminal preview, но UI обязан явно обозначать отсутствие live transport. Настоящее сетевое подключение будет отдельным security-sensitive change.

### 3. App theme всегда тёмная

`MaterialApp` использует только `SurfTheme.dark()` и `ThemeMode.dark`. Light palette и auto/system app-theme control удаляются. `TerminalPreferences.autoTheme` удаляется как неиспользуемый domain value; terminal palette selector остаётся набором тёмных terminal color schemes.

Surf visual language использует почти чёрный ocean canvas, graphite/navy surfaces, surf-blue primary, cyan/tide secondary, мягкий coral error и высококонтрастный terminal foreground. Все critical contrast pairs проверяются тестами.

**Альтернатива:** оставить light/system theme, но default dark. Отклонена, поскольку пользователь явно требует полностью тёмное приложение и единый branding.

### 4. Splash assets принадлежат Surf Terminal

Создаются два оригинальных PNG asset:

```text
assets/branding/splash-mark.png
assets/branding/splash-branding.png
```

Centered mark сочетает абстрактную волну и terminal prompt без использования чужого робота, логотипа или screenshot. Bottom branding содержит только собственную надпись/знак Surf Terminal. Assets проектируются для тёмного `#071018` или согласованного финального canvas и имеют прозрачный фон.

`pubspec.yaml` получает последнюю стабильную совместимую версию `flutter_native_splash` без `any`/override и top-level configuration:

```yaml
flutter_native_splash:
  color: "#071018"
  image: assets/branding/splash-mark.png
  branding: assets/branding/splash-branding.png
  web_image_mode: center
  branding_mode: bottom
  fullscreen: true
  android_12:
    color: "#071018"
    image: assets/branding/splash-mark.png
```

После dependency resolution выполняется:

```bash
dart run flutter_native_splash:create
```

Generated Android/iOS launch resources не редактируются вручную. Configuration и generated platform resources проверяются после команды.

### 5. App icon использует ту же оригинальную Surf identity

Создаётся master asset `assets/branding/app-icon.png` без third-party элементов. Знак использует ту же абстрактную волну/terminal prompt, что и splash, но упрощён для читаемости на малых размерах. Для Android дополнительно создаётся foreground asset с safe-zone margins и сплошной dark background color; iOS output не содержит alpha channel.

`pubspec.yaml` получает последнюю стабильную совместимую версию `flutter_launcher_icons` и configuration для Android adaptive icon и iOS AppIcon:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/branding/app-icon.png
  adaptive_icon_foreground: assets/branding/app-icon-foreground.png
  adaptive_icon_background: "#071018"
  remove_alpha_ios: true
```

После dependency resolution выполняется:

```bash
dart run flutter_launcher_icons
```

Generated mipmaps и AppIcon catalog не редактируются вручную. Проверяются Android circle/squircle safe masks, iOS required sizes, отсутствие alpha на iOS и successful platform builds.

### 6. Settings не обещают unavailable app themes

Settings сохраняют Terminal, Connection, Help и About sections. App-level auto theme control удаляется. Terminal palette, font, cursor, emulation and keepalive controls остаются. Все terminal palettes визуально тёмные.

Unsupported cloud/subscription/network scan actions остаются скрытыми или disabled; SFTP не упоминается.

### 7. Originality and decomposition remain gates

xTerminal задаёт только ожидаемую функциональную композицию SSH-клиента. Surf Terminal использует собственные tokens, copy, icon composition, splash and component shapes.

Route-level pages остаются до 150 handwritten lines, остальные handwritten Dart files — до 200, если нет зафиксированного исключения. Feature-local widgets остаются рядом со страницей.

### 8. Testing strategy

- Architecture test подтверждает отсутствие SFTP symbols/paths и запрещённых layout imports.
- Repository/Cubit/widget tests подтверждают empty-first SSH и user-created populated state.
- Shell tests подтверждают только SSH, Snippets, Settings на compact/expanded surfaces.
- Theme tests подтверждают forced dark mode и contrast-critical pairs.
- Splash test/inspection подтверждает config paths, asset readability, dark background and generated resources.
- Icon inspection подтверждает master/foreground readability, adaptive safe zone, iOS alpha removal и generated platform size sets.
- Goldens пересоздаются только после визуального review новых dark-only surfaces и synthetic-data scan.
- Android APK и iOS simulator builds подтверждают native splash resource linking.

## Risks / Trade-offs

- **[Empty home выглядит незавершённой]** → Создать сильный branded empty state и явный CTA без fake content.
- **[Пользователь ожидает настоящее соединение после создания profile]** → Сохранять explicit offline-preview language до отдельного transport change.
- **[Splash mark плохо масштабируется на Android 12 mask]** → Использовать safe central composition и отдельно проверить Android 12 generated resource.
- **[Native generator перезапишет platform files]** → Перед генерацией фиксировать diff, применять только утверждённую config и проверять exact generated targets.
- **[Удаление SFTP оставляет мёртвые imports/tests]** → Repository-wide symbol/path scan и clean builds на Android/iOS.
- **[Dark-only снижает системную адаптивность]** → Это сознательное product decision; terminal palette and accessibility controls сохраняются.

## Migration Plan

1. Зафиксировать baseline и удалить SFTP вертикально от UI к domain только в пределах change.
2. Сделать profiles repository empty by default и обновить SSH tests/goldens.
3. Удалить app auto/light theme paths, адаптировать settings и terminal preferences.
4. Уточнить Surf dark tokens и проверить contrast/adaptive surfaces.
5. Создать оригинальные splash и app-icon PNG, добавить обе dependency/configuration и запустить generators.
6. Визуально проверить splash, Android adaptive masks и iOS icon output.
7. Обновить ADR history, tests and goldens.
8. Выполнить scans, format, ASCII-path analysis, full tests, Android and iOS simulator builds.
9. Rollback восстанавливает только файлы этого change; реальные пользовательские данные и unrelated changes не затрагиваются.
