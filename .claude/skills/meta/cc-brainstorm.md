# Skill: Brainstorm

Triggered by: `/brainstorm [topic]` and `/brainstorm done`

---

## Algorithm

### Trigger: `/brainstorm [topic]`

#### 1. Establish the topic

If an argument was passed — use it as the session topic.
If not — ask: "Что исследуем?" (or "What are we exploring?" depending on the project language).

#### 2. Offer a technique (or start with Free Association immediately)

| Technique | Description |
| --- | --- |
| Free Association | Open flow of ideas (default) |
| SCAMPER | Systematic transformation: Substitute, Combine, Adapt, Modify, Put to other uses, Eliminate, Reverse |
| Six Thinking Hats | Perspective rotation: facts, emotions, critique, optimism, creativity, process |
| Reverse Brainstorm | From failure: "How to guarantee this analysis fails?" → then invert |

If the user has not indicated a preference — start with Free Association without asking.

#### 3. Run divergent thinking mode

Rules for the session:

- Ideas only, no feasibility evaluation
- No code or notebook cells, no technical solutions
- Record everything — "bad" ideas too
- Actively generate, do not wait for user prompts
- Ask follow-up questions to open new directions

#### 4. Track placeholder coverage silently

While the session runs, note which placeholders are already covered by user answers.
Do not interrupt the creative flow to ask about placeholders.

---

### Trigger: `/brainstorm done`

#### Phase 1 — Parameter sweep

Check which placeholders from the first group are still uncovered.

**Fill now** (from session or by asking):

| Placeholder | Source |
| --- | --- |
| `{PROJECT_DESCRIPTION}` | from brainstorm |
| `{DATA_SOURCE_1}` + description + volume | from brainstorm, if discussed |
| `{COMMUNICATION_LANGUAGE}` / `{CONTEXT_LANGUAGE}` / `{CODE_COMMENTS_LANGUAGE}` | ask |
| `{CODE_CONVENTIONS}` | ask |
| `{ANALYSIS_RULES}` | ask or derive from brainstorm |
| `{RUNTIME_SETUP}` | ask |
| `{REPO_URL}` | read from `git remote get-url origin` if available |

**Fill later** (skip):

`{PROJECT_NAME}` (already set by `install.sh`), `{PROJECT_STRUCTURE}`, `{PHASE_NAME}`, `{N}`,
`{FIRST_DECISION_TITLE}`, `{FIRST_KEY_DECISION}`, `{DECISION_KEY}`

If uncovered placeholders remain from the first group — ask them as one compact list.
Do not ask one by one. Wait for answers, then proceed.

---

#### Phase 2 — Save discussion

Structure the session output and save to:

```text
.context/discussions/brainstorm-YYYYMMDD-{slug}.md
```

File format:

```markdown
## Brainstorm: {topic}

Дата: YYYY-MM-DD
Техника: {name}

### Идеи

- ...

### Ключевые инсайты

- ...

### Следующий шаг

{What to work out in /architect}
```

Slug — topic transliterated to kebab-case, no more than 4 words.

---

#### Phase 3 — Fill context documents

Files with placeholders to fill:

- `CLAUDE.md` — `{PROJECT_DESCRIPTION}`, language settings, data sources, analysis rules
- `.context/blueprint.md` — data sources, preparation pipeline, key fields and filters
- `.context/methodology.md` — statistical approach, assumptions, validation standards, data caveats
- `.context/to-do.md` — if analytical directions or hypotheses emerged
- `.context/status.md` — if initial project state is known
- `.claude/index.md` — if `{PROJECT_DESCRIPTION}` is known
- **NOT** `findings.md` — reserved for actual findings recorded during analysis

For each file:

- If the file contains only placeholders — fill without asking.
- If the file already has live context — ask:

  > `{filename}` already contains data. Overwrite based on the brainstorm?

  Wait for explicit confirmation before proceeding.

When filling: only replace placeholders — do not delete sections or change structure.

When filling `blueprint.md`: interpret software placeholders (`{COMPONENT_1}`, `{MAIN_FLOW}`, etc.)
in analytical terms — data sources, pipeline stages, key transformations.

---

#### Phase 4 — Completion

Report the final summary of what was done:

```text
Сессия завершена.
Сохранено: .context/discussions/brainstorm-YYYYMMDD-{slug}.md
Обновлено: CLAUDE.md, .context/blueprint.md, .context/methodology.md, [others if updated]

Следующий шаг: /architect — проработать методологию и данные на основе инсайтов.
```

---

## Constraints

- Never create code files (`.py`, `.ipynb`, `.ts`, etc.) under any circumstances
- Do not evaluate feasibility of ideas during an active session
- When filling files: only replace placeholders — do not delete sections, structure stays intact
