# workflow-template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet)](https://claude.ai/code)

A workflow template for [Claude Code](https://claude.ai/code) users who want structured, opinionated collaboration with the agent – modes, plans, ADRs – instead of ad-hoc sessions.

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

Full details, other versions (`WT_REF=dev`, `WT_REF=v1`) and local installs – in
[SETUP.md](SETUP.md).

---

## What you get

```text
your-project/
├── CLAUDE.md              ← Claude Code reads on startup: project context, links
├── WORKFLOW.md            ← command reference for the owner
├── docs/
│   ├── product.md         ← purpose, users, non-goals, product boundary
│   └── decisions/         ← ADRs, one file each + generated README.md index
├── .claude/
│   ├── workflow.conf      ← profile, branch model, merge mode, paths
│   ├── rules/             ← workflow, text and project rules (loaded automatically)
│   ├── skills/<name>/     ← one SKILL.md per command
│   └── scripts/workflow.sh ← task list, done list, ADR index, devmeta bootstrap
└── .context/
    ├── blueprint.md       ← how the system is built
    ├── tasks/             ← task cards; the plan of a task lives in its card
    ├── status.md          ← implementation snapshot (generated, not committed)
    ├── discussions/       ← discussions between people
    ├── history/retros/    ← retrospectives
    └── notes/             ← private notes, in .gitignore
```

The installer asks for a **profile** (`project`, `own-oss`, `contribution`), a
**branch model** (`trunk` or `dev`) and a **merge mode** (`local` or `pr`). In the
devmeta profiles the repository you install into is private and holds only the
context; the code is cloned into `code/` and never receives workflow files.

---

## Slash commands

| Command | Action |
| --- | --- |
| `/task` | Add a task card, or reject one with a reason |
| `/next` | Suggest the next task card for discussion |
| `/architect` | Discuss, check the product boundary, write the plan into the card |
| `/record` | Record an ADR (4-point checklist gate) – only the owner starts it |
| `/dev` | Implement the plan on `feature/<slug>` |
| `/go` | After the discussion: plan, code, polish, verify, commit, close – no stops |
| `/polish` | Clean up generated code – built-in `simplify` + `.claude/rules/` |
| `/commit` | Show diff → confirm → commit |
| `/close` | Delete the card → merge the branch or open a pull request |
| `/report` | Write `status.md` |
| `/sync` | Compare code with documentation, suggest updates |
| `/summary` | After a task or release: report, sync, commit, close – no stops |
| `/retro` | Retrospective – history analysis → written retro → proposed actions |
| `/organize` | Discuss and edit the workflow itself |

---

## Core concepts

### No merge conflicts in generated prose

Shared text falls into three classes: collections with one file per entity (ADRs,
task cards, retros), derived state that is only generated (`status.md`, the ADR
index), and curated singletons the owner edits on purpose (`product.md`,
`blueprint.md`, `CLAUDE.md`). ADR IDs are `YYYY-MM-DD-<slug>`, so parallel branches
never collide. See `.claude/rules/artifacts.md`.

### ADRs are rare and the owner's

Only `/record` writes an ADR, after a 4-point checklist (alternatives, trade-off,
long-term impact, "why" not "what"). Other skills list ADR candidates. Tactical
decisions go to commit messages with a `Why:` section. See
`.claude/rules/adr-discipline.md`.

### Tasks without a done list

A task card lives in `.context/tasks/` while the task is open. `/close` deletes it
with a `Closes-Task:` commit trailer; the history of done tasks comes from git.
Rejected cards stay with a reason, so the idea is not proposed again.

### Skill boundaries

Each command completes strictly within its own scope. Suggesting the next step in
text is allowed; executing it automatically is not. Skills that change git state or
decisions run only when the owner types them. See `.claude/rules/skill-boundaries.md`.

---

## What a session looks like

```text
/next
/architect
```

Claude suggests the next card, asks clarifying questions, checks the task against
the product non-goals and writes `## Plan` into the card on `feature/<slug>`.

```text
/commit
/dev
```

The plan travels with the branch. Claude implements strictly within its scope, with
tests. No improvisation, no auto-commit.

```text
/commit
/close
```

`/close` deletes the card with a `Closes-Task:` commit, then merges the branch
(`local`) or pushes it and opens a pull request (`pr`).

*No screencast yet – see `template/WORKFLOW.md` for the full command flow.*

---

## Contributing

Contributions welcome. See [CONTRIBUTION.md](CONTRIBUTION.md) for how the two layers evolve and how to sync improvements from real projects back into the template.

## License

MIT – see [LICENSE](LICENSE).
