# analytics-workflow-template — Setup guide

This template brings Claude Code workflow structure to your new analytics project.
Designed for solo analysts working with notebooks, empirical findings, and statistical methodology.

---

## Prerequisites

### Claude Code

If Claude Code is not yet installed:

1. Install [Node.js](https://nodejs.org) (LTS)
2. Install Claude Code:

   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

3. Authorize — run `claude` and follow the instructions
4. Verify: `claude --version`

### Python environment

The template uses [uv](https://docs.astral.sh/uv/) for Python dependency management.
If `uv` is not yet installed:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## Install via curl

```bash
mkdir my-analysis && cd my-analysis
git init
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/analytics/scripts/install.sh | bash
```

The script will interactively ask for a project name and remote URL, download the template,
and set up your Python environment.

---

## Uninstall

To remove the assistant from a project:

```bash
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/analytics/scripts/uninstall.sh | bash
```

The script removes the assistant files and cleans up related entries from `.gitignore` and
`.git/info/exclude`. No commit is created — stage and commit the changes manually.

---

## Getting started with CC

After setup:

1. Install dependencies:

   ```bash
   uv sync
   ```

2. Open notebooks in your preferred environment — VS Code (Jupyter extension), Jupyter Lab,
   or any Jupyter-compatible IDE.

   Keep the notebook IDE and CC open in parallel: the IDE for computation, CC for planning
   and recording findings.

3. Open CC and say:

   ```text
   Read CLAUDE.md and help me fill in the remaining placeholders.
   ```

4. Start your first analysis session in CC:

   ```text
   /brainstorm <your analytical question>
   ```

---

## What the template includes

After installation your project will contain:

```text
CLAUDE.md                          ← CC instructions (with placeholders → fill in with CC)
WORKFLOW.md                        ← workflow quick reference
pyproject.toml                     ← Python dependencies (uv)
.claude/
  index.md                         ← CC documentation map
  skills/
    meta/
      cc-commit.md                 ← /commit skill
      cc-close-task.md             ← /close skill (experiment/* → main)
      cc-status-report.md          ← /snapshot skill
      cc-finding-sync.md           ← /sync skill
      cc-record-finding.md         ← /record-finding skill
      cc-report.md                 ← /report skill
      cc-present.md                ← /present skill

.context/
  blueprint.md                     ← data schema and pipeline
  methodology.md                   ← statistical conventions
  findings.md                      ← empirical findings registry
  plan.md                          ← current analysis task
  to-do.md                         ← task queue
  status.md                        ← what has been analysed
  decisions.md                     ← scope and methodology decisions
  history/                         ← status.md archive
  discussions/                     ← discussions and research
  notes/                           ← personal notes (not committed)

data/
  README.md                        ← data provenance (data files not in git)
notebooks/
  README.md                        ← naming conventions and notebook index
src/
  analysis_utils.py                ← reusable statistical functions
outputs/                           ← exported reports and presentations
```

---

## Want to improve the template?

Work directly in this repo (`analytics` branch) — it has its own `CLAUDE.md` with maintainer
instructions. See `CONTRIBUTION.md` for details.
