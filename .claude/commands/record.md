Add a new ADR to `.context/decisions.md`.

## Step 1 — Checklist (gatekeeper)

Before writing an ADR, answer "yes" to all four points. If any is "no" — this is a commit, not an ADR. Reply with the failed point(s) and suggest a commit message with a "Why:" section instead.

1. **Alternatives considered with substantive analysis.** For "do / don't do" decisions — reason why this option was chosen over the opposite (analysis of both sides, not a declaration).
2. **Explicit trade-off between alternatives.** If one alternative is strictly better — it's a commit, not an ADR.
3. **Decision shapes product or process behavior over a long horizon** (≥ 6 months).
4. **A reader six months from now, without context, will benefit from knowing *why*, not *what*.**

## Step 2 — Handle replacement (trigger X)

If the new ADR replaces an existing one:

- Move the replaced ADR to `.context/history/decisions/<year>.md` (year = year the replaced ADR was written).
- Add a marker at the top of the moved ADR: `> Заменено ADR-N (YYYY-MM-DD) — см. .context/decisions.md`.
- Update references to the replaced ADR in the remaining active ADRs to the form: `ADR-NNN (archived, see history/decisions/YYYY.md)`.

## Step 3 — Write the ADR

Use the next sequential number after the last ADR in `.context/decisions.md`.

Format:

```markdown
## ADR-{N}: {Title}

**Статус:** Принято

**Контекст:** {what prompted the decision — problem or situation}

**Решение:** {what was decided and why}

**Последствия:** {what changes as a result}
```

Prepend the new ADR at the top of the file, above the existing entries.
