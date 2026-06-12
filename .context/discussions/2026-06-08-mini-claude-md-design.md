# Проект: template-mini/CLAUDE.md

**Дата:** 2026-06-08
**Статус:** драфт готов

---

## Цель

Один файл CLAUDE.md (~70 строк), который:

- Копируется в любой проект за 30 секунд
- Даёт немедленную ценность без изучения системы
- Содержит ядро идеи: разделение фаз Architect / Developer

---

## Что входит

| Блок | Строк | Содержимое |
|---|---|---|
| Контекст проекта | 5 | Плейсхолдеры: название, стек, цель |
| Режимы | 20 | Architect + Developer: описание, что делает, что не делает |
| Ключевые фразы | 10 | Таблица триггеров |
| Инлайн-скиллы | 10 | Commit (4 строки), status (3 строки) |
| Конвенции | 10 | Git, Markdown (кратко) |
| Контекст | 5 | Предупреждение при >60% и >80% |

Итого ~60 строк.

---

## Что вырезается относительно full

- `cc-export-chat` — нишевый
- `cc-architect-sync` — сложный, только для регулярных пользователей
- `.claude/index.md` — навигатор нужен только при большой структуре
- Папки `history/` и `discussions/` — не упоминать
- `WORKFLOW.md` — шпаргалка не нужна если CLAUDE.md читаем
- `decisions.md` — не упоминать в структуре (фраза `record decision` остаётся)

---

## Решения

1. **Язык** — английский (mini для сообщества)
2. **Триггеры** — фразы оставить как есть; slash-команды — отдельная задача позже
3. **Docs** — упоминать только `plan.md`

---

## Финальный драфт файла

```markdown
# {PROJECT_NAME} — CLAUDE.md

{One-line description of the project}
Stack: {stack}

---

## Modes

### Architect mode

Activated by: **"discuss"** or **"let's discuss"**

In this mode you:

- Ask clarifying questions before proposing a solution
- Write the plan to `.context/plan.md`
- Do NOT write code or edit project files

### Developer mode

Activated by: **"start implementation"**

In this mode you:

- Read `.context/plan.md` and implement it
- Stay within the plan's scope

---

## Key phrases

| Phrase | Action |
|---|---|
| `discuss` / `let's discuss` | Architect mode |
| `what's next` | First incomplete item from .context/plan.md |
| `start implementation` | Read .context/plan.md and implement |
| `record decision` | Append ADR to docs/decisions.md |
| `commit` | See skill below |
| `status` | Brief summary: done, in progress, blockers |

---

## Skills

### commit

1. Run `git status` and `git diff`
2. Stage relevant files by name (not `git add .`)
3. Write a concise message focused on *why*, not what
4. Commit — never push without explicit request

---

## Conventions

### Git

- Branches: `main` / `dev` / `feature/<name>`
- Never push without explicit request

### Markdown

- List markers: `-` only
- Always specify code block language
- Empty line before and after headings

---

## Context management

After each mode or skill — check context level (`/context`).

- **> 60%** — warn: mention level, suggest wrapping up soon
- **> 80%** — strongly recommend finishing after current action
```

---

## Следующий шаг

Реализовать: создать `template-mini/CLAUDE.md` и `scripts/install-mini.sh`,
обновить `SETUP.md` и `.context/plan.md`.
