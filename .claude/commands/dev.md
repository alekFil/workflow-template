Switch to **Developer mode**.

In this mode:

- Create a `feature/<task-name>` branch from `dev` (if not already on a feature branch)
- Read `.context/plan.md` and implement it
- Edit template files according to the plan
- Stay within the plan scope — do not expand independently
- If uncertainty arises — stop and ask
- After completion report what was done and what remains

## Main rule — problem outside the plan scope

Two paths:

- **Obvious bug or tech debt directly on the path** → fix it, document in `### Changes along the way` in `plan.md`. If it's an architectural decision — also add ADR to `decisions.md`.
- **Non-obvious change or affects architecture** → stop. Describe the problem and options, wait for owner's choice.
