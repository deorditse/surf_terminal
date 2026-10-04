# Spec Delta

## MODIFIED Requirements

### Requirement: SSH page starts empty and shows only user-created profiles
SSH page SHALL показывать dark surfer-style empty state при отсутствии profiles и SHALL предоставлять ровно одно действие создания profile — `Add host` в AppBar. Connections MUST NOT содержать connection `FloatingActionButton` или вторую create-кнопку в empty state. Surfer decoration SHALL быть ограничена management surface и MUST NOT возвращать preview/offline presentation copy. Production defaults MUST NOT содержать demo hosts, IP addresses, usernames или synthetic connection cards. Populated state SHALL содержать только durably stored profiles, созданные пользователем, либо явно injected test data.

#### Scenario: Приложение запускается впервые
- **WHEN** SSH page открывается без созданных profiles
- **THEN** пользователь видит dark surfer-style empty state без предзаполненных подключений и может создать host только через `Add host` в AppBar

#### Scenario: Проверяются действия создания host
- **WHEN** SSH page отображает empty или populated state
- **THEN** существует ровно одно действие перехода к new-host editor в AppBar, а connection FAB и empty-state create button отсутствуют

#### Scenario: Stateful shell выполняет route transition
- **WHEN** Connections и другие navigation branches остаются mounted во время перехода
- **THEN** в route subtree отсутствуют конфликтующие default `FloatingActionButton` Hero tags

#### Scenario: Пользователь создал profile
- **WHEN** корректный profile сохранён через host editor независимо от результата connection attempt
- **THEN** он появляется в SSH list с display name и endpoint summary без отображения секретов

#### Scenario: Проверяется production fixture source
- **WHEN** выполняется scan production source и default repositories
- **THEN** в них отсутствуют demo SSH profiles, fixture endpoints и screenshot-derived user data

### Requirement: Host editor validates connection fields locally
Host editor SHALL содержать поля display name, host, port, username, password, key selection, labels, startup snippet, locale option, jump host и proxy presentation settings. Host и username MUST быть обязательными, port MUST принимать только диапазон 1–65535, а ошибки MUST отображаться рядом с соответствующим полем. Primary action нового profile SHALL называться `Connect`, а существующего profile — `Save`.

#### Scenario: Обязательное поле пусто
- **WHEN** пользователь пытается подключить или сохранить форму без host или username
- **THEN** действие блокируется и соответствующее поле получает понятное validation message

#### Scenario: Порт некорректен
- **WHEN** port не является целым числом в диапазоне 1–65535
- **THEN** действие блокируется и пользователь видит требуемый диапазон

#### Scenario: Форма корректна
- **WHEN** обязательные значения нового profile валидны и пользователь нажимает `Connect`
- **THEN** real SSH connection workflow запускается без ожидания profile persistence, а profile сохраняется независимо от результата connection attempt

#### Scenario: Существующий profile корректен
- **WHEN** пользователь сохраняет валидные изменения из `Edit host`
- **THEN** тот же profile обновляется и пользователь возвращается к SSH list без запуска новой сессии

### Requirement: Profile actions are explicit
Пользователь SHALL иметь возможность начать реальное SSH-подключение primary tap по profile, редактировать и удалить profile; destructive action MUST требовать подтверждения. UI MUST показывать фактический SSH lifecycle и MUST NOT заявлять `connected` до успешной host-key verification, authentication и открытия remote shell. Новое подключение MUST заменить предыдущую активную session.

#### Scenario: Пользователь удаляет profile
- **WHEN** пользователь подтверждает удаление
- **THEN** profile исчезает из SSH list и при удалении последнего элемента отображается empty state

#### Scenario: Пользователь открывает profile
- **WHEN** пользователь выбирает сохранённый profile
- **THEN** предыдущая active session закрывается и открывается full-screen terminal workspace с видимым progress реального SSH-подключения

#### Scenario: Пользователь редактирует profile
- **WHEN** пользователь выбирает отдельное действие `Edit`
- **THEN** открывается `Edit host` с non-secret полями profile и без раскрытия сохранённого password
