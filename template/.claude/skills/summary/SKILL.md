---
name: summary
description: "Sum up after a task or a release without stopping: report, sync with recommended edits applied, commit, close. Only on the owner's explicit /summary."
disable-model-invocation: true
argument-hint: "[note]"
---

# /summary

Sum up the project state after a task or a release, without stopping: report → sync
→ commit → close.

`/summary` is the owner's explicit permission to chain `/report`, `/sync`, `/commit`
and `/close` in one run (`.claude/rules/skill-boundaries.md`). The owner waits for the
finished result, not for questions.

$ARGUMENTS

Settings – `.claude/workflow.conf`; classes of shared text –
`.claude/rules/artifacts.md`.

## Algorithm

1. **Branch.** If a task branch is open in the code repository – stop: finish it
   with `/close` first, then run `/summary` again. With `CODE_DIR=.` create
   `feature/summary-<YYYY-MM-DD>` from the integration branch; in devmeta profiles
   documentation lives in the context repository and needs no branch.
2. **Report.** Run `.claude/skills/report/SKILL.md`: new `status.md` (not
   committed).
3. **Sync.** Run steps 1–4 of `.claude/skills/sync/SKILL.md`. Instead of step 5
   ("wait for agreement") apply every proposal you would recommend for
   `.context/blueprint.md`, task card statuses, `.claude/rules/*.md` and the
   generated ADR index. Exceptions – list them in the report, do not apply:
   - `PRODUCT_FILE` and `CLAUDE.md` – curated by the owner;
   - ADR candidates – only the owner records ADRs (`/record`);
   - questions for the architect.
4. **Check.** Markdown and text rules (`.claude/rules/`) on every touched file. Fix
   and repeat until clean.
5. **Nothing changed.** If the working tree is clean after steps 2–4, delete the
   branch, return to the integration branch and report that the documentation
   matches the code. Stop.
6. **Commit.** Follow `.claude/skills/commit/SKILL.md` without the confirmation
   steps. Type `docs:`, a short `Why:` when the reason is not obvious.
7. **Close.** With `CODE_DIR=.` – merge the summary branch as
   `.claude/skills/close/SKILL.md` step 4–5 describe (there is no task card). No
   push beyond what `MERGE_MODE=pr` allows.
8. **Report** (format below).

## Decision rule

Do not stop on a proposal the discussion did not cover. Apply the option you would
recommend within the limits of step 3 and list it in the report under "Decided
without you", so the owner can review it in the history.

## Hard stops – `/summary` does not lift these

Stop, describe the problem and options, wait for the owner:

- owner-only steps: `git push` beyond `MERGE_MODE=pr`, merge `dev` → `main`, release
  tags, external consoles and accounts;
- deploy and anything that reads or writes production or real user data;
- a divergence that means changing code or the product scope, not documentation:
  record it in the report, do not "fix" the docs to match a bug;
- a rebase conflict;
- an action that is destructive or hard to reverse outside the summary branch.

## Report

In the communication language (`CLAUDE.md` → Language), by
`.claude/rules/technical-text-style.md` when the language is Russian:

- what changed in the documents, with the commits;
- "Decided without you" – proposals applied by the rule above, or "none";
- not applied: proposals for `PRODUCT_FILE` and `CLAUDE.md`, ADR candidates,
  questions for the architect – or "none";
- what remains for the owner: push, release.
