---
name: record
description: "Record an architecture decision (ADR) as a file in the decisions directory, after the 4-point checklist. Only on the owner's explicit /record – never on the agent's own initiative."
disable-model-invocation: true
argument-hint: "[decision]"
---

# /record

Add a new ADR. Discipline, checklist and file format –
`.claude/rules/adr-discipline.md`. Settings – `.claude/workflow.conf`.

$ARGUMENTS

## Step 0 – Is this project keeping ADRs?

If `DECISIONS_DIR=none` – reply that ADRs are not kept in this project (contribution
to someone else's repository) and suggest a private note in `.context/notes/`
instead. Stop.

## Step 1 – Checklist (gatekeeper)

Answer the four points of the checklist. If any is "no" – this is a commit, not an
ADR. Reply with the failed point(s) and suggest a commit message with a `Why:`
section instead. Stop.

## Step 2 – Write the ADR

1. Pick the ID: today's date and a short slug – `YYYY-MM-DD-<slug>`. Check that the
   file does not exist.
2. Write `<DECISIONS_DIR>/<id>.md` in the format of the rule: frontmatter (`title`,
   `status: accepted`, `date`), sections Context, Decision, Alternatives,
   Consequences. Headings and text in the `.context/` language from `CLAUDE.md`.
3. If the ADR came from `## ADR candidates` of a task card – remove it from there.

## Step 3 – Handle replacement

If the new ADR replaces existing ones, in each replaced file:

- set `status: superseded` (or `rejected`);
- add `superseded-by: <new id>`.

The replaced ADR stays in place. Do not move it.

## Step 4 – Regenerate the index

```bash
.claude/scripts/workflow.sh adr-index
```

Report the new file and the replaced ones. Do not commit
(`.claude/rules/skill-boundaries.md`).
