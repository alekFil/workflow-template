---
name: report
description: "Write a fresh implementation status snapshot to .context/status.md. Use when the owner asks what is done, asks for the project status, or types /report."
---

# Project status report

Generates an up-to-date snapshot of the implementation state and overwrites
`.context/status.md`. The file is derived state: it is not committed
(`.gitignore`) and any version can be regenerated (`.claude/rules/artifacts.md`).

Settings – `.claude/workflow.conf`. The code to describe is in `CODE_DIR`.

## Algorithm

### 1. Collect information

Go through the code repository and collect:

```markdown
# {PROJECT_NAME} – status

Date: {YYYY-MM-DD hh:mm:ss}

## What's implemented
For each implemented component:
- `path/to/file` – one line: what it does
- Deviations from blueprint.md (if any and why)

## Project structure
{tree of real files of the code repository, without __pycache__, .venv, .git,
node_modules}

## Key technical decisions
Decisions made during implementation that are not reflected in blueprint.md or
differ from it.

## Dependencies between components
What depends on what – implemented components only.

## Tasks
Open cards: output of `.claude/scripts/workflow.sh tasks`.
Recently closed: last 10 lines of `.claude/scripts/workflow.sh done`.

## Questions and uncertainties
Places where there was ambiguity and how it was resolved.
Places where ambiguity remains.
```

### 2. Cross-check task cards

For each open card whose work is already in the code – list it under "Questions and
uncertainties": "Card `<slug>` looks done – close it with `/close` or update it".
Do not edit or delete cards here.

### 3. Write `.context/status.md`

Overwrite the file and report:

```text
Status updated → .context/status.md
```

## Constraints

- Facts only – do not infer what was "planned"
- Describe deviations from blueprint neutrally, with technical reason
- Formulate questions concretely, not abstractly
- Do not write code and do not edit other files – only collect information
