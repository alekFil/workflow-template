---
name: sync
description: "Compare the code with the documentation and propose concrete edits, applied only after agreement. Use when the owner asks to sync docs or update the blueprint, or types /sync."
---

# Architecture sync

Compares the current implementation with the documentation and produces proposed
changes – **without making edits independently**. Edits are made only after explicit
agreement with the owner.

Settings – `.claude/workflow.conf`; classes of shared text –
`.claude/rules/artifacts.md`.

## Algorithm

### 1. Read the current context

- `PRODUCT_FILE` – what the product is, its boundary and non-goals
- `.context/blueprint.md` – how the system is built
- `.context/status.md` – current implementation state
- open task cards: `.claude/scripts/workflow.sh tasks`
- `<DECISIONS_DIR>/README.md` – active decisions
- `.claude/rules/*.md` – workflow rules and technical conventions
- `CLAUDE.md` – entry file

If `.context/status.md` is missing or older than the last commit of the code
repository – report: "No current status.md. First run: `/report`".

### 2. Analyze divergences

**blueprint.md:**

- Sections where the implementation differs from the description
- Outdated parts (describe something that was abandoned)
- Text that belongs elsewhere: purpose and principles → `PRODUCT_FILE`, list of
  implemented features → `status.md`, ADR summaries → the generated index

**PRODUCT_FILE:**

- Implemented features that cross the product boundary or a non-goal – report them
  as questions for the owner, never edit the product file to match the code

**Task cards:**

- Open cards whose work is already in the code – propose `/close` or an update
- Cards without a `## Plan` that are `in-progress` – propose fixing the status

**Decisions:**

- Decisions taken in the code that may deserve an ADR – list them as ADR
  candidates. Do not write ADRs (`.claude/rules/adr-discipline.md`)
- ADRs that the code contradicts – questions for the owner
- `<DECISIONS_DIR>/README.md` out of date – propose
  `.claude/scripts/workflow.sh adr-index`

**`.claude/rules/*.md`:**

- Instructions that don't match the actual code (libraries, patterns, paths)
- New recurring patterns worth capturing as a rule
- Outdated instructions

**CLAUDE.md:**

- `Components` section: new or renamed top-level component; entry outdated relative
  to actual purpose
- Links to non-existent files

### 3. Produce proposals

Concrete changes – not "needs updating", but exactly what to change:

```text
## Sync proposals

### .context/blueprint.md
- Section 3.5: replace "{old text}" with "{new text}"
  Reason: implementation uses X, not Y

### .claude/rules/new-git-check.md
- In step 2 replace path "checks/base.py" with "checks/_base.py"
  Reason: the actual file has a different name

### ADR candidates
- {decision} – {why it may pass the checklist}
```

### 4. Ask questions about uncertainties

From "Questions and uncertainties" in `status.md`, extract those that require an
architectural or product decision:

```text
## Questions for the architect

1. {specific question}
   Context: {why it arose, what was already tried}
```

### 5. Wait for agreement

After the proposals – stop. Wait for explicit confirmation: "accepted", "apply" or
clarifications per item.

### 6. After agreement – apply changes

Apply the confirmed changes and report: "Done. Commit? (`/commit`)"

## Principles

**Blueprint reflects reality, not plans.** If the implementation has intentionally
diverged from the documentation – update the documentation. If the divergence is
accidental – record it and plan to fix the implementation.

**The product file is the owner's.** A conflict between the code and the product
boundary is a question, not an edit.

**Rules must match the actual code.** A divergence between a rule and the
implementation is always an error. One of them is wrong.
