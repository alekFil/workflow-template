---
name: commit
description: "Commit changes: show the diff, wait for confirmation, split by type, add the task trailer. Only on the owner's explicit /commit."
disable-model-invocation: true
---

# Commit changes

Settings – `.claude/workflow.conf`, current task – `.claude/rules/artifacts.md`.

## Two repositories

- **Code repository** – `CODE_DIR`.
- **Context repository** – the root, where `.claude/` lives.

With `CODE_DIR=.` they are the same repository. In devmeta profiles (`CODE_DIR=code`)
commit each one separately: `git -C code ...` for code, `git ...` for context. Never
add workflow files (`CLAUDE.md`, `.claude/`, `.context/`, `docs/` of the context
repository) to the code repository.

## Algorithm

### 1. Make sure the task card is up to date

All changes outside the plan scope are documented in `### Changes along the way` of
the current card. If that section is empty – the implementation matches the plan.

### 2. Check there is something to commit

Run `git status` in each repository. If both are clean – report: "Nothing to
commit, working directory is clean."

### 3. Show the list of changes and ask for confirmation

```text
Will commit (code):
  A  src/model/trainer.py
Will commit (context):
  M  .context/tasks/add-trainer.md

Confirm or clarify what to include.
```

With one repository – one list. Wait for explicit confirmation.

### 4. Determine commit type and order

| Prefix | When to use |
| --- | --- |
| `feat:` | new functional code |
| `fix:` | bug fix |
| `docs:` | documentation only |
| `refactor:` | refactoring without behavior change |
| `test:` | adding or changing tests |
| `chore:` | infrastructure, configuration, dependencies |

If changes are mixed – split into multiple commits. The task card goes first
(`docs: plan <slug>`), then the implementation.

In a contribution profile the code repository follows the upstream commit
conventions (`CONTRIBUTING`, recent `git log`) instead of this table.

### 5. Task trailer

With `CODE_DIR=.` every implementation commit carries the trailer `Task: <slug>`:

```text
feat: short description of what was done

Why: one or two sentences, when the reason is not obvious.

Task: add-trainer
```

In devmeta profiles code commits carry no workflow trailers: the public history
stays clean.

**`Why:` section** – for fixes and non-obvious changes: the constraint, incident or
trade-off behind the choice. This is where operational context lives; most tactical
decisions do not belong in ADRs (`.claude/rules/adr-discipline.md`). Skip it for
cosmetic changes.

### 6. Execute and report

```text
Committed: {commit message}
```

## Intermediate commits

After creating or modifying files within a task, offer:

> Created/updated `<path>`. Commit now or group at the end of the task?

- **"now"** – commit immediately
- **"group"** or silence – accumulate, commit in the final commit

## Constraints

- Do not `git push` unless the branch rules allow it (`.claude/rules/branching.md`)
- Always wait for confirmation before committing
