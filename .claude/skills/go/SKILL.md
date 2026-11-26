---
name: go
description: "Run a discussed task end to end without stopping: plan, implement, polish, verify, commit, close. Only on the owner's explicit /go."
disable-model-invocation: true
argument-hint: "[task]"
---

# /go

Run the whole task end to end without stopping: plan → implement → polish → verify →
commit → close.

`/go` is the owner's explicit permission to chain `/commit`, `/dev`, `/polish`,
`/commit` and `/close` in one run (`.claude/rules/skill-boundaries.md`). Decisions are
taken in the discussion before `/go`; the owner waits for the finished result, not
for questions.

$ARGUMENTS

Settings – `.claude/workflow.conf`; cards – `.claude/rules/artifacts.md`; branches –
`.claude/rules/branching.md`.

## Algorithm

1. **Card.** Find the current task card. If there is none, create
   `<TASKS_DIR>/<slug>.md` from the discussion.
2. **Branch.** In the code repository, if not on `feature/<slug>` – create it from
   the integration branch.
3. **Plan.** If the card has no `## Plan`, write it from the discussion in the
   Architect format (`.claude/skills/architect/SKILL.md`), set `status: in-progress`
   and commit it: `docs: plan <slug>`.
4. **Implement.** Follow `.claude/skills/dev/SKILL.md` with two exceptions: the
   decision rule below replaces "stop and ask", and after implementation go on to
   step 5 instead of reporting. Write tests for new code.
5. **Polish.** Run the algorithm of `.claude/skills/polish/SKILL.md` on the task diff.
   Apply every finding you would recommend; skip the rest. No per-item confirmation.
6. **Verify.** Run every item of `### Verification` that can run here, plus the
   project checks for the touched parts (`CLAUDE.md` → Environment and commands:
   tests, linters, type checks). Fix failures and rerun until green. Items that need
   the owner or an external environment – list them as not run, with the reason.
7. **Commit.** Follow `.claude/skills/commit/SKILL.md` without the confirmation
   steps: split by type, trailers and `Why:` as usual.
8. **Close.** Run `.claude/skills/close/SKILL.md`. In `MERGE_MODE=pr` the run ends
   with an open pull request.
9. **Report** (format below).

## Decision rule – forks the discussion did not cover

Do not stop. Take the option you would recommend, record it in
`### Changes along the way` of the card, and list it in the report under "Decided
without you", so the owner can review it in the history. A decision that may deserve
an ADR goes into the report as an ADR candidate – never write the ADR yourself
(`.claude/rules/adr-discipline.md`).

## Hard stops – `/go` does not lift these

Stop, describe the problem and options, wait for the owner:

- owner-only steps: `git push` beyond what `/close` does in `MERGE_MODE=pr`, merge
  `dev` → `main`, release tags, external consoles and accounts;
- deploy and anything that reads or writes production or real user data;
- a conflict with an accepted ADR or with the product boundary and non-goals in
  `PRODUCT_FILE`;
- failing tests or checks that cannot be fixed within the task. Never disable, skip
  or weaken a test or check to get through;
- a rebase conflict in `/close`;
- an action that is destructive or hard to reverse outside the task branch.

## Report

In the communication language (`CLAUDE.md` → Language), by
`.claude/rules/technical-text-style.md` when the language is Russian:

- what was done, with the branch, the commits and where they went (merged or pull
  request);
- verification: what ran and passed, what was not run and why;
- "Decided without you" – decisions taken by the rule above, or "none";
- ADR candidates, or "none";
- what remains for the owner: push, release, review, steps outside this machine.
