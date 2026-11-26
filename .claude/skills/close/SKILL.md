---
name: close
description: "Close the current task: delete its card with a Closes-Task commit, then merge the branch locally or push it and open a pull request, as the branch rules say. Only on the owner's explicit /close."
disable-model-invocation: true
---

# Close task

Settings – `.claude/workflow.conf`. Branch model and merge mode –
`.claude/rules/branching.md`. Task cards – `.claude/rules/artifacts.md`.
Missing keys mean `BRANCH_MODEL=trunk`, `MERGE_MODE=local`.

The **code repository** is `CODE_DIR`; run its git commands as `git -C <CODE_DIR>`.
The **context repository** is the root. With `CODE_DIR=.` they are the same.

## Algorithm

### 1. Check the branch

In the code repository:

```bash
git -C <CODE_DIR> branch --show-current
```

- `feature/<slug>` – target: the integration branch
  (`.claude/rules/branching.md`).
- `hotfix/<slug>` – dev model only; target: `main`.
- A branch recorded in a card's `branch:` field – target: the integration branch.
- Any other branch – report: "Cannot close – not on a task branch." Stop.

The card is the current task card (`.claude/rules/artifacts.md`).

### 2. Nothing left to commit

Run `git status` in both repositories. If there are uncommitted changes – suggest
`/commit` first. Stop.

### 3. Delete the task card

With `CODE_DIR=.` the card is on the task branch. Delete it there. A `hotfix/*`
branch comes from `main` and has no card: its card is deleted on `dev` after the
merge (end of step 6).

```bash
git rm <TASKS_DIR>/<slug>.md
git commit -m "chore: close task <slug>" -m "Closes-Task: <slug>"
```

In devmeta profiles the card is in the context repository on `main`. Delete it there,
and list the code branch and its commits in the message body:

```bash
git rm <TASKS_DIR>/<slug>.md
git commit -m "chore: close task <slug>" \
  -m "Code: <branch>, <short hashes of the task commits in CODE_DIR>" \
  -m "Closes-Task: <slug>"
```

If the card was never created – skip this step silently. Before deleting, move any
open `## ADR candidates` into the report (step 6): the owner decides on them.

### 4. Update the branch

Rebase onto the target. In `MERGE_MODE=pr` rebase onto the remote state:
`origin/<target>`, in the contribution profile `upstream/<UPSTREAM_BRANCH>`.

```bash
git -C <CODE_DIR> fetch --all --prune
git -C <CODE_DIR> rebase <target or its remote ref>
```

On conflict – stop and report:

```text
Conflict during rebase. Resolve manually, then:
  git -C <CODE_DIR> rebase --continue
After that repeat /close.
```

### 5. Integrate

**`MERGE_MODE=local`:**

```bash
git -C <CODE_DIR> checkout <target>
git -C <CODE_DIR> merge --ff-only <branch>
git -C <CODE_DIR> branch -d <branch>
```

**`MERGE_MODE=pr`:** push only the task branch, never `main` or `dev`, and open a
pull request. People merge it on the hosting.

```bash
git -C <CODE_DIR> push -u --force-with-lease origin <branch>
gh pr create --base <target> --head <branch> --fill
```

`--force-with-lease` matters on a repeated `/close` after review changes: the branch
was rebased and must replace its pushed version. If the pull request already exists,
`gh pr create` fails – report its URL (`gh pr view --json url`) instead.

- Contribution profile: the pull request goes to the upstream repository:
  `gh pr create --repo <UPSTREAM_REPO> --base <UPSTREAM_BRANCH>
  --head <fork owner>:<branch>`.
  Title and body follow the upstream `CONTRIBUTING`; no workflow references.
- No `gh` – print the compare URL of the hosting instead.
- Keep the local branch: after the merge on the hosting, the owner runs
  `git -C <CODE_DIR> checkout <target> && git -C <CODE_DIR> pull --ff-only` and
  deletes it.

### 6. Report

```text
Task closed: <slug>
  Code: <branch> → <target> (merged locally | pull request <url>)
  Card: deleted, Closes-Task commit <hash>
  ADR candidates: <list or "none"> – record with /record if needed
```

Dev model, `hotfix/*` merged into `main` locally: rebase `dev` onto `main`, then
delete the card on `dev` (with `CODE_DIR=.`), because the card was committed there:

```bash
git checkout dev && git rebase main
git rm <TASKS_DIR>/<slug>.md
git commit -m "chore: close task <slug>" -m "Closes-Task: <slug>"
```

Rebasing `dev` is allowed here only in `MERGE_MODE=local` and only when `dev` is not
pushed ahead of the remote; otherwise report the two commands to the owner.

## Constraints

- Push only in `MERGE_MODE=pr`, only the task branch
- Never merge `dev` → `main`: that is a release decision of the owner
- Never push the context repository: the owner does it
