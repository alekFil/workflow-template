# .claude/index.md — analytics-workflow-template Documentation Navigator

Entry point for CC when working with this repo. Read first.
Load only the files needed for the current task.

---

## Maintainer documentation

| File | When to read |
| --- | --- |
| `.context/blueprint.md` | Before a task touching template architecture |
| `.context/status.md` | When you need to understand what has been implemented |
| `.context/to-do.md` | When you need to understand what to do next |
| `.context/plan.md` | Before implementation — the current task |
| `.context/decisions.md` | When you need to understand why a decision was made |

---

## Template layer

| File/folder | Purpose |
| --- | --- |
| `template/CLAUDE.md` | CLAUDE.md for a new analytics project (with placeholders) |
| `template/WORKFLOW.md` | Workflow quick reference for a new analytics project |
| `template/.claude/` | Commands, skills, and navigator for a new analytics project |
| `template/.context/` | Documentation for a new analytics project (with placeholders) |
| `template/src/analysis_utils.py` | Reusable statistical functions (working code, not placeholder) |
| `scripts/install.sh` | curl template installation (analytics branch) |

---

## Slash commands

Each file in `.claude/commands/` defines a CC slash command.

| Command | File | Description |
| --- | --- | --- |
| `/organize` | `commands/organize.md` | Organizer mode |
| `/architect` | `commands/architect.md` | Architect mode — plan |
| `/next` | `commands/next.md` | First incomplete task |
| `/record` | `commands/record.md` | Add ADR |
| `/commit` | `commands/commit.md` | Commit changes |
| `/report` | `commands/report.md` | Update status.md |
| `/sync` | `commands/sync.md` | Sync docs with implementation |
| `/retro` | `commands/retro.md` | Retrospective |

---

## Meta-skills (workflow algorithms)

Detailed algorithms backing the workflow commands.
Note: analytics-specific skills (`cc-record-finding`, `cc-finding-sync`, `cc-report`, `cc-present`)
live only in `template/.claude/skills/meta/` — they are not needed at the maintainer level.

| File | Used by |
| --- | --- |
| `.claude/skills/meta/cc-status-report.md` | `/report` |
| `.claude/skills/meta/cc-architect-sync.md` | `/sync` |
| `.claude/skills/meta/cc-commit.md` | `/commit` |
| `.claude/skills/meta/cc-close-task.md` | `/close` (feature/* → dev, maintainer only) |
| `.claude/skills/meta/cc-retrospective.md` | `/retro` |
