# workflow-template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet)](https://claude.ai/code)

A workflow template for projects using [Claude Code](https://claude.ai/code).

---

## Why

Without a template:

- You explain the project to CC from scratch every session: what it is, the stack, what's done
- You say "implement X" → CC writes code, even though you needed to discuss architecture first

With this template:

- CC reads `CLAUDE.md` on startup — knows the project, stack, conventions
- `/architect` → CC asks questions and writes a plan, doesn't touch code
- `/dev` → CC reads the plan and works strictly within it
- Decisions are recorded in `decisions.md` — persist across sessions

---

## Quick start

```bash
# 1. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Authorize (browser will open)
claude

# 3. Create project repository
mkdir my-project && cd my-project
git init

# 4. Install template
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/oss/scripts/install.sh | bash

# 5. Launch Claude Code
claude
```

First command after launch:

```text
Read CLAUDE.md and help me fill in the remaining placeholders.
```

Full instructions — in [SETUP.md](SETUP.md).

---

## What's included

- `CLAUDE.md` — instructions for CC: modes, slash commands, conventions
- `WORKFLOW.md` — workflow quick reference
- `.claude/skills/meta/` — meta-skills: `/commit`, `/close`, `/status`, `/sync`
- `.context/` — documentation structure: blueprint, plan, to-do, status, decisions
