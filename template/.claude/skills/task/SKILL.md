---
name: task
description: "Add a task card to the backlog, or reject an existing one with a reason. Use when the owner types /task or asks to add something to the backlog or to-do list."
argument-hint: "[title | reject <slug> <reason>]"
---

# /task

Manage task cards in `TASKS_DIR` (`.claude/workflow.conf`). Card format –
`.claude/rules/artifacts.md`.

$ARGUMENTS

## Add a card

1. Run `.claude/scripts/workflow.sh tasks --all` and check that the task is not
   already open or rejected. If it was rejected – show the reason and ask.
2. Pick a slug: short, lowercase `a-z0-9-`, unique in `TASKS_DIR`.
3. Ask for the priority if the owner did not give one; default – after the last
   open card.
4. Write `<TASKS_DIR>/<slug>.md` with `status: next`, the title and a short
   description: what and why. No plan – the plan comes from `/architect`.
5. Report the path. Do not commit (`.claude/rules/skill-boundaries.md`).

## Reject a card

Set `status: rejected` and add a `## Reason` section with one or two sentences. The
card stays, so the idea is not proposed again.
