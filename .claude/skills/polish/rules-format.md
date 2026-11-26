# Rule format for `.claude/rules/`

Rules in `.claude/rules/*.md` serve twice: Claude Code loads them into context while
writing, and `/polish` checks a diff against them.

## Adding a rule

Create `<name>.md` in `.claude/rules/`. It takes effect in the next session and the
next `/polish` run. To remove a rule: delete the file.

## Format – prose

A rule file is free-form markdown. Minimum contract:

- **H1 title** – becomes the rule identifier shown in `/polish` findings
- **Body** – prose description of what to check

Optional frontmatter – only `paths`, a list of globs. With `paths` the rule loads
when a matching file is opened, and `/polish` applies it only to matching files:

```markdown
---
paths:
  - "src/**/*.py"
---

# <rule-name>

<What to check, an anti-pattern, a good pattern.>
```

No fixed sections, no severity levels, no enable/disable flag.

## Example

See `.claude/rules/no-dead-code.md` in the template.

Good rule prose:

- States the criterion in one paragraph
- Gives an anti-pattern (what triggers it)
- Gives a good pattern (what to do instead)
- Leaves judgment to CC – do not try to specify every edge case

Bad rule prose:

- Vague ("write clean code") – CC cannot judge
- Overspecified with regex/AST syntax – the prose format is not a linter DSL
- Duplicates what `simplify` already covers – check `/polish` output first

---

## When a rule graduates to code

Some checks are better as linters or type systems (formatting, import order,
type errors). Rules here are for things that require judgment: architectural
boundaries, domain conventions, project-specific anti-patterns.

If a rule can be enforced mechanically – write it as a linter config instead
and delete the rule file.
