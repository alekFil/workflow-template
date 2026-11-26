---
name: retro
description: "Retrospective: analyze decisions, tasks and git history, write the result to .context/history/retros/ and propose actions. Use when the owner types /retro."
---

# Retrospective

## What it does

Analyzes project history: decisions, completed work, git commits.
Produces a structured retrospective discussion and proposes concrete actions.

Hybrid mode: CC builds the analysis, presents a draft, incorporates user corrections,
then writes the result and proposes new task cards and ADR candidates.

---

## Algorithm

### 1. Gather inputs

Read:

- `<DECISIONS_DIR>/README.md` and the ADR files it lists (`.claude/workflow.conf`) –
  decisions and rationale
- `.context/status.md` – current implementation snapshot
- `.context/history/retros/*.md` – previous retrospectives (for continuity across
  sessions)
- `.claude/scripts/workflow.sh tasks --all` – open and rejected task cards
- `.claude/scripts/workflow.sh done` – closed tasks
- `git log --oneline -50` – recent commit history

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

- New task cards
- ADR candidates – the owner records them with `/record`

### 3. Present draft

Output the structured analysis:

```text
## Ретроспектива – черновик

### Что шло хорошо
- ...

### Что было трудно
- ...

### Паттерны и наблюдения
- ...

### Предлагаемые действия
- задача: ...
- кандидат в ADR: ...
```

Then ask:

> Что добавить или изменить?

### 4. Incorporate feedback

Apply user corrections to the draft. If the user confirms without changes – proceed.

### 5. Write retrospective file

Create `.context/history/retros/YYYY-MM-DD.md` (use today's date):

```markdown
# Ретроспектива YYYY-MM-DD

## Что шло хорошо

## Что было трудно

## Паттерны и наблюдения

## Действия
```

Report: "Записано в `.context/history/retros/YYYY-MM-DD.md`"

### 6. Propose task cards

For each proposed action item – ask for confirmation separately, then create the
card as `.claude/skills/task/SKILL.md` describes:

```text
Новая задача:
- {action item}
Добавить? (да / пропустить)
```

### 7. List ADR candidates

If the retrospective surfaced learnings that may merit architectural decisions,
list them in the final reply with a short rationale. Do not write ADRs: the owner
records them with `/record` (`.claude/rules/adr-discipline.md`).

---

## Constraints

- Do not modify any files without explicit user confirmation
- Retrospective file name format: `.context/history/retros/YYYY-MM-DD.md` (no
  `retro-` prefix – the directory conveys the type)
- Each task card – confirmed individually, not in bulk
