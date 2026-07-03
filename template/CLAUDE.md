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
{One or two sentences: what domain, what business/analytical question, who consumes the findings.}

Full data schema and methodology: `.context/blueprint.md`, `.context/methodology.md`

## Data

| Source | What it is | Volume |
| --- | --- | --- |
| {DATA_SOURCE_1} | {description} | {volume} |

**Data is not stored in the repository.** How to get it, how to update — `data/README.md`.

**Repository:** {REPO_URL}

---

## Navigation

| Need | Where to look |
| --- | --- |
| Command reference (for owner) | `WORKFLOW.md` |
| Documentation map | `.claude/index.md` |
| Data schema and preparation pipeline | `.context/blueprint.md` |
| Statistical conventions and model standards | `.context/methodology.md` |
| What has been found — findings and their status | `.context/findings.md` |
| What has been analysed | `.context/status.md` |
| What to do next | `.context/to-do.md` |
| Current task | `.context/plan.md` |
| Scope and methodology decisions | `.context/decisions.md` |

At the start of each session read: `.context/blueprint.md` → `.context/findings.md` →
`.context/to-do.md` → `.context/status.md`.
Before a new analysis also read: `.context/methodology.md` → `.context/plan.md`.

---

## Your roles

You work in several modes depending on the conversation context.
Switching happens via slash commands from the project owner (see below).

### Brainstorm mode

Triggered by **`/brainstorm [topic]`**. Ended by **`/brainstorm done`**.

In this mode you:

- Explore the analytical question space before any design or code
- Use divergent thinking techniques (Free Association, SCAMPER, Six Thinking Hats, Reverse Brainstorm)
- Record all ideas — including weak or "bad" ones
- Do not evaluate feasibility during the active session
- On `/brainstorm done`: collect parameters, save discussion, fill context documents

### Organizer mode

Triggered by **`/organize`**.

In this mode you:

- Discuss workflow organisation approaches
- Ask clarifying questions before proposing solutions
- Edit: `CLAUDE.md`, `WORKFLOW.md`, `.claude/index.md`, `.claude/skills/*.md`, `.claudeignore`, `.gitignore`
- Create discussions and research documents in `.context/discussions/`

### Analytics Architect mode

Triggered by **`/architect`** (with any continuation or none).

In this mode you:

- Discuss the hypothesis, method and expected result of an analysis
- **Before proposing a method — check `.context/findings.md`**: does the new hypothesis contradict
  an already recorded finding? If there is overlap — name it explicitly
- Ask clarifying questions before proposing solutions
- Record scope/methodology decisions in `.context/decisions.md`
- At the end of the discussion write a plan in `.context/plan.md` (format below)
- Do not write code — only design and plan

**`.context/plan.md` format:**

````markdown
## Analysis: {verb + noun, specific}

### Question
{what business/analytical question this analysis answers}

### Hypothesis
{what we expect to see and why}

### Related findings
{links to FINDING-XXX from findings.md that this confirms, refines, or may contradict — or "—"}

### Data & filters
{which data slice, which filters, time period}
Depends on: {already prepared data/features in src/ — or "—"}

### Method
{which test/model, why — with reference to methodology.md}

### Files
Create:
- {path to notebook, e.g. notebooks/NN-short-name.ipynb}

Edit:
- {path} — {what to change, e.g. add function to src/}

### Constraints
- Obvious data issue directly on the path (missing values, duplicates, target leakage) → fix it,
  document in "Changes along the way". If it changes methodology — also add to decisions.md.
- Non-obvious change to scope or methodology → stop. Describe options, wait for owner's choice.
- {explicit prohibition}

### Verification
- {automatable criterion — e.g. notebook executes end-to-end without errors and saved with outputs}

### Changes along the way
- {what was changed outside scope} — {why}
````

**Good plan rules:**

- One plan — one coherent analysis. Covers more than three hypotheses — suggest splitting.
- Explicit dependencies. If the analysis depends on data/features not yet prepared — mark as blocker.
- Constraints over wishes. One hard prohibition beats three soft "preferably".
- Verification must be automatable: notebook executes without errors (`jupyter nbconvert --execute`),
  numbers in markdown cells match actual code output.

### Analyst mode

Triggered by **`/analyze`**.

In this mode you:

- If the analysis is experimental (not yet ready for `main`) — create an `experiment/<task-name>`
  branch; otherwise work directly in `main`
- Read `.context/plan.md` and implement it
- Use shared functions from `src/` instead of duplicating logic between notebooks — if the needed
  function does not exist, add it to `src/`, do not duplicate logic in the notebook
- Stay within the plan scope — do not expand independently
- If you encounter uncertainty — stop and ask
- Execute the notebook end-to-end before considering the task done — verify that numbers in
  markdown cells match actual code output
- After completion propose: `/record-finding`

**Analyst mode main rule:**
If a problem outside the plan scope is found during analysis — two paths:

- **Obvious data issue directly on the path** (missing values, duplicates, target leakage) → fix
  it, document in `### Changes along the way` in `plan.md`. If it changes the standard filter or
  methodology — also add to `decisions.md`.
- **Non-obvious change to scope or methodology** → stop. Describe the problem and options, wait for
  owner's choice.

---

## Slash commands

| Command | Action |
| --- | --- |
| `/brainstorm [topic]` | Switch to Brainstorm mode — explore the analytical question before designing |
| `/brainstorm done` | End brainstorm session — save discussion, fill context documents |
| `/organize` | Switch to Organizer mode |
| `/architect` | Switch to Analytics Architect mode |
| `/next` | Architect mode: first incomplete item from `.context/to-do.md` |
| `/record` | Add decision to `.context/decisions.md` |
| `/analyze` | Switch to Analyst mode — implement `.context/plan.md` |
| `/record-finding` | Record finding to `.context/findings.md` |
| `/snapshot` | Archive and write new `.context/status.md` |
| `/report` | Generate markdown analytical report → `outputs/report-{date}.md` |
| `/present jupyter` | Generate presentation notebook → `outputs/presentation.ipynb` |
| `/present html` | Export presentation to HTML slides → `outputs/presentation.html` |
| `/close` | Merge `experiment/*` branch into `main` (ff-only) |
| `/retro` | Retrospective: analyse history → discussion file → actions |
| `/commit` | Show diff → confirm → commit |

---

## Key analysis rules

{ANALYSIS_RULES}
{Example:}
{**1. Always check findings across key segments before generalising.**}
{If the data has natural segmentation (e.g. internal risk score, cohort, channel) — a finding on}
{the full sample may not reproduce or may reverse within a segment. Before recording as "confirmed"}
{in findings.md — check on at least 2–3 slices.}

{**2. Be cautious with post-hoc features.**}
{If a feature is computed after the event being analysed (e.g. after the decision the analysis}
{is trying to improve) — it may partially "know" the outcome. Mark such features in blueprint.md}
{and check for leakage separately.}

{**3. Before trusting a finding on the last N periods — check for censoring.**}
{Recent data may be structurally incomplete (the target variable has not yet resolved).}

{Add rules specific to your domain.}

---

## Branching conventions

- Model: `main` / `experiment/<name>` / `hotfix/<name>`
- All regular analyses — directly in `main`
- `experiment/<name>` — only for hypotheses not yet ready for `main` (risky exploration)
- Merges only via ff-only — rebase onto `main` before merging
- `experiment/*` → `main` (via `/close`)
- `hotfix/*` → `main` (via `/close`), then rebase manually if needed
- CC never does `git push` without explicit request

---

## Environment and commands

{RUNTIME_SETUP}

| Command | Purpose |
| --- | --- |
| `uv sync` | Install dependencies |
| `uv run jupyter nbconvert --to notebook --execute --inplace notebooks/NN-*.ipynb` | Execute notebook and verify it does not fail |
| `uv run pytest` | Run tests for `src/` |

---

## Notebook conventions

- Naming: `notebooks/NN-short-name.ipynb` where `NN` is a sequence number (`01`, `02`, ...)
- One notebook — one coherent analysis (corresponds to one `plan.md`)
- Each notebook must be self-contained: explicitly declares data sources and filters at the top,
  does not rely on state from other notebooks
- Before committing: execute end-to-end (`Restart & Run All` / `nbconvert --execute`) and verify
  that numbers in markdown cells match actual code output

---

## Code conventions

{CODE_CONVENTIONS}
{Example:}
{- Reusable logic (data loading, standard filter, statistical tests, feature engineering)}
{  — in `src/` only, do not duplicate between notebooks}
{- Commits: `type: description` — types: analysis, finding, fix, refactor, docs, chore}

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
{- `DATA_SOURCE_PATH` — path or connection string to data source}

---

## Project structure

```text
{PROJECT_STRUCTURE}
notebooks/
  NN-short-name.ipynb
src/
  analysis_utils.py   ← reusable functions: loading, filters, tests, models
  {module}.py
data/
  README.md           ← where to get data, versions, provenance (data files — NOT in git)
outputs/
  report-{date}.md    ← analytical report (/report)
  presentation.ipynb  ← presentation notebook (/present jupyter)
  presentation.html   ← HTML slides (/present html)
.claude/
  index.md
  skills/
    meta/    ← workflow
    project/ ← technical project conventions (if needed)
.context/
  blueprint.md / methodology.md / findings.md / status.md
  to-do.md / plan.md / decisions.md
  history/     ← status.md archive
  discussions/ ← discussions and research
  notes/       ← personal notes, not committed
```

---

## Current state

Current state — in `.context/status.md`.
Current findings and their status — in `.context/findings.md`.
