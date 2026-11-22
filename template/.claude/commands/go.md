Run the whole task end to end without stopping: plan → implement → polish → verify →
commit → close.

`/go` is the owner's explicit permission to chain `/commit`, `/dev`, `/polish`,
`/commit` and `/close` in one run (`CLAUDE.md` → Skill boundaries). Decisions are
taken in the discussion before `/go`; the owner waits for the finished result, not
for questions.

$ARGUMENTS

## Algorithm

1. **Branch.** If on `main` or `dev`, create `feature/<name>` from `dev`, picking the
   name from the task. If already on `feature/*` or `hotfix/*`, stay on it.
2. **Plan.** If `.context/plan.md` is absent, write it from the discussion, in the
   Architect format (`CLAUDE.md` → Architect mode). Commit it:
   `docs: add plan for <task>`.
3. **Implement.** Follow `.claude/commands/dev.md` with two exceptions: the decision
   rule below replaces "stop and ask", and after implementation go on to step 4
   instead of reporting. Write tests for new code.
4. **Polish.** Run the algorithm of `.claude/skills/meta/cc-code-polish.md` on the
   feature diff. Apply every finding you would recommend; skip the rest. No per-item
   confirmation.
5. **Verify.** Run every item of `### Verification` in `plan.md` that can run here,
   plus the project checks for the touched parts (`CLAUDE.md` → Environment and
   commands: tests, linters, type checks). Fix failures and rerun until green. Items
   that need the owner or an external environment – list them as not run, with the
   reason.
6. **Commit.** Follow `.claude/skills/meta/cc-commit.md` without the confirmation
   steps: include `plan.md`, split by type, task reference and `Why:` as usual.
7. **Close.** Run `.claude/skills/meta/cc-close-task.md`: clean `plan.md`, rebase,
   ff-merge into the target branch, delete the feature branch. No push.
8. **Report** (format below).

## Decision rule – forks the discussion did not cover

Do not stop. Take the option you would recommend, record it in
`### Changes along the way` in `plan.md` (and an ADR if it passes the `/record`
checklist), and list it in the report under "Decided without you", so the owner can
review it in the merged history.

## Hard stops – `/go` does not lift these

Stop, describe the problem and options, wait for the owner:

- owner-only steps: `git push`, merge `dev` → `main`, release tags, external consoles
  and accounts;
- deploy and anything that reads or writes production or real user data;
- a conflict with an accepted ADR or the agreed project scope;
- failing tests or checks that cannot be fixed within the task. Never disable, skip
  or weaken a test or check to get through;
- a rebase conflict in `/close`;
- an action that is destructive or hard to reverse outside the feature branch.

## Report

In the communication language (`CLAUDE.md` → Language), by
`.claude/technical-text-style.md` when the language is Russian:

- what was done, with the branch and the commits merged into `dev`;
- verification: what ran and passed, what was not run and why;
- "Decided without you" – decisions taken by the rule above, or "none";
- what remains for the owner: push, release, steps outside this machine.
