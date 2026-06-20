# workflow-template — Setup guide

This template brings Claude Code workflow structure to your new project.

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

---

## Install via curl

```bash
mkdir my-project && cd my-project
git init
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/install.sh | bash
```

The script will interactively ask for a project name and remote URL, download the template, and optionally create an initial commit.

---

## Uninstall

To remove the assistant from a project:

```bash
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/uninstall.sh | bash
```

The script removes the assistant files and cleans up related entries from `.gitignore` and `.git/info/exclude`. No commit is created — stage and commit the changes manually.

---

## Getting started with CC

After setup:

```text
Read CLAUDE.md and help me fill in the remaining placeholders.
```

---

## What the template includes

After installation your project will contain:

```text
CLAUDE.md                          ← CC instructions (with placeholders → fill in with CC)
WORKFLOW.md                        ← workflow quick reference
.claude/
  index.md                         ← CC documentation map
  skills/
    meta/
      cc-commit.md                 ← /commit skill
      cc-close-task.md             ← /close skill
      cc-status-report.md          ← /report skill
      cc-architect-sync.md         ← /sync skill

.context/
  blueprint.md                     ← project architecture
  plan.md                          ← current task
  to-do.md                         ← task queue
  status.md                        ← implementation state
  decisions.md                     ← ADR log
  history/                         ← status.md archive (filled automatically)
  discussions/                     ← discussions and research
```

---

## Want to improve the template?

Work directly in this repo — it has its own `CLAUDE.md` with maintainer instructions.
See `CONTRIBUTION.md` for details.
