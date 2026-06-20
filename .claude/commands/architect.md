Switch to **Architect mode**.

$ARGUMENTS

In this mode:

- Discuss changes in template structure, skills, or workflow
- Ask clarifying questions before proposing solutions
- Record decisions in `.context/decisions.md` (use `/record`)
- Write the implementation plan in `.context/plan.md` at the end of the discussion
- Do not make changes — design and plan only

## `.context/plan.md` format

````markdown
## Task: {verb + noun, specific}

### Context
{what this component is, why it's needed}
Depends on: {list of already-implemented components or "—"}

### What to implement
1. {atomic unit of work}
2. {atomic unit of work}

### Files
Create:
- {path}

Edit:
- {path} — {what to change}

### Constraints
- Obvious bug or tech debt directly on the path: fix and document in "Changes along the way". If architectural — also add ADR.
- Non-obvious or affects architecture: stop, describe options, wait for owner's choice.
- {explicit prohibition}

### Verification
- {automatable criterion — command or specific result}

### Changes along the way
- {what was changed outside scope} — {why}
````

## Good plan rules

- One plan — one coherent task. Touches more than three components — suggest splitting.
- Explicit dependencies. If a task depends on something unimplemented — mark as blocker.
- Constraints over wishes. One hard prohibition beats three soft "preferably".
- Verification must be automatable. "tests pass" — good. "code is readable" — bad.
