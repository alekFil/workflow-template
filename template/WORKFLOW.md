# WORKFLOW.md — Claude Code Quick Reference

This file is a quick reference for the project owner.
Full instructions for CC — in `CLAUDE.md`. Skill details — in `.claude/skills/meta/`.

---

## Slash commands

Type `/command` directly in the Claude Code prompt. Each command is defined by a file in `.claude/commands/`.

| Command | What happens |
| --- | --- |
| `/organize` | Switch to Organizer mode — discuss workflows, edit `.claude/index.md` and skills |
| `/architect` | Switch to Architect mode — discuss architecture → write `.context/plan.md` |
| `/next` | Architect mode: suggest first incomplete item from `.context/to-do.md` |
| `/dev` | Switch to Developer mode — read `.context/plan.md`, create branch, write code |
| `/record` | Add ADR to `.context/decisions.md` |
| `/commit` | Show diff → wait for confirmation → commit |
| `/close` | Rebase + ff-merge into `dev`, delete branch |
| `/report` | Archive old `status.md`, write new one |
| `/sync` | Compare code with documentation, suggest changes |

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
   → /report  (update status.md)
   → /sync    (check blueprint / code divergence)
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
