# analytics-workflow-template — CLAUDE.md

**Language:**

- Communication: Russian
- `.context/` files: Russian
- Code comments: English
- Workflow docs (`.claude/`, skills, commands): English

Context for Claude Code when working with this repository.
This is a **meta-repo**: a workflow template for analytical projects.

---

## About this repo

`analytics-workflow-template` — a workflow template repository for Claude Code, specialised for
data analysis projects (notebooks, empirical findings, statistical methodology).

The `analytics` branch of `workflow-template`. Both branches are permanent and independent:

| | `main` branch | `analytics` branch |
| --- | --- | --- |
| Target project | Software product | Data analysis |
| Work artefact | Code + tests | Notebook + findings.md entry |
| "Architecture" | `blueprint.md` — components, data flows | `blueprint.md` — data schema, pipeline + `methodology.md` — statistical conventions |
| Key sync risk | Docs drift from code | Finding becomes invalid on new data |
| Sync skill | `cc-architect-sync` | `cc-finding-sync` |
| Branch model | `main`/`dev`/`feature/*` | `main`/`experiment/*` |
| Output | Deployed code | Report / presentation |

### Two layers

- **Maintainer** (root): `CLAUDE.md`, `CONTRIBUTION.md`, `.context/`, `.claude/`, `scripts/`
- **Template** (`template/`): everything that goes into a new analytics project via `scripts/install.sh`

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
template/                        ← template layer (goes into new analytics project)
  CLAUDE.md
  WORKFLOW.md
  pyproject.toml
  .claude/
    index.md
    commands/       ← slash commands
    skills/meta/   ← independent copy of skills (includes analytics-specific)
  .context/
    blueprint.md / methodology.md / findings.md
    plan.md / to-do.md / status.md / decisions.md
    history/ / discussions/ / notes/
  data/
    README.md       ← data provenance (data files not in git)
  notebooks/
    README.md
  src/
    README.md
    analysis_utils.py  ← ready-to-use statistical functions
  tests/
    test_analysis_utils.py
  outputs/          ← exported reports and presentations
```

---

## Navigation

| Need | Where to look |
| --- | --- |
| Template for new analytics project | `template/` |
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
| `/brainstorm [topic]` | Switch to Brainstorm mode — explore the analytical question before designing |
| `/brainstorm done` | End brainstorm session — save discussion, fill context documents |
| `/organize` | Switch to Organizer mode |
| `/architect` | Switch to Architect mode |
| `/next` | Architect mode: first incomplete item from `.context/to-do.md` |
| `/record` | Add ADR to `.context/decisions.md` |
| `/dev` | Switch to Developer mode — implement `.context/plan.md` |
| `/report` | Archive and write new `.context/status.md` |
| `/sync` | Compare documentation with implementation, suggest changes |
| `/retro` | Retrospective: analyse history → discussion file → actions |
| `/commit` | Show diff → confirm → commit |

---

## Branching conventions

- Maintainer branches: `feature/<name>` → `dev` → `main` (same as `workflow-template`)
- CC never does `git push` without explicit request
- The `analytics` branch itself is never merged back into `main`

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

If a skill or workflow improvement appeared in a working analytics project:

1. Open a session with this repo
2. Manually transfer the change:
   - General skill (`cc-commit`, `cc-close-task`, `cc-status-report`) →
     `.claude/skills/meta/` **and** `template/.claude/skills/meta/` (both copies)
   - Analytics skill (`cc-record-finding`, `cc-finding-sync`, `cc-report`, `cc-present`) →
     `template/.claude/skills/meta/` **only** — these have no equivalent in the maintainer layer
   - `CLAUDE.md` improvement → `template/CLAUDE.md`
   - Reusable statistical function proven across several projects →
     `template/src/analysis_utils.py` + test in `template/tests/`
3. Commit: `/commit`

### Skill versioning

Skills are not explicitly versioned. Change history — in git log and `.context/decisions.md`.

### What NOT to touch

- All files in `template/` keep `{PLACEHOLDERS}` — do not fill with real data.
- `template/src/analysis_utils.py` — working code, not a placeholder. Change only if a function
  genuinely improves, with `template/tests/test_analysis_utils.py` passing.
- `.context/history/` and `template/.context/history/` — empty folders (`.gitkeep`), needed for structure.

---

## Current state

Current state — in `.context/status.md`.
