# Spec Delta

## Purpose

Определяет пользовательские поверхности Surf Terminal для просмотра, создания и редактирования SSH profiles без предзаполненных demo connections и без утверждения о реальном transport.

## ADDED Requirements

### Requirement: SSH page starts empty and shows only user-created profiles
SSH page SHALL показывать empty state при отсутствии profiles и SHALL предоставлять заметное действие добавления первого profile. Production defaults MUST NOT содержать demo hosts, IP addresses, usernames или synthetic connection cards. Populated state SHALL содержать только profiles, созданные пользователем в текущем prototype workflow либо явно injected test data.

#### Scenario: Приложение запускается впервые
- **WHEN** SSH page открывается без созданных profiles
- **THEN** пользователь видит branded empty state и действие создания host без предзаполненных подключений

#### Scenario: Пользователь создал profile
- **WHEN** корректный profile сохранён через host editor
- **THEN** он появляется в SSH list с display name и endpoint summary без отображения секретов

#### Scenario: Проверяется production fixture source
- **WHEN** выполняется scan production source и default repositories
- **THEN** в них отсутствуют demo SSH profiles, fixture endpoints и screenshot-derived user data

### Requirement: Host editor validates connection fields locally
Host editor SHALL содержать поля display name, host, port, username, password, key selection, labels, startup snippet, locale option, jump host и proxy presentation settings. Host и username MUST быть обязательными, port MUST принимать только диапазон 1–65535, а ошибки MUST отображаться рядом с соответствующим полем.

#### Scenario: Обязательное поле пусто
- **WHEN** пользователь пытается сохранить форму без host или username
- **THEN** сохранение блокируется и соответствующее поле получает понятное validation message

#### Scenario: Порт некорректен
- **WHEN** port не является целым числом в диапазоне 1–65535
- **THEN** сохранение блокируется и пользователь видит требуемый диапазон

#### Scenario: Форма корректна
- **WHEN** обязательные значения валидны и пользователь сохраняет форму
- **THEN** profile появляется или обновляется в presentation list текущего запуска

### Requirement: Secrets are not exposed by the UI
Password и passphrase fields MUST быть obscured по умолчанию, MAY временно раскрываться явным действием пользователя и MUST NOT использовать реальные credentials из screenshots или fixtures.

#### Scenario: Пользователь вводит пароль
- **WHEN** password field не находится в режиме reveal
- **THEN** введённое значение визуально скрыто и отсутствует в других labels страницы

### Requirement: Profile actions are explicit
Пользователь SHALL иметь возможность открыть offline terminal preview, редактировать и удалить profile; destructive action MUST требовать подтверждения. До отдельной реализации transport UI MUST NOT сообщать об успешном сетевом SSH connection.

#### Scenario: Пользователь удаляет profile
- **WHEN** пользователь подтверждает удаление
- **THEN** profile исчезает из presentation list и при удалении последнего элемента отображается empty state

#### Scenario: Пользователь открывает profile
- **WHEN** пользователь выбирает созданный profile до реализации transport
- **THEN** terminal workspace явно обозначает offline preview и не показывает ложный connected state
