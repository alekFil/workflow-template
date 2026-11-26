---
name: architect
description: "Architect mode: discuss architecture and technical decisions, then write the task plan into the task card. Design only, no code. Use when the owner types /architect."
disable-model-invocation: true
argument-hint: "[topic]"
---

# /architect

Switch to **Architect mode**.

$ARGUMENTS

In this mode:

- Discuss architecture and technical decisions
- Ask clarifying questions before proposing solutions
- Check the task against the product boundary and non-goals in `PRODUCT_FILE`
  (`.claude/workflow.conf`). A task outside the boundary – say so and stop
- Write the plan into the task card at the end of the discussion
- Do not write code – design and plan only
- Do not write ADRs. A decision that may deserve one goes into `## ADR candidates`
  of the card; the owner records it with `/record`

## The task card

Task cards and the current task – `.claude/rules/artifacts.md`.

- If the discussion is about an existing card – use it.
- If there is no card – create `<TASKS_DIR>/<slug>.md` with `status: next`.
- Discussion without a plan (exploration, clarification) needs no card.

## Branch check (before writing the plan)

The plan is written on the task branch of the code repository (`CODE_DIR`), named
`feature/<slug>` after the card. Branch rules – `.claude/rules/branching.md`.

- On `feature/<slug>` or `hotfix/<slug>` – proceed.
- On the integration or main branch – ask: "Create `feature/<slug>`?" Do not create
  the branch automatically.
- Devmeta profile (`CODE_DIR=code`): the card and its plan live in the context
  repository on its single `main` branch; the branch check applies to `code/`.

## Plan format

Add to the card, set `status: in-progress`:

````markdown
## Plan

### Context
{what this component is, why it's needed}
Depends on: {list of already-implemented components or "–"}

### What to implement
1. {atomic unit of work}
2. {atomic unit of work}

### Files
Create:
- {path}

Edit:
- {path} – {what to change}

### Constraints
- Obvious bug or tech debt directly on the path: fix and document in "Changes along the way".
- Non-obvious or affects architecture: stop, describe options, wait for owner's choice.
- {explicit prohibition}

### Verification
- {automatable criterion – command or specific result}

### Changes along the way
- {what was changed outside scope} – {why}

## ADR candidates
- {decision that may deserve an ADR, or remove the section}
````

## Good plan rules

- One plan – one coherent task. Touches more than three components – suggest
  splitting into several cards.
- Explicit dependencies. If a task depends on something unimplemented – mark it as a
  blocker.
- Constraints over wishes. One hard prohibition beats three soft "preferably".
- Verification must be automatable. "pytest passes" – good. "code is readable" – bad.

## After writing the plan

Remind the owner, as text only:

> Plan written to `<card>`. Run `/commit` before `/dev` so the plan travels with the
> branch – reviewers see it alongside the implementation.

Do not invoke `/commit` automatically (`.claude/rules/skill-boundaries.md`).
