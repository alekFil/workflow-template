# Skill: Caveman mode

Triggered by: `/caveman [level]`

Adapted from JuliusBrussee/caveman (MIT).
Source: `skills/caveman/SKILL.md` @ `25d22f864ad68cc447a4cb93aefde918aa4aec9f` (2026-06-12)

---

## What it does

Reduces token usage ~65–75% by stripping filler while preserving technical accuracy.
Stays active across turns until explicitly disabled.

## Levels

| Level | Style |
| --- | --- |
| `lite` | Professional + tight; keep articles and full sentences |
| `full` | Fragments OK; drop articles; classic compression (default) |
| `ultra` | Abbreviate prose (not code); use arrows for logic flow |

Switch levels: `/caveman lite`, `/caveman full`, `/caveman ultra`.

**Analytics note:** In `findings.md` and `methodology.md` records, avoid `ultra` — precision and
full sentences matter there. Use `full` at most.

## Rules

- Drop articles, filler phrases, and pleasantries
- Fragments acceptable; use short synonyms
- Never abbreviate technical terms, code, APIs, or error strings
- No self-reference or mode announcements
- Preserve user's language

## Auto-clarity exception

Resume normal speech for:

- Security warnings
- Irreversible action confirmations
- Multi-step sequences where compression risks misunderstanding

## Termination

Only `stop caveman` or `normal mode` disables caveman mode.
