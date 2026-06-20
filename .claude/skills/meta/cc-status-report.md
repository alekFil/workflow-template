# Skill: Project status report

Triggered by: `/report`

---

## What it does

Generates an up-to-date snapshot of the project implementation state.
Archives the previous version. Saves the new one.

---

## Algorithm

### 1. Archive the previous status.md

If `.context/status.md` exists:

- Determine the next sequential number: find all files `.context/history/*-status-*.md`, take the maximum number and increment. If no files exist — start with `001`.
- Copy `.context/status.md` → `.context/history/{N}-status-{timestamp}.md`
  - N — three-digit number with leading zeros: `001`, `002`, `003`...
  - timestamp — format `YYYY-MM-DD`
  - Example: `.context/history/003-status-2025-08-14.md`

### 2. Collect information

Go through the project and collect:

```markdown
## Implementation status workflow-template
Date: {YYYY-MM-DD hh:mm:ss}

### What's implemented
For each implemented component:
- `path/to/file` — one line: what it does
- Deviations from blueprint.md (if any and why)

### Project structure
{tree of real files, without __pycache__, .venv, .git, node_modules}

### Key technical decisions
Decisions made during implementation that are not reflected
in blueprint.md or differ from it.

### Dependencies between components
What depends on what — implemented components only.

### What's not implemented from planned
- {component}: {reason — not started / blocked / decision changed}

### Questions and uncertainties
Places where there was ambiguity and how it was resolved.
Places where ambiguity remains.
```

### 3. Update .context/to-do.md

Cross-reference the collected information with `.context/to-do.md`:

- Tasks from "Next" that are already implemented — mark `[x]` and move to "Done"
- Tasks in "In progress" that are actually complete — mark `[x]` and move to "Done"

### 4. Write .context/status.md

Save the collected report to `.context/status.md`.

Report the result:

```text
Status updated.
Previous version → .context/history/{N}-status-{date}.md
Current version → .context/status.md
```

---

## Constraints

- Facts only — do not infer what was "planned"
- Describe deviations from blueprint neutrally, with technical reason
- Formulate questions concretely, not abstractly
- Do not write code, do not make edits — only collect information

---

## Working with the history archive

`.context/history/` **is not read by default** — it is excluded from context via `.claudeignore`.

Read the archive only on explicit request from the owner:

- "what were we doing in early May"
- "check the status archive"
- "what happened before X"

For all regular work, these are sufficient:

- `.context/status.md` — current state
- `.context/decisions.md` — recorded decisions
- `.context/to-do.md` — task queue
