# Spec Delta

## Purpose

Определяет интерфейс Surf Terminal для локального представления, создания и редактирования повторно используемых командных snippets.

## ADDED Requirements

### Requirement: Snippets page supports empty and populated states
Snippets page SHALL показывать empty state с действием добавления и SHALL показывать searchable list после создания presentation snippets.

#### Scenario: Snippets отсутствуют
- **WHEN** страница открывается без snippets
- **THEN** пользователь видит объяснение и заметное действие добавления

#### Scenario: Пользователь ищет snippet
- **WHEN** пользователь вводит query
- **THEN** список фильтруется по title, command и labels без изменения исходных items

### Requirement: Snippet editor validates reusable commands
Snippet editor SHALL содержать title, command, optional description и labels. Title и command MUST быть обязательными, а validation messages MUST отображаться до сохранения некорректной формы.

#### Scenario: Command отсутствует
- **WHEN** пользователь пытается сохранить snippet без command
- **THEN** сохранение блокируется и command field получает validation message

#### Scenario: Snippet валиден
- **WHEN** title и command заполнены
- **THEN** snippet создаётся или обновляется в presentation list текущего запуска

### Requirement: Snippet actions protect against accidental deletion
Пользователь SHALL иметь возможность просмотреть, редактировать, копировать и удалить presentation snippet, а удаление MUST требовать подтверждения.

#### Scenario: Команда копируется
- **WHEN** пользователь выбирает copy action
- **THEN** command помещается в clipboard и UI показывает доступное подтверждение без раскрытия иных данных
