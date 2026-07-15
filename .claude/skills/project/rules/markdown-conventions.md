# markdown-conventions

Markdown files follow the conventions in `CLAUDE.md` → «Markdown conventions».
Violations create noise across the docs and drift the maintainer and template
layers apart. This rule applies to every `*.md` file in the repo.

The rules:

- List markers are `-` only — never `*` or `+`.
- Code blocks always have a language tag — `python`, `bash`, `yaml`, `json`,
  `text` for plain text, `markdown` for markdown samples. A bare ` ``` ` opener
  is a violation.
- Empty line before and after every heading.
- Empty line before a list when preceded by text.
- Horizontal rules (`---`) only between major sections — do not sprinkle them
  between every subsection; prefer heading hierarchy.

## Anti-pattern

- `* item` or `+ item` in a list
- ` ``` ` opener with no language tag
- Heading with no empty line above or below
- `---` between two `###` subsections of the same `##`

## Good pattern

- `- item` uniformly across the file
- ` ```bash `, ` ```text `, ` ```markdown ` — language tag always present
- Every `#`, `##`, `###` heading surrounded by blank lines

## Judgment notes

- Target convention drift, not typos. If a code block is missing a language tag
  in one place but present everywhere else in the same doc, flag it.
- The rule does not inspect content of code blocks — only fence syntax.
- Files inside `template/` follow the same conventions — a violation there
  counts the same as in the maintainer layer.
- Nested lists inside a code block sample are not real markdown — skip.
