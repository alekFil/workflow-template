# Задача: Разделить мейнтейнерский и шаблонный слои

## Контекст

Реализация ADR-001 (два слоя в одном репо) и ADR-002 (перенос index.md в .claude/).
Зависит от: —

## Что реализовать

### 1. Создать структуру template/

- Создать `template/CLAUDE.md` — переместить содержимое `CLAUDE.template.md`
- Создать `template/WORKFLOW.md` — шпаргалка для нового проекта (с плейсхолдерами)
- Создать `template/.claude/index.md` — навигатор CC (с плейсхолдерами, ссылки на шаблонные docs/)
- Создать `template/.claude/skills/meta/` — скопировать все скиллы из `.claude/skills/meta/`
- Создать `template/docs/` — скопировать все файлы документации (blueprint, plan, to-do, status, decisions) с плейсхолдерами

### 2. Перенести docs/index.md → .claude/index.md (мейнтейнерская версия)

- Адаптировать под реальную структуру этого репо (убрать плейсхолдеры, обновить пути)

### 3. Наполнить мейнтейнерскую документацию реальным содержимым

- `docs/blueprint.md` — описание системы шаблона: что это, компоненты, как работает развёртывание
- `docs/status.md` — актуальный срез: что реализовано, структура, что не реализовано
- `docs/to-do.md` — реальный список задач по развитию шаблона
- `docs/plan.md` — этот файл, заменить плейсхолдеры (уже сделано)

### 4. Создать CONTRIBUTION.md

- Описать как работать с этим репо: роли CC, конвенции, как синхронизировать улучшения из рабочих проектов

### 5. Создать scripts/init-project.sh (заглушка)

- Файл с TODO-комментарием, скоуп определяется отдельной задачей

### 6. Обновить CLAUDE.md

- Заменить упоминание `docs/index.md` → `.claude/index.md`
- Заменить `WORKFLOW.md` → `CONTRIBUTION.md` в разделе структуры
- Убрать `CLAUDE.template.md` из структуры

### 7. Удалить устаревшие файлы

- `CLAUDE.template.md` — заменён на `template/CLAUDE.md`
- `WORKFLOW.md` (корневой) — переехал в `template/WORKFLOW.md`
- `docs/index.md` — переехал в `.claude/index.md`

## Файлы

Создать:
- `template/CLAUDE.md`
- `template/WORKFLOW.md`
- `template/.claude/index.md`
- `template/.claude/skills/meta/cc-commit.md`
- `template/.claude/skills/meta/cc-close-task.md`
- `template/.claude/skills/meta/cc-status-report.md`
- `template/.claude/skills/meta/cc-architect-sync.md`
- `template/.claude/skills/meta/cc-export-chat.md`
- `template/docs/blueprint.md`
- `template/docs/plan.md`
- `template/docs/to-do.md`
- `template/docs/status.md`
- `template/docs/decisions.md`
- `template/docs/history/.gitkeep`
- `template/docs/discussions/.gitkeep`
- `CONTRIBUTION.md`
- `scripts/init-project.sh`
- `.claude/index.md`

Изменить:
- `CLAUDE.md` — обновить пути и структуру
- `docs/blueprint.md` — наполнить реальным содержимым
- `docs/status.md` — наполнить реальным содержимым
- `docs/to-do.md` — наполнить реальным содержимым

Удалить:
- `CLAUDE.template.md`
- `WORKFLOW.md`
- `docs/index.md`

## Ограничения

- Все `{ПЛЕЙСХОЛДЕРЫ}` в `template/` сохраняются — не заполнять реальными данными
- `scripts/init-project.sh` — только заглушка, не реализовывать логику
- Не трогать `docs/decisions.md` — уже содержит реальные ADR

## Проверка

- В корне нет `CLAUDE.template.md`, `WORKFLOW.md`, `docs/index.md`
- `template/` содержит полноценную структуру нового проекта с плейсхолдерами
- `.claude/index.md` отражает реальную структуру мейнтейнера
- Все мейнтейнерские `docs/*.md` заполнены (без плейсхолдеров)

## Изменения по ходу

- (заполняется в ходе реализации)
