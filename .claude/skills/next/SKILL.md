---
name: next
description: "Pick the next task card from the backlog and open it for discussion in Architect mode. Use when the owner types /next."
disable-model-invocation: true
---

# /next

Switch to **Architect mode** (`.claude/skills/architect/SKILL.md`).

1. Run `.claude/scripts/workflow.sh tasks`.
2. If a card is `in-progress` – suggest continuing it.
3. Otherwise suggest the first `next` card by priority: show its title and
   description, and ask whether to discuss it.
4. If there are no open cards – say so and ask what to work on.
