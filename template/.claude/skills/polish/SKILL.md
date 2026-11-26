---
name: polish
description: "Clean up generated code: built-in simplify plus the project rules in .claude/rules/. Use when the owner asks to polish or clean up code after generation, or types /polish."
argument-hint: "[path | --staged | --all]"
---

# Code polish

$ARGUMENTS

## What it does

Wraps the built-in `simplify` skill and applies project-specific rules from
`.claude/rules/*.md`. Presents findings, then applies fixes only
after per-item confirmation.

Not a replacement for `simplify` – a coordinator that adds project rules on top.
Not the same as `security-review` – that skill is separate and not invoked here.

---

## Algorithm

### 1. Determine scope from `$ARGUMENTS`

All git commands run in the code repository: `git -C <CODE_DIR>`
(`.claude/workflow.conf`). In devmeta profiles the root repository ignores `code/`.

| Argument | Scope |
| --- | --- |
| (empty) | `git diff $(git merge-base HEAD <integration branch>)..HEAD` – task branch vs branch point (`.claude/rules/branching.md`) |
| `<path>` | `git diff -- <path>` – targeted file or directory |
| `--staged` | `git diff --staged` – only staged changes |
| `--all` | all tracked files (`git ls-files`), minus patterns in optional `.polishignore` – see step 1a |

If scope is empty – report: "Nothing to polish. Working tree clean." and exit.

If not on a feature branch and no argument given – report:
"Not on a task branch – pass a path, `--staged`, or `--all`, or switch to a task
branch."

### 1a. `--all` mode – enumerate and confirm

Only runs when `--all` was passed.

1. Enumerate tracked files: `git ls-files`.
2. If `.polishignore` exists at repo root – exclude files matching its patterns
   (same format as `.gitignore`).
3. Ask for confirmation:

   ```text
   Scope: <N> files (~<M> lines). This will run project rules only (no simplify).
   Continue? y/n
   ```

4. If `n` – exit. If `y` – proceed directly to step 3 (skip step 2).

### 2. Invoke built-in `simplify`

Skipped when `--all` was passed (see step 1a).

Run the built-in `simplify` skill on the diff scope. Collect its findings verbatim.

If `simplify` is unavailable in the current CC version – print a warning and
continue in "rules-only" mode:

```text
Warning: built-in `simplify` skill not available. Running rules only.
```

### 3. Load and apply project rules

Read every file in `.claude/rules/*.md`. Apply the rules that state a criterion
for code or text in the scope: for example `text-conventions.md`,
`markdown-conventions.md`, `no-dead-code.md`. Workflow rules (`branching.md`,
`artifacts.md`, `skill-boundaries.md`, `adr-discipline.md`) describe the process,
not a diff – skip them.

Each rule file is prose: H1 title = rule name, body = free-form description of
what to check. The only frontmatter is an optional `paths` list: when present, the
rule applies only to matching files.

For each rule:

- Read the rule content
- Judge whether any part of the scope (diff or file list) violates it – use the
  rule's description as the criterion, apply judgment (not literal pattern matching)
- If violation found – record a finding: file, line, quote, why it violates

### 4. Present grouped findings

Output findings grouped by source:

```text
## Polish findings

### [Simplify]
- <file>:<line> – <what and why>

### [Rule: <rule-name>]
- <file>:<line> – <what and why>

### Summary
- <N> from simplify, <M> from <K> project rules
- <total> findings – review below

For each item: apply / skip / discuss?
```

Wait for per-item response. Accept batch responses ("apply 1,3,5" / "skip all
simplify" / "apply all").

### 5. Apply confirmed fixes

For each accepted finding – make the edit.
For each skipped finding – do nothing.
For each `discuss` – ask a clarifying question, then re-decide.

### 6. Report the result

```text
Polish done.
  Applied: <N>
  Skipped: <M>
  Discussed: <K>

Review the diff, then /commit when ready.
```

Do not commit automatically. Do not chain into `/commit`.

---

## Rules directory

Location: `.claude/rules/*.md`. Claude Code loads these files into context
automatically (a rule with `paths` – when a matching file is opened), so the same
rules guide writing and `/polish` checks the result.

To add a rule: create `<name>.md` in the directory. To remove it: delete the file.
The format – `.claude/skills/polish/rules-format.md`.

---

## Constraints

- Do not commit – surface findings, apply on confirmation, then stop
- Do not chain to `/commit`, `/close`, or any other command
- Do not touch files outside the scope
- Do not invoke `security-review` – separate concern, separate command
- Do not reimplement `simplify` logic – always delegate to the built-in
- In `--all` mode, do not call `simplify` – even if available, only project rules run
