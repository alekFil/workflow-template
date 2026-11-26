---
paths:
  - "**/*.md"
---

# markdown-conventions

Conventions for every `*.md` file in the repository. Violations create noise across
the docs and make diffs unreadable.

The rules:

- List markers are `-` only – never `*` or `+`.
- Code blocks always have a language tag – `python`, `bash`, `yaml`, `json`,
  `text` for plain text, `markdown` for markdown samples. A bare ` ``` ` opener
  is a violation.
- Empty line before and after every heading.
- Empty line before a list when preceded by text.
- Horizontal rules (`---`) only between major sections – do not sprinkle them
  between every subsection; prefer heading hierarchy.
- A line of text is at most 88 characters. Paragraphs and list items wrap at word
  boundaries; a list item continues with an indent. Tables, code blocks and
  headings do not wrap. The rule applies to every new and edited paragraph; old
  text is wrapped when its paragraph is edited.

## Anti-pattern

- `* item` or `+ item` in a list
- ` ``` ` opener with no language tag
- Heading with no empty line above or below
- `---` between two `###` subsections of the same `##`

## Good pattern

- `- item` uniformly across the file
- ` ```bash `, ` ```text `, ` ```markdown ` – language tag always present
- Every `#`, `##`, `###` heading surrounded by blank lines

## Judgment notes

- Target convention drift, not typos. If a code block is missing a language tag
  in one place but present everywhere else in the same doc, flag it.
- The rule does not inspect content of code blocks – only fence syntax.
- Nested lists inside a code block sample are not real markdown – skip.
