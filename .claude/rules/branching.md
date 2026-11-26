# branching

Branch model and merge mode are settings in `.claude/workflow.conf`:
`BRANCH_MODEL` and `MERGE_MODE`. All git commands run in the code repository
(`CODE_DIR`).

## Branch model

| `BRANCH_MODEL` | Branches | Task branch goes to | Release |
| --- | --- | --- | --- |
| `trunk` | `main`, `feature/<slug>` | `main` | every merge into `main` |
| `dev` | `main`, `dev`, `feature/<slug>`, `hotfix/<slug>` | `feature/*` → `dev`, `hotfix/*` → `main` | the owner merges `dev` → `main` manually |

The **integration branch** is `main` in the trunk model and `dev` in the dev model.
Task branches start from it. A task branch is named after its card:
`feature/<slug>`.

In the dev model, after a `hotfix/*` merge into `main` the owner rebases `dev` onto
`main`.

## Merge mode

- `local` – `/close` rebases the task branch onto its target and merges it with
  `--ff-only` on this machine. History stays linear. Nothing is pushed.
- `pr` – `/close` pushes the task branch to `origin` and opens a pull request;
  people review and merge it on the hosting. Choosing `pr` is the owner's standing
  permission to push task branches – only task branches.

## Never without an explicit request of the owner

- push `main`, `dev` or tags;
- merge `dev` → `main`;
- force-push, `git reset --hard`, history rewriting outside the task branch.
