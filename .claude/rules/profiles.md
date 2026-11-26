# profiles

`PROFILE` in `.claude/workflow.conf` says where the code and the context live.

| `PROFILE` | Code (`CODE_DIR`) | ADRs (`DECISIONS_DIR`) | Product (`PRODUCT_FILE`) |
| --- | --- | --- | --- |
| `project` | this repository (`.`) | `docs/decisions` | `docs/product.md` |
| `own-oss` | `code/` – your public repository | `code/docs/decisions` – public | `docs/product.md` – private |
| `contribution` | `code/` – your fork of someone else's project | `none` | `none` |

## Devmeta profiles (`own-oss`, `contribution`)

This repository is private and holds only the context: `CLAUDE.md`, `.claude/`,
`.context/`, `docs/`. The code repository is cloned into `code/`, which this
repository ignores. Public engineering, private reasoning.

- Never create, copy or commit workflow files in `code/`: no `CLAUDE.md`,
  `.claude/`, `.context/`, task cards, plans or notes. A local pre-commit hook in
  `code/` blocks them; never bypass it.
- Commits in `code/` carry no workflow trailers or references to cards and plans.
- The context repository has a single branch, `main`: no task branches, no pull
  requests. Task branches exist only in `code/`.
- A new machine: clone this repository, then run
  `.claude/scripts/workflow.sh bootstrap`.

## Contribution profile

The project is someone else's; its rules win over this workflow.

- Read the upstream `CONTRIBUTING`, `README` and its own `CLAUDE.md` or `AGENTS.md`
  (Claude Code loads `code/CLAUDE.md` when it works with files there). Follow their
  branch names, commit style, tests and pull request template.
- Task branches start from `upstream/<UPSTREAM_BRANCH>`; every task ends with a pull
  request to `UPSTREAM_REPO` (`/close`, `MERGE_MODE=pr`).
- No ADRs and no product file: decisions about the contribution are private notes
  in `.context/notes/` or the task card.
- Scope comes from the upstream issue or discussion, not from this repository.
