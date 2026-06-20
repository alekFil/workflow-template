# Skill: Architecture sync

Triggered by: `/sync`, "sync documentation", "update blueprint" and variations.

---

## What it does

Compares the current implementation with the documentation.
Produces proposed changes — **without making edits independently**.
Edits are made only after explicit agreement with the developer.

---

## Algorithm

### 1. Read the current context

- `.context/blueprint.md` — current documentation
- `.context/status.md` — current implementation state
- `.context/to-do.md` — task queue
- `.claude/skills/project/*.md` — technical conventions (if directory exists)
- `CLAUDE.md` — entry file

If `.context/status.md` is missing or outdated — report:
> "No current status.md. First run: `/status`"

### 2. Analyze divergences

For each document find:

**blueprint.md:**

- Sections where the implementation differs from the description
- Architectural decisions made during implementation not recorded as ADRs
- Outdated parts (describe something that was abandoned)

**.context/to-do.md:**

- Tasks from "Next" that are already implemented per status.md — suggest moving to "Done"
- Tasks in "In progress" that are actually complete — suggest moving to "Done"

**.claude/skills/project/*.md** (if directory exists):

- Instructions that don't match the actual code (libraries, patterns, paths)
- New recurring patterns worth capturing as a skill
- Outdated instructions

**CLAUDE.md:**

- Project structure if it has changed
- Links to non-existent files

### 3. Produce proposals

Output concrete changes — not "needs updating", but exactly what to change:

```text
## Sync proposals

### .context/to-do.md
- Move to "Done": {task}
  Reason: implemented in {component/file}

### blueprint.md
- Section 3.5: replace "{old text}" with "{new text}"
  Reason: implementation uses X, not Y
- Add ADR-005: {title}
  Reason: decision Z was made but not recorded in documentation

### .claude/skills/project/new-git-check.md
- In step 2 replace path "checks/base.py" with "checks/_base.py"
  Reason: the actual file has a different name

### CLAUDE.md
- Update project structure: add backend/events/
```

### 4. Ask questions about uncertainties

From the "Questions and uncertainties" section in status.md, extract those
that require an architectural decision (not technical):

```text
## Questions for the architect

1. {specific question}
   Context: {why it arose, what was already tried}
```

### 5. Wait for agreement

After outputting proposals — stop.
Do not make edits independently.
Wait for explicit confirmation: "accepted", "apply" or clarifications per item.

### 6. After agreement — apply changes

When the developer has confirmed the list of changes:

- Apply changes to the specified files
- Report: "Done. Commit? (`/commit`)"

---

## Principles

**Blueprint reflects reality, not plans.**
If the implementation has intentionally diverged from the documentation — update the documentation.
If the divergence is accidental — record it and plan to fix the implementation.

**ADRs are never deleted.**
If a decision has changed — add a new ADR with a note "replaces ADR-XXX".

**Skills must match the actual code.**
A divergence between a skill and the implementation is always an error. One of them is wrong.
