# Project rules for `/polish`

This directory holds project-specific code rules applied by `/polish`
after the built-in `simplify` skill has run.

Discovery is convention-driven — `/polish` scans `*.md` files here every run.
No config file, no registration step.

---

## Adding a rule

Create `<name>.md` in this directory. The rule takes effect immediately —
next `/polish` invocation will pick it up.

To remove a rule: delete the file.

---

## Rule format — prose

A rule file is free-form markdown. Minimum contract:

- **H1 title** — becomes the rule identifier shown in `/polish` findings
- **Body** — prose description of what to check

No YAML frontmatter. No fixed sections. No severity levels. No enable/disable
flag. If you find yourself wanting those — bring it up as a discussion; the
prose format is intentional.

---

## Example

See `no-dead-code.md` in this directory.

Good rule prose:

- States the criterion in one paragraph
- Gives an anti-pattern (what triggers it)
- Gives a good pattern (what to do instead)
- Leaves judgment to CC — do not try to specify every edge case

Bad rule prose:

- Vague ("write clean code") — CC cannot judge
- Overspecified with regex/AST syntax — the prose format is not a linter DSL
- Duplicates what `simplify` already covers — check `/polish` output first

---

## When a rule graduates to code

Some checks are better as linters or type systems (formatting, import order,
type errors). Rules here are for things that require judgment: architectural
boundaries, domain conventions, project-specific anti-patterns.

If a rule can be enforced mechanically — write it as a linter config instead
and delete the rule file.
