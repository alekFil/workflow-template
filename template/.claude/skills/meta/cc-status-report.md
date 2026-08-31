# Skill: Project status report

Triggered by: `/report`, "what's done", "show status" and variations.

---

## What it does

Generates an up-to-date snapshot of the project implementation state.
Overwrites `.context/status.md`. No file archive — the previous version is preserved through git history, referenced from the new `status.md` via a pointer line.

---

## Algorithm

### 1. Capture the previous commit

Before overwriting `.context/status.md`, get the last commit that touched it:

```bash
git log -1 --format='%h %ai' -- .context/status.md
```

Take `<shortsha>` (first field) and the date portion of the timestamp (`YYYY-MM-DD`). This becomes the pointer inserted into the new `status.md` (step 4).

If the command returns nothing (first `/report`, no prior commit touched `status.md`) — skip the pointer line entirely.

### 2. Collect information

Go through the project and collect:

```markdown
## Implementation status {PROJECT_NAME}
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

Save the collected report to `.context/status.md`. First line after the title and `Date:` — the pointer captured in step 1:

```markdown
# {PROJECT_NAME} — status

Date: {YYYY-MM-DD hh:mm:ss}

> Previous state: commit {shortsha} ({YYYY-MM-DD})

---

## ...
```

If step 1 returned nothing (first `/report`), omit the pointer line.

Report the result:

```text
Status updated → .context/status.md
Previous version → git show {shortsha}:.context/status.md
```

---

## Constraints

- Facts only — do not infer what was "planned"
- Describe deviations from blueprint neutrally, with technical reason
- Formulate questions concretely, not abstractly
- Do not write code, do not make edits — only collect information
- Do not create files under `.context/history/` — status.md has no file archive by design. Prior snapshots live in git history only.
