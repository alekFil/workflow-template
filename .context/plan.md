# Задача: Реальные слэш-команды в шаблонном слое

## Контекст

Фазы А и Б OSS-публикации выполнены. В `template/CLAUDE.md` прописана таблица команд (`/architect`, `/dev` и др.),
но файлов команд нет. Claude Code распознаёт слэш-команды только если в `.claude/commands/` лежат `.md`-файлы.
Без них `/architect` — просто текст в таблице, не настоящая команда.

Зависит от: фаза Б (выполнена) — `template/CLAUDE.md` и скиллы переведены на английский.

## Что реализовать

### 1. Создать `template/.claude/commands/` с 9 файлами

**Команды-режимы** (содержат логику инлайн):

- `organize.md` — Organizer mode: что делать в режиме
- `architect.md` — Architect mode: что делать + формат `plan.md`; `$ARGUMENTS` = тема обсуждения
- `dev.md` — Developer mode: что делать + главное правило (два пути при встрече проблем вне скоупа)

**Команды-утилиты** (инлайн):

- `next.md` — переключить в Architect mode, предложить первый незавершённый пункт из `.context/to-do.md`
- `record.md` — добавить ADR в `.context/decisions.md`; содержит формат ADR

**Команды-скиллы** (тонкие: одна строка-ссылка на файл скилла):

- `close.md` → читать `.claude/skills/meta/cc-close-task.md` и выполнить
- `report.md` → читать `.claude/skills/meta/cc-status-report.md` и выполнить (переименовано с `/status`: конфликт со встроенной командой CC)
- `sync.md` → читать `.claude/skills/meta/cc-architect-sync.md` и выполнить
- `commit.md` → читать `.claude/skills/meta/cc-commit.md` и выполнить

### 2. Обновить `template/WORKFLOW.md`

- Добавить краткое объяснение в начало раздела «Modes and slash commands»: `/command` — реальная CC slash command, файл в `.claude/commands/`; вводится прямо в промпте CC
- Убрать колонку «Skill» из таблицы «Workflow commands» — оставить только команду и описание поведения (вариант В)
- Заменить `/status` на `/report` во всех таблицах и в разделе «Typical workday»

### 3. Обновить `template/CLAUDE.md`

Таблица «Slash commands»: убрать колонку-инструкцию «Read ... and execute» — оставить только описание.

### 4. Обновить `template/.claude/index.md`

Добавить раздел про `commands/`; скорректировать раздел Meta-skills (они теперь вызываются через command files, не напрямую).

### 5. Зафиксировать ADR-017 в `decisions.md`

Переименование `/status` → `/report`: конфликт со встроенной командой CC UI.

## Файлы

Создать:

- `template/.claude/commands/organize.md`
- `template/.claude/commands/architect.md`
- `template/.claude/commands/dev.md`
- `template/.claude/commands/next.md`
- `template/.claude/commands/record.md`
- `template/.claude/commands/close.md`
- `template/.claude/commands/report.md`
- `template/.claude/commands/sync.md`
- `template/.claude/commands/commit.md`

Обновить:

- `template/WORKFLOW.md` — объяснение команд, `/status` → `/report`, убрать колонку Skill
- `template/CLAUDE.md` — таблица Slash commands: `/status` → `/report`, упростить описания
- `template/.claude/index.md` — добавить раздел commands, скорректировать Meta-skills
- `.context/decisions.md` — добавить ADR-017

## Ограничения

- `{ПЛЕЙСХОЛДЕРЫ}` в `template/` — не трогать
- Мейнтейнерский слой — не трогать
- Команды-скиллы — только тонкая ссылка, не копировать алгоритм внутрь
- Не дублировать логику между `commands/` и `CLAUDE.md`; CLAUDE.md — ссылочный документ, детали — в command files

## Проверка

- `ls template/.claude/commands/` показывает 9 файлов (без `status.md`)
- В `template/.claude/commands/architect.md` присутствует `$ARGUMENTS`
- В `template/CLAUDE.md` нет `/status` и нет «Read ... and execute»
- В `template/WORKFLOW.md` нет `/status`, есть `/report` и объяснение что команды — реальные CC slash commands

## Изменения по ходу

(пусто)
