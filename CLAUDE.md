# workflow-template — CLAUDE.md

**Language:** Respond in the user's language.

Context for Claude Code when working with this repository.
This is a **meta-repo**: a workflow template for new projects.

---

## About this repo

`workflow-template` — a workflow template repository for Claude Code.
Contains documentation structure, meta-skills, and CC instructions.
Used as the foundation when starting a new project.

### Two layers

- **Maintainer** (root): `CLAUDE.md`, `CONTRIBUTION.md`, `.context/`, `.claude/`, `scripts/`
- **Template** (`template/`): everything that goes into a new project when deployed via `scripts/install.sh`

---

## Repo structure

```text
CLAUDE.md                        ← maintainer instructions (this file)
CONTRIBUTION.md                  ← how to work with this repo
SETUP.md                         ← deployment instructions
scripts/
  install.sh                     ← curl template installation
  uninstall.sh                   ← curl assistant removal
.claude/
  index.md                       ← CC navigator (maintainer)
  commands/                      ← slash commands
  skills/meta/
    cc-commit.md
    cc-close-task.md
    cc-status-report.md
    cc-architect-sync.md
.context/
  blueprint.md
  plan.md
  to-do.md
  status.md
  decisions.md
  history/          ← status.md archive
  discussions/      ← discussions
template/                        ← template layer (goes into new project)
  CLAUDE.md
  WORKFLOW.md
  .claude/
    index.md
    commands/       ← slash commands
    skills/meta/   ← independent copy of skills
  .context/
    blueprint.md / plan.md / to-do.md / status.md / decisions.md
    history/ / discussions/
```

---

## Navigation

| Need | Where to look |
| --- | --- |
| Template for new project | `template/` |
| Deployment instructions | `SETUP.md` |
| How to work with this repo | `CONTRIBUTION.md` |
| What's planned for improvement | `.context/to-do.md` |
| What has changed | `.context/decisions.md` |
| Documentation navigator | `.claude/index.md` |

---

## Your roles

You work in several modes depending on the conversation context.
Switching happens via slash commands (see below).

### Organizer mode

Triggered by **`/organize`**.

In this mode you:

- Discuss template improvements
- Ask clarifying questions before proposing solutions
- Edit: `CLAUDE.md`, `CONTRIBUTION.md`, `template/CLAUDE.md`, `template/WORKFLOW.md`, `.claude/skills/meta/*.md`, `template/.claude/skills/meta/*.md`

### Architect mode

Triggered by **`/architect`** (with any continuation or none).

In this mode you:

- Discuss changes in template structure or skills
- Ask clarifying questions before proposing solutions
- Record decisions in `.context/decisions.md`
- Write a plan in `.context/plan.md`
- Do not make changes — design and plan only

### Developer mode

Triggered by **`/dev`**.

In this mode you:

- Read `.context/plan.md` and implement it
- Edit template files according to the plan
- Stay within the plan scope

---

## Slash commands

| Command | Action |
| --- | --- |
| `/organize` | Switch to Organizer mode |
| `/architect` | Switch to Architect mode |
| `/next` | Architect mode: first incomplete item from `.context/to-do.md` |
| `/record` | Add ADR to `.context/decisions.md` |
| `/dev` | Switch to Developer mode — implement `.context/plan.md` |
| `/close` | Merge feature branch, close the task |
| `/report` | Archive and write new `.context/status.md` |
| `/sync` | Compare documentation with implementation, suggest changes |
| `/commit` | Show diff → confirm → commit |

---

## Branching conventions

- Model: `main` / `dev` / `feature/<name>` / `hotfix/<name>`
- Merges only via ff-only — rebase onto target branch before merging
- `feature/*` → `dev` (via `/close`)
- `dev` → `main` — manually only
- CC never does `git push` without explicit request

---

## Markdown conventions

- List markers: only `-` (not `*` or `+`)
- Code blocks: always specify language — `python`, `bash`, `yaml`, `json`, `text` for plain text
- Empty line before and after headings
- Empty line before lists (when preceded by text)
- Do not use **bold** as a heading substitute — use `##`, `###`, etc.
- Dividers `---`: use sparingly, only between major sections; prefer heading hierarchy

---

## Maintaining this template

### Syncing improvements from real projects

If a skill or workflow improvement appeared in a working project and you want to bring it into the template:

1. Open a session with this repo
2. Manually transfer the change:
   - Skill → `.claude/skills/meta/` and/or `template/.claude/skills/meta/`
   - CLAUDE.md → `template/CLAUDE.md`
3. Commit: `/commit`

### Skill versioning

Skills are not explicitly versioned. Change history — in git log and `.context/decisions.md`.

### What NOT to touch

- All files in `template/` keep `{PLACEHOLDERS}` — do not fill with real data.
- `.context/history/` and `template/.context/history/` — empty folders (`.gitkeep`), needed for structure.

---

## Current state

Current state — in `.context/status.md`.
