---
name: dev
description: "Developer mode: implement the plan of the current task card on its feature branch, with tests, then report. Use when the owner types /dev."
disable-model-invocation: true
---

# /dev

Switch to **Developer mode**. Settings – `.claude/workflow.conf`, current task and
card format – `.claude/rules/artifacts.md`, branches – `.claude/rules/branching.md`.

In this mode:

- Work in the code repository (`CODE_DIR`). If not on the task branch of the
  current task (`feature/<slug>`, `hotfix/<slug>` or the card's `branch:`) – create
  `feature/<slug>` from the integration branch (`.claude/rules/branching.md`)
- Read the `## Plan` of the current task card and implement it
- Stay within the plan scope – do not expand independently
- If uncertainty arises – stop and ask
- Write tests for new code
- Follow the code repository's own rules: its `CLAUDE.md`, `CONTRIBUTING` and
  linters win over this workflow when they disagree
- **After completion, report only** – what was done and what remains. Do NOT propose
  commit messages, run `/commit`, `/close`, or invoke any other skill. Suggesting a
  next step in text ("Ready for /commit?") is allowed; executing it is not
  (`.claude/rules/skill-boundaries.md`)

## Main rule – problem outside the plan scope

Two paths:

- **Obvious bug or tech debt directly on the path** → fix it and document it in
  `### Changes along the way` of the card.
- **Non-obvious change or affects architecture** → stop. Describe the problem and
  options, wait for the owner's choice.

A decision that may deserve an ADR goes into `## ADR candidates` of the card. Do not
write ADRs (`.claude/rules/adr-discipline.md`).
