# Spec Delta

## Purpose

Определяет пользовательские поверхности Surf Terminal для просмотра, создания и редактирования профилей SSH-подключений без выполнения реального подключения.

## ADDED Requirements

### Requirement: SSH page represents empty and populated states
SSH page SHALL показывать понятный empty state при отсутствии profiles и список профилей при наличии локальных presentation items. Она SHALL предоставлять заметное действие добавления профиля.

#### Scenario: Профилей нет
- **WHEN** SSH page открывается без профилей
- **THEN** пользователь видит объяснение и действие создания первого host

#### Scenario: Профили существуют
- **WHEN** SSH page открывается с профилями
- **THEN** каждый profile показывает безопасное display name, endpoint summary и доступные действия без отображения секретов

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
Пользователь SHALL иметь возможность открыть, редактировать и удалить presentation profile; destructive action MUST требовать подтверждения.

#### Scenario: Пользователь удаляет profile
- **WHEN** пользователь подтверждает удаление
- **THEN** profile исчезает из presentation list и при удалении последнего элемента отображается empty state
