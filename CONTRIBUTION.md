# CONTRIBUTION.md – How to work with this repo

Maintainer instructions.
Full context for CC – in `CLAUDE.md`.

---

## What's done here

`workflow-template` – a meta-repo: developing the workflow template for Claude Code.
The maintainer's task – improve the template, sync changes from working projects.

Two independent layers:

- **Maintainer** (root) – `CLAUDE.md`, `CONTRIBUTION.md`, `.context/`, `.claude/`, `scripts/`
- **Template** (`template/`) – everything that goes into a new project when deployed

---

## Typical work cycle

1. `/next` – pick a task card from `.context/tasks/`
2. `/architect` – design, write the plan into the task card
3. `/dev` – implement the plan
4. `/commit` – commit changes
5. `/close` – merge into `dev`

---

## Syncing improvements from working projects

If a skill or process improvement appeared in a working project:

1. Open a session with this repo
2. Transfer the change manually:
   - Skill → `.claude/skills/<name>/` and/or `template/.claude/skills/<name>/`
   - Rule → `.claude/rules/` and/or `template/.claude/rules/`
   - `CLAUDE.md` improvement → `template/CLAUDE.md`
3. `/commit`

Skills and rules of the two layers are independent copies.
The decision to sync between them is always intentional.

---

## What NOT to touch

- All `{PLACEHOLDERS}` in `template/` – do not fill with real data
- `template/.context/` folders with `.gitkeep` – needed for structure

---

## Versioning

Skills are not explicitly versioned.
Change history – in `git log` and `docs/decisions/`.
