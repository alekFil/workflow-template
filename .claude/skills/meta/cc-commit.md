# Skill: Commit changes

Triggered by: `/commit`, "commit", "make a commit" and variations.

---

## Algorithm

### 1. Make sure plan.md is up to date

Check: all changes outside the plan scope are documented in `### Changes along the way` in `.context/plan.md`.
If that section is absent — the implementation matches the plan exactly.

### 2. Check there is something to commit

```bash
git status
```

If the working directory is clean — report: "Nothing to commit, working directory is clean."

### 3. Show the list of changes and ask for confirmation

```bash
git diff --stat
```

```text
Will commit:
  M  .context/blueprint.md
  A  src/model/trainer.py

Confirm or clarify what to include.
```

Wait for explicit confirmation before proceeding.

### 4. Determine commit type and order

| Prefix | When to use |
| --- | --- |
| `feat:` | new functional code |
| `fix:` | bug fix |
| `docs:` | documentation only |
| `refactor:` | refactoring without behavior change |
| `test:` | adding or changing tests |
| `chore:` | infrastructure, configuration, dependencies |

If changes are mixed — split into multiple commits.

**Commit order when closing a task:**

1. First `.context/plan.md` (if changed)
2. Then all implementation commits

**Task reference in commits:**
Each implementation commit (of any type) must contain a reference to the task from the plan.
Format — second line of the message:

```text
feat: short description of what was done

Implements: .context/plan.md — "{task name from ## Task:}"
```

### 5. Execute the commit

```bash
git add {agreed files}
git commit -m "{prefix}: {what was done, one line, present tense}

Implements: .context/plan.md — \"{task name}\""
```

### 6. Report the result

```text
Committed: {commit message}
```

---

## Intermediate commits

After creating or modifying files within a task, offer:

> Created/updated `<path>`. Commit now or group at the end of the task?

- **"now"** — commit immediately
- **"group"** or silence — accumulate, commit in the final commit

---

## Constraints

- Do not do `git push` without explicit request
- Always wait for confirmation before committing
