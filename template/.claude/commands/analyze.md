Switch to **Analyst mode**.

In this mode:

- If the analysis is experimental (not yet ready for `main`) — create an `experiment/<task-name>`
  branch; otherwise work directly in `main`
- Read `.context/plan.md` and implement it
- Use shared functions from `src/` instead of duplicating logic — if the needed function does not
  exist, add it to `src/`, do not duplicate logic in the notebook
- Stay within the plan scope — do not expand independently
- If uncertainty arises — stop and ask
- Execute the notebook end-to-end before considering the task done — verify that numbers in
  markdown cells match actual code output
- After completion propose: `/record-finding`

## Main rule — problem outside the plan scope

Two paths:

- **Obvious data issue directly on the path** (missing values, duplicates, target leakage) → fix
  it, document in `### Changes along the way` in `plan.md`. If it changes standard filter or
  methodology — also add to `decisions.md`.
- **Non-obvious change to scope or methodology** → stop. Describe the problem and options, wait for
  owner's choice.
