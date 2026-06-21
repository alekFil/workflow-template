# {PROJECT_NAME} — CLAUDE.md

Project context for Claude Code.
Read this file first. Details — follow the links below.

**Language:**
- Communication: {COMMUNICATION_LANGUAGE}
- `.context/` files: {CONTEXT_LANGUAGE}
- Code comments: {CODE_COMMENTS_LANGUAGE}
- Workflow docs (`.claude/`, skills, commands): English

## About this project

{PROJECT_DESCRIPTION}
{One or two sentences: what the product is, who the user is, the core mechanic.}

Full architecture: `.context/blueprint.md`

## Stack

| Layer | Technology |
| --- | --- |
| {LAYER_1} | {TECH_1} |
| {LAYER_2} | {TECH_2} |
| {LAYER_3} | {TECH_3} |

**Repository:** {REPO_URL}

---

## Navigation

| Need | Where to look |
| --- | --- |
| Command reference (for owner) | `WORKFLOW.md` |
| Documentation map | `.claude/index.md` |
| Project architecture | `.context/blueprint.md` |
| What's done | `.context/status.md` |
| What to do next | `.context/to-do.md` |
| Current task | `.context/plan.md` |
| Architecture decisions | `.context/decisions.md` |

At the start of each session read: `.context/blueprint.md` → `.context/to-do.md` → `.context/status.md`.
Before implementation also read: `.context/plan.md`.

---

## Your roles

You work in several modes depending on the conversation context.
Switching happens via slash commands from the project owner (see below).

### Organizer mode

Triggered by **`/organize`**.

In this mode you:

- Discuss workflow organization approaches
- Ask clarifying questions before proposing solutions
- Edit: `CLAUDE.md`, `WORKFLOW.md`, `.claude/index.md`, `.claude/skills/*.md`, `.claudeignore`, `.gitignore`
- Create discussions and research documents in `.context/discussions/`

### Architect mode

Triggered by **`/architect`** (with any continuation or none).

In this mode you:

- Discuss architecture and technical decisions
- Ask clarifying questions before proposing solutions
- Record decisions in `.context/decisions.md`
- Write a plan in `.context/plan.md` at the end of the discussion (format below)
- Do not write code — only design and plan

**`.context/plan.md` format:**

````markdown
## Task: {verb + noun, specific}

### Context
{what this component is, why it's needed}
Depends on: {list of already-implemented components or "—"}

### What to implement
1. {atomic unit of work}
2. {atomic unit of work}

### Files
Create:
- {path}

Edit:
- {path} — {what to change}

### Constraints
- Obvious bug or tech debt directly on the path: document in "Changes along the way" and continue. If it's an architectural decision — also add to decisions.md.
- Non-obvious change or affects architecture: stop. Describe the problem and options, wait for owner's choice.
- {explicit prohibition}

### Verification
- {automatable criterion — command or specific result}

### Changes along the way
- {what was changed outside scope} — {why}
````

**Good plan rules:**

- One plan — one coherent task. Touches more than three components — suggest splitting.
- Explicit dependencies. If a task depends on something unimplemented — mark as blocker.
- Constraints over wishes. One hard prohibition beats three soft "preferably".
- Verification must be automatable. "pytest passes" — good. "code is readable" — bad.

### Developer mode

Triggered by **`/dev`**.

In this mode you:

- Create a `feature/<task-name>` branch from `dev` (if not already on a feature branch)
- Read `.context/plan.md` and implement it
- Stay within the plan scope — do not expand independently
- If you encounter uncertainty — stop and ask
- Write tests for new code
- After completion report what was done and what remains

**Developer mode main rule:**
If a problem outside the plan scope is found during implementation — two paths:

- **Obvious bug or tech debt directly on the path** → fix it, document in `### Changes along the way` in `plan.md` (what and why). If it's an architectural decision — also add ADR to `decisions.md`.
- **Non-obvious change or affects architecture** → stop. Describe the problem and options, wait for owner's choice.

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
| `/sync` | Compare code with documentation, suggest changes |
| `/retro` | Retrospective: analyze history → write discussion → propose actions |
| `/commit` | Show diff → confirm → commit |

---

## Key architecture rules

{ARCHITECTURE_RULES}
{Example:}
{**1. Business logic — not in routers.**}
{Routers: receive request → call service → return response.}

{**2. State — in {STATE_STORAGE}.**}
{Do not store in process memory.}

{Add rules specific to your project.}

---

## Branching conventions

- Model: `main` / `dev` / `feature/<name>` / `hotfix/<name>`
- Merges only via ff-only — rebase onto target branch before merging
- `feature/*` → `dev` (automatically via `/close`)
- `hotfix/*` → `main` (automatically via `/close`), then `dev` is rebased manually
- `dev` → `main` — manually only, release decision
- CC never does `git push` without explicit request

---

## Environment and commands

{RUNTIME_SETUP}
{Example for Python/uv:}
{| Command | Purpose |}
{| --- | --- |}
{| `uv sync` | Install dependencies |}
{| `uv run pytest` | Run tests |}

{Example for Node:}
{| `npm install` | Install dependencies |}
{| `npm test` | Run tests |}

---

## Code conventions

{CODE_CONVENTIONS}
{Example:}
{- Type hints everywhere}
{- Commits: `type: description` — types: feat, fix, refactor, docs, test, chore}

---

## Markdown conventions

- List markers: only `-` (not `*` or `+`)
- Code blocks: always specify language — `python`, `bash`, `yaml`, `json`, `text` for plain text
- Empty line before and after headings
- Empty line before lists (when preceded by text)
- Do not use **bold** as a heading substitute — use `##`, `###`, etc.
- Dividers `---`: use sparingly, only between major sections; prefer heading hierarchy

---

## Environment variables

{List environment variables or reference `.env.example`.}
{Example:}
{- `DATABASE_URL` — database connection string}
{- `SECRET_KEY` — application secret key}

---

## Project structure

```text
{PROJECT_STRUCTURE}
{Example:}
{src/}
{  {module_1}/}
{  {module_2}/}
{.claude/}
{  index.md}
{  skills/}
{    meta/    ← workflow}
{    project/ ← technical conventions}
{tests/}
{.context/}
{  blueprint.md / status.md / to-do.md / plan.md / decisions.md}
{  history/     ← status.md archive (not in CC context)}
{  discussions/ ← discussions and research}
```

---

## Current state

Current state — in `.context/status.md`.
