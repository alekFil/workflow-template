# Skill: Retrospective

Triggered by: `/retro`

---

## What it does

Analyzes project history: decisions, completed work, git commits.
Produces a structured retrospective discussion and proposes concrete actions.

Hybrid mode: CC builds the analysis, presents a draft, incorporates user corrections,
then writes the result and proposes updates to `to-do.md` and `decisions.md`.

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

- Concrete items for `to-do.md`
- Learnings worth recording as ADRs

### 3. Present draft

Output the structured analysis:

```text
## Ретроспектива — черновик

### Что шло хорошо
- ...

### Что было трудно
- ...

### Паттерны и наблюдения
- ...

### Предлагаемые действия
- to-do: ...
- ADR: ...
```

Then ask:

> Что добавить или изменить?

### 4. Incorporate feedback

Apply user corrections to the draft. If the user confirms without changes — proceed.

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

For each proposed action item — ask for confirmation separately, then apply:

```text
Добавить в to-do.md:
- {action item}
Добавить? (да / пропустить)
```

### 7. Propose ADR entries

If the retrospective surfaced learnings that merit architectural decisions,
propose each separately:

```text
Добавить ADR:
{title and brief rationale}
Добавить? (да / пропустить)
```

If confirmed — add directly to `.context/decisions.md`.

---

## Constraints

- Do not modify any files without explicit user confirmation
- Discussion file name format: `retro-YYYY-MM-DD.md`
- Each to-do item and each ADR — confirmed individually, not in bulk
