# artifacts

Settings referenced below – `.claude/workflow.conf`.

## Three classes of shared text

Text that several branches edit is a source of merge conflicts. Every shared file
belongs to one class:

| Class | Files | Rule |
| --- | --- | --- |
| Entity collections | ADRs, task cards, retros, discussions | one file per entity; any index is generated |
| Derived state | `.context/status.md`, `<DECISIONS_DIR>/README.md` | generated only; on conflict regenerate, never merge by hand |
| Curated singletons | `<PRODUCT_FILE>`, `.context/blueprint.md`, `CLAUDE.md`, `WORKFLOW.md` | edited rarely and on purpose; the agent proposes edits and applies them only after the owner agrees |

`.context/status.md` is not committed (`.gitignore`): `/report` regenerates it.

## Where things live

- `<PRODUCT_FILE>` – what the product is and why: purpose, users, principles,
  non-goals, product boundary. Only the owner edits it.
- `<DECISIONS_DIR>/` – ADRs, one file each, and the generated `README.md` index.
- `<TASKS_DIR>/<slug>.md` – task cards.
- `.context/blueprint.md` – how the system is built: components, flows, data,
  infrastructure. No purpose, no ADR table, no list of implemented features.
- `.context/discussions/` – team discussions between people.
- `.context/history/retros/YYYY-MM-DD.md` – output of `/retro`.
- `.context/notes/` – private, not in git: drafts of the owner's dialogues with the
  agent.

## Task cards

A card is a file `<TASKS_DIR>/<slug>.md`. The slug is lowercase `a-z0-9-` and is also
the branch name: `feature/<slug>`.

```markdown
---
title: "Add folder permissions"
status: next
priority: 2
created: 2026-11-26
---

# Add folder permissions

What and why, in a few sentences.
```

- `status`: `next`, `in-progress` or `rejected`. Lower `priority` goes first.
- `/architect` adds the `## Plan` section to the card and sets `in-progress`.
- `/close` deletes the card of a finished task. The deleting commit carries the
  trailer `Closes-Task: <slug>`, so the history of done tasks is
  `.claude/scripts/workflow.sh done`. There is no list of done tasks in files.
- Implementation commits carry the trailer `Task: <slug>`, so
  `git log --grep "Task: <slug>"` shows the whole task. Exception: in devmeta
  profiles code commits carry no workflow trailers – the context repository commit
  of `/close` lists the code commits instead.
- A rejected card stays, with `status: rejected` and a `## Reason` section, so the
  idea is not proposed again. An architectural rejection is an ADR instead.
- Open tasks: `.claude/scripts/workflow.sh tasks`.

**Current task** – the card whose slug matches the current branch of the code
repository (`feature/<slug>`, `hotfix/<slug>`). If no card matches, the single card
with `status: in-progress`; if there are several, ask.

The `## Plan` section is task-local: it exists only while the task is open and goes
away with the card.
