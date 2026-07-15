# no-placeholder-leaks

Files inside `template/` are the shipping scaffold. They must keep their
`{PLACEHOLDER}` tokens intact — `{PROJECT_NAME}`, `{PROJECT_DESCRIPTION}`,
`{COMMUNICATION_LANGUAGE}`, `{CONTEXT_LANGUAGE}`, `{CODE_COMMENTS_LANGUAGE}`,
`{LAYER_1}`, `{TECH_1}`, `{REPO_URL}`, `{ARCHITECTURE_RULES}`, `{RUNTIME_SETUP}`,
`{CODE_CONVENTIONS}`, `{PROJECT_STRUCTURE}`, and any other
`{ALL_CAPS_WITH_UNDERSCORES}` identifier surrounded by braces.

If real data (a concrete project name, a specific language, a real URL) leaks
into these files, the template is broken: `install.sh` will not run its
`sed`-substitutions correctly and users will inherit the maintainer's values.

## Scope

Applies **only** to files under `template/`. The root `CLAUDE.md`, `README.md`,
`SETUP.md`, and other maintainer files legitimately hold real values.

## Anti-pattern

- `template/CLAUDE.md` starts with `# my-real-project — CLAUDE.md` instead of
  `# {PROJECT_NAME} — CLAUDE.md`
- `Communication: Russian` instead of `Communication: {COMMUNICATION_LANGUAGE}`
- A specific `Repository: https://github.com/foo/bar` instead of `{REPO_URL}`
- A stack table filled with `Python 3.12` and `PostgreSQL` instead of
  `{LAYER_1}` / `{TECH_1}`
- Example content whose surrounding placeholder was silently dropped

## Good pattern

- Every `{ALL_CAPS_WITH_UNDERSCORES}` token remains as-is inside `template/`
- Illustrative examples inside placeholders stay wrapped in extra braces so
  they read as guidance, not real content — for example, `{Example: uv sync}`
- Real maintainer values live only in the root `CLAUDE.md`, never in
  `template/CLAUDE.md`

## Judgment notes

- If a placeholder is gone because the surrounding section was removed on
  purpose (e.g., a whole subsection deleted), that is not a leak — the token
  is gone together with its section.
- Static template text that never varies per project (workflow instructions,
  markdown convention lists) does not need placeholders — do not flag such
  sections for the absence of tokens.
- Files under `template/.context/` follow the same rule when they contain
  placeholders — for example, `{PROJECT_NAME}` in blueprint or status headers.
