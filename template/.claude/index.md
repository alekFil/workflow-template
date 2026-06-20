# .claude/index.md — {PROJECT_NAME} Documentation Map

This file is the entry point for documentation. Read it first.
Load only the files needed for the current task.

---

## Architecture and project state

| File | When to read |
| --- | --- |
| `.context/blueprint.md` | Before a task touching architecture, components, or infrastructure |
| `.context/status.md` | When you need to understand what has been implemented |
| `.context/to-do.md` | When you need to understand what to do next |
| `.context/plan.md` | Before implementation — the current task |
| `.context/decisions.md` | When you need to understand why a decision was made |

---

## Slash commands

Each file in `.claude/commands/` defines a CC slash command invoked by the project owner.

| Command | File | Description |
| --- | --- | --- |
| `/organize` | `commands/organize.md` | Organizer mode |
| `/architect` | `commands/architect.md` | Architect mode — plan |
| `/next` | `commands/next.md` | First incomplete task |
| `/record` | `commands/record.md` | Add ADR |
| `/dev` | `commands/dev.md` | Developer mode — implement |
| `/commit` | `commands/commit.md` | Commit changes |
| `/close` | `commands/close.md` | Merge and close branch |
| `/report` | `commands/report.md` | Update status.md |
| `/sync` | `commands/sync.md` | Sync docs with code |

---

## Meta-skills (workflow algorithms)

Detailed algorithms backing the workflow commands. Read via the corresponding command file.

| File | Used by |
| --- | --- |
| `.claude/skills/meta/cc-status-report.md` | `/report` |
| `.claude/skills/meta/cc-architect-sync.md` | `/sync` |
| `.claude/skills/meta/cc-commit.md` | `/commit` |
| `.claude/skills/meta/cc-close-task.md` | `/close` |

---

## Project skills (technical conventions)

Read the corresponding skill before implementing a new element.

| File | When to read |
| --- | --- |
| — | — |
