# artifacts

Three classes of `.context/` artifacts by lifecycle:

- **Project-wide** – live on all branches, sync through merges: `blueprint.md`,
  `status.md`, `to-do.md`, `decisions.md`, `discussions/`, `history/decisions/`,
  `history/retros/`, plus `.claude/`, `CLAUDE.md`, `WORKFLOW.md`.
- **Task-local** – exist only on `feature/*`, deleted by `/close` before merge:
  `plan.md`.
- **Private** – not in git, per-developer only: `notes/`.

If in doubt about a new artifact – decide its class first, then place it. Presence of
`plan.md` on `main`/`dev` is a scope violation.
