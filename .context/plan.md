## Task: Перенести скилл /brainstorm в аналитический шаблон (адаптированная версия)

### Context

На ветке `main` (через `feature/brainstorm-skill`) уже реализован скилл `/brainstorm` для
software-проектов. Ветка `analytics` — постоянный параллельный шаблон для аналитических проектов
(notebooks, findings, methodology). Скилл нужно перенести сюда, адаптировав под аналитический
контекст: другие плейсхолдеры, другие файлы для заполнения, ориентация на данные а не компоненты.

Зависит от: —

### What to implement

1. Создать `template/.context/methodology.md` — шаблонный файл статистической методологии
2. Создать `template/.claude/skills/meta/cc-brainstorm.md` — аналитическая адаптация скилла
3. Создать `.claude/skills/meta/cc-brainstorm.md` — копия скилла для maintainer-слоя
4. Создать `template/.claude/commands/brainstorm.md` — файл команды (идентичен main)
5. Создать `.claude/commands/brainstorm.md` — файл команды для maintainer-слоя
6. Добавить раздел Brainstorm mode в `template/CLAUDE.md` — первым в "Your roles"
7. Добавить `/brainstorm` и `/brainstorm done` в таблицу команд `template/CLAUDE.md`
8. Добавить `/brainstorm` и `/brainstorm done` в таблицу команд `CLAUDE.md` (maintainer)

### Files

Create:

- `template/.context/methodology.md`
- `template/.claude/skills/meta/cc-brainstorm.md`
- `.claude/skills/meta/cc-brainstorm.md`
- `template/.claude/commands/brainstorm.md`
- `.claude/commands/brainstorm.md`

Edit:

- `template/CLAUDE.md` — добавить Brainstorm mode первым в "Your roles" + две строки в таблицу команд
- `CLAUDE.md` — добавить две строки в таблицу команд

### Skill algorithm: аналитические отличия от main-версии

#### Параметры `/brainstorm done` — Parameter sweep

_Заполняются сейчас_ (из сессии или через вопросы):

| Плейсхолдер | Откуда |
| --- | --- |
| `{PROJECT_DESCRIPTION}` | из брейншторма |
| `{DATA_SOURCE_1}` + description + volume | из брейншторма, если обсудили |
| `{COMMUNICATION_LANGUAGE}` / `{CONTEXT_LANGUAGE}` / `{CODE_COMMENTS_LANGUAGE}` | спросить |
| `{CODE_CONVENTIONS}` | спросить |
| `{ANALYSIS_RULES}` | спросить или вывести из брейншторма |
| `{RUNTIME_SETUP}` | спросить |
| `{REPO_URL}` | взять из `git remote get-url origin`, если есть |

_Заполняются позже_ (пропустить):

`{PROJECT_NAME}` (уже заполнен `install.sh`), `{PROJECT_STRUCTURE}`, `{PHASE_NAME}`, `{N}`,
`{FIRST_DECISION_TITLE}`, `{FIRST_KEY_DECISION}`, `{DECISION_KEY}`

#### Файлы для заполнения в `/brainstorm done`

- `CLAUDE.md` — аналитические плейсхолдеры (описание проекта, языки, источники данных, правила)
- `.context/blueprint.md` — фокус на данных: источники, pipeline, ключевые поля
- `.context/methodology.md` — статистические конвенции, полученные из брейншторма
- `.context/to-do.md` — если появились аналитические направления/гипотезы
- `.context/status.md` — если есть начальное состояние проекта
- `.claude/index.md` — если есть `{PROJECT_DESCRIPTION}`
- NOT `findings.md` — только для реальных находок, не для брейншторма

#### Завершение сессии

```text
Сессия завершена.
Сохранено: .context/discussions/brainstorm-YYYYMMDD-{slug}.md
Обновлено: CLAUDE.md, .context/blueprint.md, .context/methodology.md, [другие если были]

Следующий шаг: /architect — проработать методологию и данные на основе инсайтов.
```

### template/.context/methodology.md — структура шаблона

```markdown
# {PROJECT_NAME} — Methodology

> Statistical conventions and model standards for this project.
> Updated via `/record` when methodology decisions are made.

---

## Statistical approach

{STATISTICAL_APPROACH}

## Key assumptions

- {ASSUMPTION_1}
- {ASSUMPTION_2}

## Validation standards

{VALIDATION_STANDARDS}

## Model standards

| Criterion | Standard |
| --- | --- |
| Significance threshold | {SIGNIFICANCE_THRESHOLD} |
| Minimum sample size | {MIN_SAMPLE_SIZE} |

## Known data caveats

{DATA_CAVEATS}
```

### Constraints

- `template/CLAUDE.md` корень: добавить только новый раздел mode и строки в таблице — структуру не менять
- `CLAUDE.md` (maintainer): добавить только строки в таблице команд
- Скилл не создаёт code-файлы (`.py`, `.ipynb` и т.д.) ни при каких обстоятельствах
- При заполнении `methodology.md` — только плейсхолдеры заменять, секции не удалять
- Если `blueprint.md` содержит software-плейсхолдеры (`{COMPONENT_1}` и т.д.) — адаптировать их в аналитический контекст при заполнении (источники данных, pipeline-этапы)

### Verification

```bash
# Скилл присутствует в обоих слоях
ls template/.claude/skills/meta/cc-brainstorm.md
ls .claude/skills/meta/cc-brainstorm.md

# Команда присутствует в обоих слоях
ls template/.claude/commands/brainstorm.md
ls .claude/commands/brainstorm.md

# Шаблон methodology.md создан
ls template/.context/methodology.md

# Команды добавлены в оба CLAUDE.md
grep "brainstorm" template/CLAUDE.md
grep "brainstorm" CLAUDE.md

# Brainstorm mode — первый в "Your roles"
grep -n "Brainstorm\|Organizer\|Architect\|Analyst" template/CLAUDE.md | head -10
```

### Changes along the way

(нет)
