## Task: Добавить команду /retro (ретроспектива) в workflow-template

### Context

Новая bounded-операция (как /commit, /report) — не постоянный режим.
Читает все источники истории проекта, строит анализ, предъявляет черновик пользователю,
вносит правки, затем записывает discussion-файл и предлагает конкретные действия.

Не дублирует /sync: тот проверяет соответствие кода и документации,
/retro анализирует процесс и паттерны работы.

Depends on: —

### Что реализовать

1. Написать алгоритм скила `.claude/skills/meta/cc-retrospective.md`
2. Создать команду-триггер `.claude/commands/retro.md`
3. Скопировать оба файла в `template/`
4. Добавить `/retro` в таблицу команд `CLAUDE.md` (maintainer)
5. Добавить `/retro` в таблицу команд `template/CLAUDE.md`
6. Добавить `/retro` в `template/WORKFLOW.md` — таблица + "Typical workday"

### Files

Создать:
- `.claude/skills/meta/cc-retrospective.md`
- `.claude/commands/retro.md`
- `template/.claude/skills/meta/cc-retrospective.md`
- `template/.claude/commands/retro.md`

Редактировать:
- `CLAUDE.md` — строка `/retro` в таблице slash commands
- `template/CLAUDE.md` — строка `/retro` в таблице slash commands
- `template/WORKFLOW.md` — строка в таблице + пункт 7 в "Typical workday"

### Целевое содержимое: .claude/commands/retro.md

```text
Read `.claude/skills/meta/cc-retrospective.md` and execute the algorithm.
```

### Целевое содержимое: .claude/skills/meta/cc-retrospective.md

```markdown
# Skill: Retrospective

Triggered by: `/retro`

---

## What it does

Analyzes project history: decisions, completed work, git commits.
Produces a structured retrospective discussion and proposes concrete actions.

Hybrid: CC builds the analysis, presents a draft, incorporates user corrections,
then writes the result and proposes updates to to-do.md and decisions.md.

---

## Algorithm

### 1. Gather inputs

Read:
- `.context/decisions.md` — architectural decisions and rationale
- `.context/status.md` — current implementation snapshot
- `.context/history/*.md` — previous status snapshots (if any)
- `.context/to-do.md` — task queue: completed vs pending
- `git log --oneline -50` — recent commit history

### 2. Analyze across four dimensions

**What went well:**
- Decisions that held up (not revised or superseded)
- Tasks completed without blockers
- Patterns that reduced friction

**What was difficult:**
- Blocked or stalled tasks
- Decisions that were revisited or reversed
- Recurring uncertainty types

**Patterns and observations:**
- Themes across ADRs (what kinds of decisions keep coming up?)
- Ratio of planned vs unplanned work
- Scope drift signals

**Proposed actions:**
- Concrete items for to-do.md
- Learnings worth recording as ADRs

### 3. Present draft

Output structured analysis and ask:

> Что добавить или изменить?

### 4. Incorporate feedback

Apply user corrections. If the user confirms without changes — proceed.

### 5. Write discussion file

Create `.context/discussions/retro-YYYY-MM-DD.md` (use today's date):

```markdown
# Ретроспектива YYYY-MM-DD

## Что шло хорошо

## Что было трудно

## Паттерны и наблюдения

## Действия
```

Report: "Записано в `.context/discussions/retro-YYYY-MM-DD.md`"

### 6. Propose to-do updates

For each proposed action — ask for confirmation separately, then apply:

```text
Добавить в to-do.md:
- {action item}
Добавить? (да / пропустить)
```

### 7. Propose ADR entries

If retrospective surfaced learnings that merit architectural decisions,
propose each separately:

```text
Добавить ADR:
{title and brief rationale}
Добавить? (да / пропустить)
```

If confirmed — add directly to `.context/decisions.md`.
```

### Строка для таблицы команд (CLAUDE.md и template/CLAUDE.md)

```text
| `/retro` | Ретроспектива: анализ истории → discussion-файл → действия |
```

### Добавление в template/WORKFLOW.md

В таблицу команд добавить строку:
```text
| `/retro` | Analyze project history → write discussion → propose to-do and ADR updates |
```

В секцию "Typical workday" добавить пункт 7 после пункта 6:
```text
7. Periodically — retrospective
   → /retro
   CC reads decisions, history, git log — presents analysis draft
   You correct → CC writes .context/discussions/retro-YYYY-MM-DD.md
   Proposes to-do and ADR updates with per-item confirmation
```

### Constraints

- Скил не меняет файлы без подтверждения пользователя
- to-do.md и decisions.md — обновляются только после явного "да" по каждому пункту
- Команда `retro.md` — одна строка, как у всех остальных команд
- Файл ретроспективы — только в `.context/discussions/`, формат имени `retro-YYYY-MM-DD.md`
- `template/CLAUDE.md` содержит `{PLACEHOLDERS}` — не трогать их, только добавлять строку в таблицу

### Verification

```bash
# Файлы созданы
ls .claude/commands/retro.md .claude/skills/meta/cc-retrospective.md
ls template/.claude/commands/retro.md template/.claude/skills/meta/cc-retrospective.md

# Команды зарегистрированы
grep -n "retro" CLAUDE.md
grep -n "retro" template/CLAUDE.md
grep -n "retro" template/WORKFLOW.md

# Формат команды
cat .claude/commands/retro.md
# ожидаемый вывод: одна строка с путём к скилу

# Плейсхолдеры не тронуты
grep -n "PLACEHOLDERS" template/CLAUDE.md | wc -l
# должно быть столько же, сколько до изменений
```

### Changes along the way

(нет)
