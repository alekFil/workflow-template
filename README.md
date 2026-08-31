# workflow-template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet)](https://claude.ai/code)

A workflow template for [Claude Code](https://claude.ai/code) users who want structured, opinionated collaboration with the agent — modes, plans, ADRs — instead of ad-hoc sessions.

---

## Two layers

This repository holds two independent layers in one tree:

| Layer | Location | Purpose | Installed via `curl`? |
| --- | --- | --- | --- |
| Maintainer | root | develops and maintains the template itself | no |
| Template | `template/` | the payload installed into a new project | **yes** |

When you run `install.sh` in a fresh project, only the contents of `template/` are copied in (with placeholders substituted). The maintainer layer is where this repo evolves.

---

## Quick start

```bash
# 1. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Authorize (browser opens)
claude

# 3. Create the project repo
mkdir my-project && cd my-project
git init

# 4. Install the template
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/install.sh | bash

# 5. Launch Claude Code
claude
```

First command inside CC:

```text
Read CLAUDE.md and help me fill in the remaining placeholders.
```

Full details in [SETUP.md](SETUP.md).

---

## What you get

```text
your-project/
├── CLAUDE.md              ← CC reads on startup: project context, modes, conventions
├── WORKFLOW.md            ← slash command reference for the owner
├── .claude/
│   ├── index.md           ← documentation navigator
│   ├── commands/          ← 11 slash command files
│   └── skills/
│       ├── meta/          ← 6 workflow algorithms (/architect, /commit, /close, ...)
│       └── project/rules/ ← extension point for /polish (project-specific rules)
└── .context/
    ├── blueprint.md       ← architecture overview
    ├── status.md          ← implementation snapshot (git-pointer to previous)
    ├── to-do.md           ← task queue
    ├── decisions.md       ← ADR log
    ├── discussions/       ← human team discussions (empty at start)
    ├── history/           ← archived ADRs and retros (empty at start)
    └── notes/             ← private notes, in .gitignore (AI-user drafts)
```

`.context/plan.md` is intentionally absent — it's created by `/architect` on a feature branch and removed by `/close` before merge.

---

## Slash commands

| Command | Action |
| --- | --- |
| `/organize` | Organizer mode — discuss workflow, edit skills and index |
| `/architect` | Architect mode — discuss, record ADRs, write a plan |
| `/next` | Architect mode: suggest the first incomplete item from `to-do.md` |
| `/record` | Add an ADR to `decisions.md` (4-point checklist gate) |
| `/dev` | Developer mode — read `plan.md`, implement on a feature branch |
| `/polish` | Clean up generated code — built-in `simplify` + project rules |
| `/commit` | Show diff → confirm → commit |
| `/close` | Clean `plan.md` → rebase → ff-merge → delete branch |
| `/report` | Refresh `status.md` (git-pointer to previous version) |
| `/sync` | Compare code with documentation, suggest updates |
| `/retro` | Retrospective — history analysis → written retro → proposed actions |

---

## Core concepts

### ADR discipline

Architectural decisions live in `.context/decisions.md`. `/record` gates each new ADR through a 4-point checklist (alternatives, trade-off, long-term impact, "why" not "what") — small tactical fixes go to commit messages with a `Why:` section. Superseded and rejected ADRs move to `.context/history/decisions/`. See `CLAUDE.md → ADR discipline`.

### Artifact scope

`.context/` artifacts fall into three classes: **project-wide** (`blueprint.md`, `status.md`, `to-do.md`, `decisions.md`, ...) live on all branches; **task-local** (`plan.md`) exists only on `feature/*` and is cleaned by `/close`; **private** (`notes/`) is in `.gitignore` — AI-user drafts stay on your machine. See `CLAUDE.md → Artifact scope`.

### Skill boundaries

Each command completes strictly within its own scope. Suggesting the next step in text ("Ready for `/commit`?") is allowed; executing it automatically is not. `/dev` doesn't run `/commit`; `/architect` doesn't write code. Enforcement is soft (rule in skill text) — hooks-based hardening is on the roadmap. See `CLAUDE.md → Skill boundaries`.

---

## What a session looks like

```text
/architect add CSV export for the reports page
```

CC asks clarifying questions — which data, which format, where the trigger lives. You answer. CC creates a feature branch and writes `.context/plan.md`.

```text
/commit
```

Plan committed alongside the branch (visible for future review).

```text
/dev
```

CC reads the plan and implements strictly within its scope. No improvisation, no auto-commit.

```text
/commit
/close
```

Diff confirmed, commit made. `/close` cleans `plan.md`, rebases, ff-merges into `dev`.

*No screencast yet — see `template/WORKFLOW.md` (installed alongside the template) for the full command flow.*

---

## Contributing

Contributions welcome. See [CONTRIBUTION.md](CONTRIBUTION.md) for how the two layers evolve and how to sync improvements from real projects back into the template.

## License

MIT — see [LICENSE](LICENSE).
