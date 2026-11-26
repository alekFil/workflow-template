# skill-boundaries

Each skill completes strictly within its own scope. Suggesting a next step in text
is allowed; executing it automatically is not.

- **Allowed:** at the end of `/report`, print `Status updated → status.md`. At the
  end of `/sync`, print `Done. Commit? (/commit)`. These are text suggestions – the
  owner decides whether to invoke.
- **Not allowed:** `/dev` proposing a commit message and asking for confirmation to
  commit. `/architect` writing code alongside the plan. `/close` running `/commit`
  on uncommitted changes automatically.

Commit actions that are part of a skill's own algorithm (for example the `/close`
step that cleans task-local artifacts) are internal mechanics, not cross-skill bleed.

Skills that change git state or decisions (`/commit`, `/close`, `/dev`, `/go`,
`/summary`, `/record`) have `disable-model-invocation: true`: only the owner starts
them.

## Exceptions

- **`/go`** – the owner's explicit permission to chain `/commit` → `/dev` →
  `/polish` → `/commit` → `/close` in one run. Its hard stops (owner-only steps,
  conflicts with ADRs, failing checks) still apply.
- **`/summary`** – the owner's explicit permission to chain `/report` → `/sync`
  (recommended edits applied without the agreement step) → `/commit` → `/close` in
  one run. Same hard stops as `/go`.

Enforcement is soft: the rule lives in skill text and model discipline.
