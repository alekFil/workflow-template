# WORKFLOW.md – Claude Code Quick Reference

This file is a quick reference for the project owner. Instructions for Claude Code –
`CLAUDE.md`; skills – `.claude/skills/<name>/SKILL.md`; rules – `.claude/rules/`;
settings – `.claude/workflow.conf`.

## Initial setup

After deploying the template, fill in the placeholders before the first session.
Ask Claude: "Read CLAUDE.md and help me fill in the remaining placeholders".

| Placeholder | File | Purpose | Example |
| --- | --- | --- | --- |
| `{PROJECT_NAME}` | `CLAUDE.md`, `docs/product.md`, `.context/blueprint.md` | Project name in headings | `payment-service` |
| `{COMMUNICATION_LANGUAGE}` | `CLAUDE.md` | Language Claude uses in chat | `English` |
| `{CONTEXT_LANGUAGE}` | `CLAUDE.md` | Language of `.context/` and `docs/` | `Russian` |
| `{CODE_COMMENTS_LANGUAGE}` | `CLAUDE.md` | Language for code comments | `English` |
| `{PROJECT_DESCRIPTION}` | `CLAUDE.md` | One sentence: what the product is | `REST API for task tracking.` |
| `{REPO_URL}` | `CLAUDE.md` | Repository URL | `https://github.com/org/payment-service` |
| `{LAYER_*}` / `{TECH_*}` | `CLAUDE.md` | Stack table rows | `Backend` / `FastAPI` |
| `{ARCHITECTURE_RULES}` | `CLAUDE.md` | Key constraints Claude must follow | `Business logic not in routers.` |
| `{STATE_STORAGE}` | `CLAUDE.md` | Where application state lives | `Redis` |
| `{RUNTIME_SETUP}` | `CLAUDE.md` | Dev commands: install, run, test | `uv sync` / `uv run pytest` |
| `{CODE_CONVENTIONS}` | `CLAUDE.md` | Style and naming rules, commit format | `Type hints everywhere.` |
| `{PROJECT_LAYOUT}` | `CLAUDE.md` | Project-specific components (logical map) | `` `src/` – source `` |
| Purpose, users, principles, non-goals, boundary | `docs/product.md` | What the product is and is not | See inline guidance |
| `{COMPONENT_*}`, `{MAIN_FLOW}` | `.context/blueprint.md` | Components and the main data flow | See inline guidance |

Also worth setting up early:

- `docs/product.md` – especially **Non-goals**: Claude checks every task against
  them and stops before crossing the product boundary.
- First task cards: `/task <title>` for each.
- `.claude/rules/` – add `.md` files for project-specific rules: Claude Code loads
  them while writing, `/polish` checks the diff against them. The format –
  `.claude/skills/polish/rules-format.md`. `no-dead-code.md` is a starter example:
  remove it when you have your own rules. The other files are workflow and text
  rules of the template: keep them.

## Commands

Type `/command` in the Claude Code prompt. Skills that change git state or decisions
run only when you type them; the rest Claude may also start on a matching request.

| Command | What happens |
| --- | --- |
| `/task` | Add a task card to `.context/tasks/`, or reject one with a reason |
| `/next` | Suggest the next task card and open it for discussion |
| `/architect` | Discuss architecture → write the plan into the task card |
| `/record` | Record an ADR in `docs/decisions/` – only you start it |
| `/dev` | Implement the plan of the current card on its branch |
| `/go` | After the discussion: plan, code, polish, verify, commit, close – without stops |
| `/polish` | Clean up generated code – built-in `simplify` + rules from `.claude/rules/` |
| `/commit` | Show diff → wait for confirmation → commit |
| `/close` | Delete the card, then merge the branch or open a pull request |
| `/report` | Write `.context/status.md` (not committed) |
| `/sync` | Compare code with documentation, suggest edits |
| `/summary` | After a task or release: report, sync, commit, close – without stops |
| `/retro` | Analyze history → write a retro → propose task cards and ADR candidates |
| `/organize` | Discuss and edit the workflow itself: skills, rules, `CLAUDE.md` |
| `/writing-style` | Russian prose style – only when you ask for it |

Helper script:

```bash
.claude/scripts/workflow.sh tasks       # open task cards
.claude/scripts/workflow.sh done        # closed tasks from git history
.claude/scripts/workflow.sh adr-index   # regenerate docs/decisions/README.md
.claude/scripts/workflow.sh bootstrap   # devmeta: clone code/, install the leak guard
```

## Branches

Set at install in `.claude/workflow.conf` (`.claude/rules/branching.md`):

```text
BRANCH_MODEL=trunk               BRANCH_MODEL=dev
main                             main          ← releases (dev → main by you)
  └── feature/<slug>               └── dev     ← integration
                                         ├── feature/<slug>
                                         └── hotfix/<slug> → main
```

- `MERGE_MODE=local` – `/close` rebases and merges with `--ff-only` on your machine.
- `MERGE_MODE=pr` – `/close` pushes the task branch and opens a pull request.

Claude never pushes `main`, `dev` or tags and never merges `dev` → `main`.

## Typical workday

```text
0. Session start – Claude reads:
   docs/product.md → .context/blueprint.md → open tasks → .context/status.md

1. Pick a task
   → /next            (or /task <title> for a new one)

2. Discuss
   → /architect
   Claude asks questions, checks the product boundary, writes ## Plan into the card.
   Decisions worth an ADR are listed as candidates – record them with /record.

2a. Shortcut – everything is discussed
   → /go
   Plan, code, /polish, verification, commits, /close – without stops. Stops only
   for your steps (push, release), a conflict with an ADR or non-goal, or a check
   it cannot fix. Its own decisions are listed under "Decided without you".

3. Implement
   → /dev             Claude implements the plan on feature/<slug>, with tests

4. Commit
   → /commit          Claude shows what goes in, waits for confirmation
   → /polish          (optional, before the final commit)

5. Task done
   → /close           card deleted (Closes-Task commit), branch merged or PR opened

6. Every few tasks
   → /report, /sync   or the shortcut /summary

7. Periodically
   → /retro
```

## Commits

Format: `type: description`, trailer `Task: <slug>` on implementation commits.

| Type | When |
| --- | --- |
| `feat:` | new functional code |
| `fix:` | bug fix |
| `docs:` | documentation only |
| `refactor:` | refactoring without behavior change |
| `test:` | tests |
| `chore:` | infrastructure, configuration, dependencies |

## Project documentation

| File | Purpose |
| --- | --- |
| `CLAUDE.md` | Instructions for Claude |
| `docs/product.md` | What the product is: purpose, users, non-goals, boundary – yours to edit |
| `docs/decisions/` | ADRs, one file each; `README.md` is a generated index |
| `.context/blueprint.md` | How the system is built |
| `.context/tasks/` | Task cards; the plan of a task lives in its card |
| `.context/status.md` | Implementation snapshot, generated, not committed |
| `.context/discussions/` | Discussions between people |
| `.context/history/retros/` | Retrospectives |
| `.context/notes/` | Your private notes – not committed |
| `.claude/workflow.conf` | Profile, branch model, merge mode, paths |
| `.claude/rules/` | Workflow, text and project rules |

## Profiles

`PROFILE` in `.claude/workflow.conf` (`.claude/rules/profiles.md`):

- `project` – code and context in one repository.
- `own-oss` – this is a private devmeta repository; your public code is in `code/`
  and receives no workflow files. Public ADRs – `code/docs/decisions/`.
- `contribution` – private devmeta for a contribution to someone else's project;
  your fork is in `code/`, every task ends in a pull request upstream, no ADRs.

New machine for a devmeta repository: clone it, run
`.claude/scripts/workflow.sh bootstrap`.
