# CONTRIBUTION.md — How to work with this repo

Maintainer instructions.
Full context for CC — in `CLAUDE.md`.

---

## What's done here

`workflow-template` — a meta-repo: developing the workflow template for Claude Code.
The maintainer's task — improve the template, sync changes from working projects.

Two independent layers:

- **Maintainer** (root) — `CLAUDE.md`, `CONTRIBUTION.md`, `.context/`, `.claude/`, `scripts/`
- **Template** (`template/`) — everything that goes into a new project when deployed

---

## Typical work cycle

1. `/next` — pick a task from `.context/to-do.md`
2. `/architect` — design, write a plan in `.context/plan.md`
3. `/dev` — implement the plan
4. `/commit` — commit changes
5. `/close` — merge into `dev`

---

## Syncing improvements from working projects

If a skill or process improvement appeared in a working project:

1. Open a session with this repo
2. Transfer the change manually:
   - Skill → `.claude/skills/meta/` and/or `template/.claude/skills/meta/`
   - `CLAUDE.md` improvement → `template/CLAUDE.md`
3. `/commit`

`.claude/skills/meta/` and `template/.claude/skills/meta/` — independent copies.
The decision to sync between them is always intentional.

---

## CC persistent memory

Claude Code automatically creates a `memory/` directory in the repo root to store
persistent context between sessions. It is excluded from git via `.gitignore` and
removed by `scripts/uninstall.sh`. No manual management needed — CC handles it automatically.

---

## What NOT to touch

- All `{PLACEHOLDERS}` in `template/` — do not fill with real data
- `.context/history/` and `template/.context/history/` — empty folders (`.gitkeep`), needed for structure

---

## Versioning

Skills are not explicitly versioned.
Change history — in `git log` and `.context/decisions.md`.
