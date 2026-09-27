# Spec Delta

## Purpose

Определяет базовую мобильную файловую поверхность SFTP Surf Terminal и её presentation-состояния до подключения реального transport.

## ADDED Requirements

### Requirement: SFTP page exposes connection and browser states
SFTP page SHALL иметь empty, loading, data и error presentation states и SHALL позволять переключать их через безопасные локальные fixtures для проверки интерфейса.

#### Scenario: SFTP profile не выбран
- **WHEN** пользователь открывает SFTP без выбранного host
- **THEN** отображается empty state с действием выбора или создания host

#### Scenario: Fixture содержит файлы
- **WHEN** активировано data state
- **THEN** отображаются текущий path, переход к родительскому каталогу и строки folders/files с именем, типом и безопасными metadata

#### Scenario: Fixture сообщает ошибку
- **WHEN** активировано error state
- **THEN** отображается понятное сообщение и действие retry без утверждения о реальном сетевом запросе

### Requirement: File browser interactions are presentation-only
Навигация по fixture directories, selection и context actions SHALL быть интерактивными, но MUST NOT читать, загружать, скачивать, удалять или изменять реальные удалённые файлы.

#### Scenario: Пользователь открывает fixture folder
- **WHEN** пользователь выбирает folder row
- **THEN** path и fixture listing обновляются локально

#### Scenario: Пользователь выбирает file action
- **WHEN** пользователь открывает context actions для fixture file
- **THEN** UI показывает доступные будущие actions как disabled или preview controls без внешнего side effect
