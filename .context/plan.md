# Задача: Перевод мейнтейнерского слоя на английский + реальные слэш-команды

## Контекст

ADR-016 зафиксировал: мейнтейнерский слой остаётся на русском. Решение пересматривается:
всё что читает CC переводится на английский, `.context/` остаётся на языке общения (русский).
Это согласует мейнтейнерский слой с шаблонным и устраняет языковую непоследовательность.

В той же задаче: создать `.claude/commands/` — реальные слэш-команды для мейнтейнерского слоя.

Зависит от: шаблонный слой (выполнено — `template/.claude/commands/` создан).

## Что реализовать

### 1. Зафиксировать ADR-018 в `.context/decisions.md`

Перевод мейнтейнерского слоя на английский: отменяет решение ADR-016 о сохранении русского.
`.context/` остаётся на языке общения.

### 2. Перевести мейнтейнерский слой на английский

- `CLAUDE.md` — полный перевод; добавить `**Language:** Respond in the user's language.`;
  таблицу «Ключевые фразы» заменить на «Slash commands»;
  в описаниях режимов заменить «Активируется фразой» → «Triggered by `/command`»
- `CONTRIBUTION.md` — полный перевод; заменить упоминания ключевых фраз на слэш-команды
- `.claude/index.md` — полный перевод; таблицу мета-скиллов обновить на слэш-команды
- `.claude/skills/meta/cc-commit.md` — полный перевод (уже есть английская версия в template/, адаптировать)
- `.claude/skills/meta/cc-close-task.md` — аналогично
- `.claude/skills/meta/cc-status-report.md` — аналогично
- `.claude/skills/meta/cc-architect-sync.md` — аналогично

### 3. Создать `.claude/commands/` с 9 файлами (на английском)

**Команды-режимы** (инлайн, адаптированные под мейнтейнерский контекст):

- `organize.md` — Organizer mode; файлы для редактирования специфичны для этого репо
- `architect.md` — Architect mode + формат `plan.md`; `$ARGUMENTS` = тема
- `dev.md` — Developer mode + главное правило

**Команды-утилиты** (инлайн):

- `next.md`
- `record.md`

**Команды-скиллы** (тонкие — идентичны шаблонным):

- `close.md`, `report.md`, `sync.md`, `commit.md`

### 4. Обновить `.claude/index.md`

Добавить раздел «Slash commands»; раздел «Meta-skills» обновить.

## Файлы

Создать:

- `.claude/commands/organize.md`
- `.claude/commands/architect.md`
- `.claude/commands/dev.md`
- `.claude/commands/next.md`
- `.claude/commands/record.md`
- `.claude/commands/close.md`
- `.claude/commands/report.md`
- `.claude/commands/sync.md`
- `.claude/commands/commit.md`

Обновить:

- `.context/decisions.md` — ADR-018
- `CLAUDE.md`
- `CONTRIBUTION.md`
- `.claude/index.md`
- `.claude/skills/meta/cc-commit.md`
- `.claude/skills/meta/cc-close-task.md`
- `.claude/skills/meta/cc-status-report.md`
- `.claude/skills/meta/cc-architect-sync.md`

Не трогать:

- `.context/` (blueprint, plan, to-do, status, decisions, history, discussions) — остаётся на русском

## Ограничения

- `.context/` — не переводить
- Шаблонный слой — не трогать
- Скиллы: перевести, опираясь на уже готовые английские версии в `template/.claude/skills/meta/`
- `organize.md` команда — адаптировать под файлы мейнтейнерского репо (не копировать из template/)

## Проверка

- `ls .claude/commands/` показывает 9 файлов
- В `CLAUDE.md` нет «Ключевые фразы», есть «Slash commands», есть `**Language:** Respond in the user's language.`
- В `.claude/skills/meta/*.md` нет «Реагирует на фразы»
- В `CONTRIBUTION.md` нет ключевых фраз в кавычках

## Изменения по ходу

(пусто)
