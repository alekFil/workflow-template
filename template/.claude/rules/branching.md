# branching

- Model: `main` / `dev` / `feature/<name>` / `hotfix/<name>`
- Merges only via ff-only – rebase onto target branch before merging
- `feature/*` → `dev` (automatically via `/close`)
- `hotfix/*` → `main` (automatically via `/close`), then `dev` is rebased manually
- `dev` → `main` – manually only, release decision
- The agent never does `git push` without explicit request
