# Skill: Close task

Triggered by: `/close`, "close the task", "task done" and variations.

---

## Algorithm

### 1. Check the current branch

```bash
git branch --show-current
```

- If `feature/*` — target branch: `dev`
- If `hotfix/*` — target branch: `main`
- If `main` or `dev` — report: "Cannot close task — you are on a protected branch. Switch to feature/* or hotfix/*."

### 2. Make sure there is nothing to commit

```bash
git status
```

If there are uncommitted changes — suggest running `/commit` first.

### 3. Rebase onto the target branch

```bash
git fetch origin
git rebase <target branch>
```

If conflicts arise — stop and report:

```text
Conflict during rebase. Resolve manually, then:
  git rebase --continue
After that repeat /close.
```

### 4. Merge into the target branch (ff-only)

```bash
git checkout <target branch>
git merge --ff-only <feature/hotfix branch>
```

### 5. Delete the feature/hotfix branch

```bash
git branch -d <feature/hotfix branch>
```

### 6. Report the result

```text
Task closed: <branch> → <target branch>
```

If it was `hotfix/*` — add a reminder:

```text
Hotfix merged into main. Don't forget to rebase dev:
  git checkout dev && git rebase main
```

---

## Constraints

- Do not do `git push` without explicit request
- Do not merge `dev → main` — that is a release decision, done manually
