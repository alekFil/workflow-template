# branching

Branch model and merge mode are settings in `.claude/workflow.conf`:
`BRANCH_MODEL` and `MERGE_MODE`. All git commands run in the code repository
(`CODE_DIR`). Missing keys mean `BRANCH_MODEL=trunk`, `MERGE_MODE=local`.

## Branch model

| `BRANCH_MODEL` | Branches | Task branch goes to | Release |
| --- | --- | --- | --- |
| `trunk` | `main`, `feature/<slug>` | `main` | every merge into `main` |
| `dev` | `main`, `dev`, `feature/<slug>`, `hotfix/<slug>` | `feature/*` → `dev`, `hotfix/*` → `main` | the owner merges `dev` → `main` manually |

## Integration branch

Task branches start from the integration branch and go back into it:

| Case | Integration branch |
| --- | --- |
| `BRANCH_MODEL=trunk` | `main` |
| `BRANCH_MODEL=dev` | `dev` (`hotfix/*`: `main`) |
| `PROFILE=contribution` | `upstream/<UPSTREAM_BRANCH>` – fetch before branching |

In `MERGE_MODE=pr` use the remote state: branch from and rebase onto
`origin/<branch>` (contribution: `upstream/<UPSTREAM_BRANCH>`) after `git fetch`.

## Task branch name

`feature/<slug>` after the task card (`hotfix/<slug>` in the dev model). When the
project prescribes other names (contribution: upstream `CONTRIBUTING`), use them and
record the name in the card's frontmatter: `branch: fix/123-crash`.

## Merge mode

- `local` – `/close` rebases the task branch onto its target and merges it with
  `--ff-only` on this machine. History stays linear. Nothing is pushed.
- `pr` – `/close` pushes the task branch to `origin` and opens a pull request;
  people review and merge it on the hosting. Choosing `pr` is the owner's standing
  permission to push task branches – only task branches. After a rebase of an
  already pushed task branch, push it with `--force-with-lease`; never force-push
  anything else.
- With `pr`, merge on the hosting with a merge commit or a rebase merge. A squash
  merge must keep the `Closes-Task:` trailer as the last line of the message,
  otherwise `workflow.sh done` misses the task.

## Never without an explicit request of the owner

- push `main`, `dev` or tags;
- merge `dev` → `main`;
- force-push anything except a task branch in `MERGE_MODE=pr`, `git reset --hard`,
  history rewriting outside the task branch.
