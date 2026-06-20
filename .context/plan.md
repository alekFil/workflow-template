## Task: Add demo walkthrough and contributing section to README.md

### Context

Two remaining items from Priority 1 (OSS publication, to-do.md):
1. Demo session — show the core workflow `/architect` → `/dev` → `/commit` as a text walkthrough
2. Two-layer structure — explain maintainer vs template layers for contributors

The current README is user-facing and complete for end users. Two-layer structure is relevant
for contributors only → add a brief "Contributing" block with a link to CONTRIBUTION.md.

Depends on: previous README rewrite (done), ADR-018 (done).

### What to implement

1. Add `## Demo` section to `README.md` — conversational walkthrough of a typical session
2. Add `## Contributing` section to `README.md` — one paragraph, two-layer structure, link to `CONTRIBUTION.md`

### README.md — target additions

**Demo section** (insert before `## Quick start`):

```markdown
## Demo

You open a new project session and type:

/architect add CSV export for the reports page

CC asks clarifying questions — which data, which format, where the trigger lives.
You answer. CC writes `.context/plan.md`.

/dev

CC reads the plan and implements strictly within its scope — no improvisation.

/commit

CC shows the diff, you confirm, commit is created.

Decisions accumulate in `decisions.md` and persist across sessions.
```

**Contributing section** (append after `## Quick start`):

```markdown
## Contributing

This repo has two layers:

- **Root** (maintainer layer) — `CLAUDE.md`, `CONTRIBUTION.md`, `.context/`, `.claude/`, `scripts/`
- **`template/`** (template layer) — everything that gets installed into a new project via `install.sh`

See [CONTRIBUTION.md](CONTRIBUTION.md) for how to work with this repo.
```

### Files

Edit:
- `README.md` — insert Demo section before Quick start; append Contributing section at the end

### Constraints

- Text walkthrough only — no asciinema, no GIFs, no external services
- Demo scenario must be concrete but generic (not tied to any specific tech stack)
- Contributing section: one paragraph max, no duplication of CONTRIBUTION.md content
- Do not change existing sections (Why, What gets installed, How it works, Quick start)
- No placeholder text or TODO comments in the output

### Verification

- `grep -n "## Demo" README.md` — section exists
- `grep -n "## Contributing" README.md` — section exists
- `grep -n "two layers" README.md` — mentioned in Contributing
- `grep -n "CONTRIBUTION.md" README.md` — link present
- README sections order: Why → What gets installed → How it works → Demo → Quick start → Contributing

### Changes along the way

(none yet)
