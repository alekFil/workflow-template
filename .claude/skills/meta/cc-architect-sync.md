# Skill: Architecture sync

Triggered by: `/sync`

---

## What it does

Compares the current implementation with the documentation.
Produces proposed changes — **without making edits independently**.
Edits are made only after explicit agreement with the owner.

---

## Algorithm

### 1. Read the current context

- `.context/blueprint.md` — current documentation
- `.context/status.md` — current implementation state
- `.context/to-do.md` — task queue
- `CLAUDE.md` — entry file

If `.context/status.md` is missing or outdated — report:
> "No current status.md. First run: `/report`"

### 2. Analyze divergences

For each document find:

**blueprint.md:**

- Sections where the implementation differs from the description
- Architectural decisions made during implementation not recorded as ADRs
- Outdated parts (describe something that was abandoned)

**.context/to-do.md:**

- Tasks from "Next" that are already implemented per status.md — suggest moving to "Done"
- Tasks in "In progress" that are actually complete — suggest moving to "Done"

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

### CLAUDE.md
- Update repo structure: add .claude/commands/
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

When the owner has confirmed the list of changes:

- Apply changes to the specified files
- Report: "Done. Commit? (`/commit`)"

---

## Principles

**Blueprint reflects reality, not plans.**
If the implementation has intentionally diverged from the documentation — update the documentation.
If the divergence is accidental — record it and plan to fix the implementation.

**ADRs are never deleted.**
If a decision has changed — add a new ADR with a note "replaces ADR-XXX".
