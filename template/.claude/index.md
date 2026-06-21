# .claude/index.md — {PROJECT_NAME} Documentation Map

Entry point for CC. Read this file first.
Load only the files needed for the current task.

---

## Data, methodology, and project state

| File | When to read |
| --- | --- |
| `.context/blueprint.md` | Before a task touching data, schema, preparation pipeline |
| `.context/methodology.md` | Before a new statistical test or model |
| `.context/findings.md` | Always at session start — what has been found and with what status |
| `.context/status.md` | When you need to understand what has been analysed |
| `.context/to-do.md` | When you need to understand what to do next |
| `.context/plan.md` | Before analysis — current task |
| `.context/decisions.md` | When you need to understand why a scope/method decision was made |
| `data/README.md` | Before working with data — where to get it, which version is current |

---

## Slash commands

Each file in `.claude/commands/` defines a CC slash command.

| Command | File | Description |
| --- | --- | --- |
| `/organize` | `commands/organize.md` | Organizer mode |
| `/architect` | `commands/architect.md` | Analytics Architect mode — plan |
| `/next` | `commands/next.md` | First incomplete task |
| `/record` | `commands/record.md` | Add decision |
| `/analyze` | `commands/analyze.md` | Analyst mode — implement |
| `/record-finding` | `commands/record-finding.md` | Record finding to findings.md |
| `/snapshot` | `commands/snapshot.md` | Update status.md |
| `/report` | `commands/report.md` | Generate analytical report |
| `/present` | `commands/present.md` | Generate presentation (jupyter / html) |
| `/commit` | `commands/commit.md` | Commit changes |
| `/close` | `commands/close.md` | Merge experiment/* into main |
| `/retro` | `commands/retro.md` | Retrospective |

---

## Meta-skills (workflow algorithms)

Read the corresponding skill when the owner triggers the command.

| File | Triggered by |
| --- | --- |
| `.claude/skills/meta/cc-status-report.md` | `/snapshot` |
| `.claude/skills/meta/cc-finding-sync.md` | `/sync` |
| `.claude/skills/meta/cc-record-finding.md` | `/record-finding` |
| `.claude/skills/meta/cc-report.md` | `/report` |
| `.claude/skills/meta/cc-present.md` | `/present` |
| `.claude/skills/meta/cc-commit.md` | `/commit` |
| `.claude/skills/meta/cc-close-task.md` | `/close` |
| `.claude/skills/meta/cc-retrospective.md` | `/retro` |

---

## Project skills (technical conventions)

Read the corresponding skill before implementing a new element.

| File | When to read |
| --- | --- |
| — | — |
