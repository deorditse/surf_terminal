# Spec Delta

## ADDED Requirements

### Requirement: Project-local OpenSpec guidance matches the live repository
The project MUST use a project-local OpenSpec schema whose name, artifact instructions, templates, paths, technology assumptions, architecture vocabulary, security constraints, and verification commands match the live Surf Terminal Flutter/Dart repository. Copied schemas or guidance from another product MUST NOT become the active workflow until all foreign identifiers and incompatible assumptions are removed. Changing the default schema MUST NOT implicitly rewrite existing active changes.

#### Scenario: A schema is copied from another project
- **WHEN** a project-local schema contains foreign product names, nonexistent source paths, incompatible technologies, or unrelated quality commands
- **THEN** it is treated as invalid project guidance even if structural schema validation succeeds, and it is adapted before use for new Surf Terminal planning

#### Scenario: A new Surf Terminal change is created
- **WHEN** OpenSpec resolves the project's default schema
- **THEN** proposal, specs, design, and tasks instructions use Surf Terminal's current architecture, security, UI, testing, and approval conventions

#### Scenario: The default schema changes while another change is active
- **WHEN** `openspec/config.yaml` selects a new project-local schema
- **THEN** existing active changes retain their recorded schema and artifacts unless a separate approved migration explicitly changes them

### Requirement: Behavioral work records test-first verification
For every deterministic production behavior change, planning tasks MUST identify the focused automated test, record a RED execution that fails for the intended behavioral reason before production implementation, and record the corresponding GREEN execution after implementation. Bug fixes MUST retain the reproducing test as a regression test. Configuration, generated output, documentation-only work, and environment-gated runtime checks MAY use an explicitly justified non-RED verification path when a meaningful deterministic failing test is not possible.

#### Scenario: A deterministic behavior is added or changed
- **WHEN** tasks are prepared for production behavior that can be exercised automatically
- **THEN** the task sequence names the test scenario and command, requires observed RED before implementation, and requires GREEN plus relevant regression checks before completion

#### Scenario: A defect is fixed
- **WHEN** the change corrects reproducible incorrect behavior
- **THEN** an automated test demonstrates the defect before the fix and remains in the suite after the fix

#### Scenario: Verification requires a real device or external environment
- **WHEN** an acceptance criterion cannot be proven in the ordinary deterministic test harness
- **THEN** planning separates the automated gate from the device/environment smoke, states the prerequisite and expected evidence, and does not claim a skipped or unavailable smoke as passed behavior

## MODIFIED Requirements

### Requirement: Architecture instructions are authoritative
Проект MUST содержать корневой `AGENT.md`, который определяет обязательный OpenSpec workflow, архитектурные границы, утверждённый стек, правила безопасности, presentation direction и quality gates. Корневой `rules.md` MUST быть кратким операционным дополнением к `AGENT.md`, а не конкурирующим или скопированным контрактом; при расхождении `AGENT.md` и принятые ADR имеют приоритет. Project-local OpenSpec schema и templates MUST ссылаться на эти документы и MUST соответствовать canonical specs и актуальной структуре репозитория. Все новые изменения MUST соответствовать этому контекстному слою либо явно предлагать его изменение через OpenSpec.

#### Scenario: Добавляется новая фича
- **WHEN** проектируется или реализуется новая функциональность
- **THEN** её структура, зависимости, UI, security boundaries и verification соответствуют `AGENT.md`, `rules.md`, применимым ADR и canonical specs

#### Scenario: Требуется архитектурное исключение
- **WHEN** задача не может быть корректно реализована в установленных границах
- **THEN** исключение документируется и согласуется в OpenSpec до изменения реализации

#### Scenario: Контекстный файл скопирован из другого проекта
- **WHEN** `AGENT.md`, `rules.md` или OpenSpec template содержит чужой стек, product identifiers, пути или команды
- **THEN** такие инструкции не применяются к реализации и должны быть заменены проектно-специфичным контекстом через approval-gated OpenSpec change

#### Scenario: Контекстные источники противоречат друг другу
- **WHEN** краткое правило расходится с canonical spec, принятым ADR или авторитетным `AGENT.md`
- **THEN** работа останавливается для согласования и исправления контекстного слоя вместо выбора удобного варианта молча
