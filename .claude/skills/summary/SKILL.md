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
and `/close` in one run (`CLAUDE.md` → Skill boundaries). The owner waits for the
finished result, not for questions.

$ARGUMENTS

## Algorithm

1. **Branch.** If on `main` or `dev`, create `feature/summary-<YYYY-MM-DD>` from
   `dev`. If on `feature/*` or `hotfix/*`, stop: a task is still open – finish it
   with `/close` first, then run `/summary` again.
2. **Report.** Run `.claude/skills/report/SKILL.md`: new `status.md`,
   completed to-do items moved to "Done".
3. **Sync.** Run steps 1–4 of `.claude/skills/sync/SKILL.md` against the
   fresh `status.md`. Instead of step 5 ("wait for agreement") apply every proposal
   you would recommend: `blueprint.md`, `to-do.md`, `CLAUDE.md`, project skills,
   archival of rejected and superseded ADRs. Exceptions:
   - a new ADR – only if it passes the `/record` checklist (`CLAUDE.md` → ADR
     discipline); otherwise list it in the report as a question;
   - questions for the architect (step 4) – list them in the report, do not answer
     them yourself.
4. **Check.** Markdown and text rules of `CLAUDE.md` on every touched file, `/polish`
   project rules; keep both layers in sync where the sync edits touch shared rules.
   Fix and repeat until clean.
5. **Nothing changed.** If the working tree is clean after steps 2–4, delete the
   branch, return to `dev` and report that the documentation matches the code. Stop.
6. **Commit.** Follow `.claude/skills/commit/SKILL.md` without the confirmation
   steps. Type `docs:`; one commit for the status report, one for the sync edits,
   each with a short `Why:` when the reason is not obvious.
7. **Close.** Run `.claude/skills/close/SKILL.md`: rebase, ff-merge into
   `dev`, delete the branch. No push.
8. **Report** (format below).

## Decision rule

Do not stop on a proposal the discussion did not cover. Apply the option you would
recommend and list it in the report under "Decided without you", so the owner can
review it in the merged history.

## Hard stops – `/summary` does not lift these

Stop, describe the problem and options, wait for the owner:

- owner-only steps: `git push`, merge `dev` → `main`, release tags, external consoles
  and accounts;
- deploy and anything that reads or writes production or real user data;
- a divergence that means changing code or the agreed scope, not documentation:
  record it in the report, do not "fix" the docs to match a bug;
- real data in `template/` in place of `{PLACEHOLDERS}`;
- a rebase conflict in `/close`;
- an action that is destructive or hard to reverse outside the feature branch.

## Report

In the communication language (`CLAUDE.md` → Language), by
`.claude/rules/technical-text-style.md` when the language is Russian:

- what changed in the documents, with the commits merged into `dev`;
- "Decided without you" – proposals applied by the rule above, or "none";
- questions for the architect, or "none";
- what remains for the owner: push, merge `dev` → `main`.
