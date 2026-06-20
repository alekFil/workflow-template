# WORKFLOW.md — Claude Code Quick Reference

This file is a quick reference for the project owner.
Full instructions for CC — in `CLAUDE.md`. Skill details — in `.claude/skills/meta/`.

---

## Modes and slash commands

| Command | Mode | What happens |
| --- | --- | --- |
| `/organize` | Organizer | Discuss workflows, edit `.claude/index.md` and skills |
| `/architect` | Architect | Discuss architecture → plan in `.context/plan.md` |
| `/next` | Architect | First incomplete item from `.context/to-do.md` |
| `/dev` | Developer | Reads `.context/plan.md`, creates branch, writes code |
| `/record` | — | Adds ADR to `.context/decisions.md` |

---

## Workflow commands

| Command | Skill | What happens |
| --- | --- | --- |
| `/commit` | `cc-commit.md` | Shows diff → waits for confirmation → commits |
| `/close` | `cc-close-task.md` | Rebase + ff-merge into `dev`, deletes branch |
| `/status` | `cc-status-report.md` | Archives old `status.md`, writes new one |
| `/sync` | `cc-architect-sync.md` | Compares code with documentation, suggests changes |

---

## Branches

```text
main          ← releases (dev → main manually)
  └── dev     ← integration
        └── feature/<name>   ← all work goes here
        └── hotfix/<name>    ← urgent fixes → main
```

CC **never does `git push`** without explicit request.

---

## Typical workday

```text
0. Session start — CC reads automatically:
   .context/blueprint.md → .context/to-do.md → .context/status.md

1. Pick a task
   → /next
   CC reads to-do.md, suggests first incomplete item

2. Discuss
   → /architect
   CC asks questions, records decisions, writes .context/plan.md
   To record an architecture decision: /record

3. Implement
   → /dev
   CC creates branch feature/..., reads plan.md, writes code + tests

4. During work — commits
   → /commit
   CC shows what will be included, waits for confirmation, commits

5. Task done
   → /close
   CC does rebase + ff-merge into dev, deletes branch

6. Every few tasks — sync documentation
   → /status   (update status.md)
   → /sync     (check blueprint / code divergence)
```

---

## Commits

Format: `type: description`

| Type | When |
| --- | --- |
| `feat:` | new functional code |
| `fix:` | bug fix |
| `docs:` | documentation only |
| `refactor:` | refactoring without behavior change |
| `test:` | tests |
| `chore:` | infrastructure, configuration, dependencies |

---

## Project documentation

| File | Purpose |
| --- | --- |
| `CLAUDE.md` | Instructions for CC (read by CC, do not edit manually) |
| `.context/blueprint.md` | Project architecture |
| `.context/to-do.md` | Task queue |
| `.context/plan.md` | Current task |
| `.context/status.md` | Current implementation state |
| `.context/decisions.md` | Architecture decision history |
| `.context/notes/` | Owner's personal notes — not committed, CC does not read |
