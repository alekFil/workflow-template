# WORKFLOW.md — Claude Code Quick Reference

This file is a quick reference for the project owner.
Full instructions for CC — in `CLAUDE.md`. Skill details — in `.claude/skills/meta/`.

---

## Slash commands

Type `/command` directly in the Claude Code prompt. Each command is defined by a file in `.claude/commands/`.

| Command | What happens |
| --- | --- |
| `/organize` | Switch to Organizer mode — discuss workflows, edit `.claude/index.md` and skills |
| `/architect` | Switch to Analytics Architect mode — discuss hypothesis and method → write `.context/plan.md` |
| `/next` | Architect mode: suggest first incomplete item from `.context/to-do.md` |
| `/analyze` | Switch to Analyst mode — read `.context/plan.md`, write notebook, run analysis |
| `/record` | Add decision to `.context/decisions.md` |
| `/record-finding` | Record finding to `.context/findings.md` with status |
| `/snapshot` | Archive old `status.md`, write new one |
| `/report` | Generate markdown analytical report → `outputs/report-{date}.md` |
| `/present jupyter` | Generate presentation notebook → `outputs/presentation.ipynb` |
| `/present html` | Export presentation notebook to HTML slides → `outputs/presentation.html` |
| `/commit` | Show diff → wait for confirmation → commit |
| `/close` | Rebase + ff-merge `experiment/*` into `main`, delete branch |
| `/retro` | Analyse project history → write discussion → propose to-do and decision updates |

---

## Branches

```text
main                     ← all regular work: notebooks, findings, commits
  └── experiment/<name>  ← risky exploration not yet ready for main
  └── hotfix/<name>      ← urgent data/code fixes → main
```

CC **never does `git push`** without explicit request.

---

## Typical work cycle

```text
0. Session start — CC reads automatically:
   .context/blueprint.md → .context/findings.md → .context/to-do.md → .context/status.md

1. Pick a task
   → /next
   CC reads to-do.md, suggests first incomplete item

2. Discuss
   → /architect
   CC checks findings.md for overlap, asks questions about hypothesis and method,
   writes .context/plan.md
   To record a scope/methodology decision: /record

3. Analyse
   → /analyze
   CC reads plan.md, writes notebook, uses src/ for reusable logic
   Before calling task done: executes notebook end-to-end, verifies numbers match output

4. During work — commits
   → /commit
   CC shows what will be included, waits for confirmation, commits

5. Analysis done
   → /record-finding
   CC records finding to findings.md with status
   (⏳ requires verification / ✅ confirmed / ⚠️ refined / ❌ refuted)

6. Close branch (only if working in experiment/*)
   → /close
   CC does rebase + ff-merge into main, deletes branch

7. Every few tasks — update status
   → /snapshot  (update status.md)
   → /sync      (check if findings are still valid given current data)

8. Reporting
   → /report                (markdown summary for the record)
   → /present jupyter       (CC generates presentation notebook — edit manually before export)
   → /present html          (export to HTML slides via nbconvert)

9. Periodically — retrospective
   → /retro
   CC reads decisions, history, git log — presents analysis draft
   You correct → CC writes .context/discussions/retro-YYYY-MM-DD.md
   Proposes to-do and decision updates with per-item confirmation
```

---

## Commits

Format: `type: description`

| Type | When |
| --- | --- |
| `analysis:` | new notebook or substantial extension of analysis |
| `finding:` | change in `.context/findings.md` |
| `fix:` | data, feature, or code fix |
| `refactor:` | moving code to `src/`, refactoring without changing results |
| `docs:` | documentation only |
| `chore:` | infrastructure, configuration, dependencies |

---

## Project documentation

| File | Purpose |
| --- | --- |
| `CLAUDE.md` | Instructions for CC (read by CC, do not edit manually) |
| `.context/blueprint.md` | Data schema and preparation pipeline |
| `.context/methodology.md` | Statistical conventions and model standards |
| `.context/findings.md` | Analysis findings and their current status |
| `.context/to-do.md` | Task queue |
| `.context/plan.md` | Current task |
| `.context/status.md` | What has been analysed |
| `.context/decisions.md` | Scope and methodology decision history |
| `.context/notes/` | Owner's personal notes — not committed, CC does not read |
| `data/README.md` | Where to get data, versions, provenance |
| `notebooks/README.md` | Notebook naming conventions and index |
| `src/README.md` | What is in the reusable code |
| `outputs/README.md` | Purpose of the exports folder |
