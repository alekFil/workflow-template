# adr-discipline

Two levels of artifacts:

- **ADR** – `.context/decisions.md`, curated architectural decisions. Passes a 4-point
  checklist.
- **Commit messages** – everything else: tactical fixes, renames, cleanup. No separate
  operational file.

Checklist for `/record` (all four must be "yes"; otherwise write a commit with a `Why:`
section):

1. Alternatives considered with substantive analysis. For "do / don't do" decisions –
   reason why this option over the opposite.
2. Explicit trade-off between alternatives.
3. Decision shapes product or process behavior over ≥ 6 months.
4. A reader six months from now, without context, will benefit from knowing *why*, not
   *what*.

**Archival.** Superseded and rejected ADRs live in
`.context/history/decisions/<year>.md` (year = year the ADR was written). Triggers:

- **X (reactive):** `/record` moves the replaced ADR to archive at write time.
- **Y (periodic):** `/sync` catches orphan-rejected ADRs without explicit replacement.

**Reference convention:** `ADR-NNN (archived, see history/decisions/YYYY.md)`.
