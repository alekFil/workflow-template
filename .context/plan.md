## Task: Add /polish command — code cleanup pipeline with pluggable rules

### Context

No workflow tool exists for cleaning up generated code between `/dev` and `/commit`.
The built-in `simplify` skill handles reuse/quality/efficiency generically, but there is
no wrapper that combines it with project-specific rules. Both layers need the command,
because it belongs to the workflow contract, not to any particular project.

Depends on: —

### What to implement

1. Skill `cc-code-polish.md` in both layers — pipeline algorithm: diff selection by argument, invoke `simplify`, scan `rules/*.md`, apply each rule to diff, group findings, per-item `apply / skip / discuss` loop.
2. Command `polish.md` in both layers — one-line trigger; forwards args.
3. Rules directory in both layers:
   - `.claude/skills/project/rules/` (maintainer) — `.gitkeep` only, currently no rules
   - `template/.claude/skills/project/rules/` — `README.md` (explains prose format + how the skill discovers rules) + one example rule (`no-dead-code.md`)
4. Wire `/polish` into all navigation surfaces:
   - `CLAUDE.md` (maintainer) — add row to slash commands table
   - `.claude/index.md` (maintainer) — add trigger line
   - `template/CLAUDE.md` — add row to slash commands table
   - `template/.claude/index.md` — add trigger line
   - `template/WORKFLOW.md` — add row to commands table + insert step in "Typical workday" between current 4 (`/commit`) and current 5 (`/close`), or as a sub-step of 4
5. `template/WORKFLOW.md` "Initial setup" section — add note that `.claude/skills/project/rules/` is where project-specific rules live.

### Files

Create:

- `.claude/commands/polish.md`
- `.claude/skills/meta/cc-code-polish.md`
- `.claude/skills/project/rules/.gitkeep`
- `template/.claude/commands/polish.md`
- `template/.claude/skills/meta/cc-code-polish.md`
- `template/.claude/skills/project/rules/README.md`
- `template/.claude/skills/project/rules/no-dead-code.md`

Edit:

- `CLAUDE.md` — `/polish` row in slash commands table
- `.claude/index.md` — `/polish` trigger line
- `template/CLAUDE.md` — `/polish` row in slash commands table
- `template/.claude/index.md` — `/polish` trigger line
- `template/WORKFLOW.md` — `/polish` row in commands table + entry in "Typical workday" + note in "Initial setup" about `rules/` directory

### Constraints

- **Wrapper only.** `cc-code-polish.md` invokes the built-in `simplify` skill by name — does not reimplement its logic. If `simplify` is unavailable in the CC version — skill degrades gracefully to "rules only" mode with a warning.
- **No security-review in default pipeline.** Separate task.
- **Prose rule format.** Rule file = free-form markdown: title (H1) + description. No YAML frontmatter, no fixed sections, no auto-fix flag. CC reads content and applies judgment. `README.md` in `rules/` documents this contract.
- **Convention-driven discovery.** Skill scans `.claude/skills/project/rules/*.md` at runtime. No config file, no explicit registration.
- **Command name `/polish`** — chosen to avoid clash with existing/future built-in `/review`, `/simplify`, `/clean` (ADR-017 precedent).
- **Do not touch `security-review`, `simplify`, or `review`** — they are Claude Code built-ins, not ours.
- **Both layers stay in sync** for this feature — command, skill, and rules directory added to both. Divergence would defeat the point.
- **Scope creep guard.** Do not add: severity levels, glob filters, auto-fix machinery, rule versioning, per-file overrides. If those turn out to be needed — separate discussion and separate ADR.

### Verification

```bash
# Files exist in both layers
test -f .claude/commands/polish.md
test -f .claude/skills/meta/cc-code-polish.md
test -d .claude/skills/project/rules
test -f template/.claude/commands/polish.md
test -f template/.claude/skills/meta/cc-code-polish.md
test -f template/.claude/skills/project/rules/README.md
test -f template/.claude/skills/project/rules/no-dead-code.md

# /polish referenced in navigation surfaces
grep -q '/polish' CLAUDE.md
grep -q '/polish' .claude/index.md
grep -q '/polish' template/CLAUDE.md
grep -q '/polish' template/.claude/index.md
grep -q '/polish' template/WORKFLOW.md

# Skill files mention scanning rules/*.md
grep -q 'rules/\*.md' .claude/skills/meta/cc-code-polish.md
grep -q 'rules/\*.md' template/.claude/skills/meta/cc-code-polish.md

# Skill files reference the built-in simplify by name
grep -q 'simplify' .claude/skills/meta/cc-code-polish.md
grep -q 'simplify' template/.claude/skills/meta/cc-code-polish.md
```

Manual smoke: after implementation, open a test session and invoke `/polish` on a small diff — verify skill loads, pipeline steps run in order, findings are presented before edits.

### Changes along the way

- **`/retro` добавлен в оба `.claude/index.md`.** Обнаружено на пути: строка была пропущена
  в таблицах Slash commands и Meta-skills обоих файлов (пре-существующая нестыковка со
  времени ADR-019). Раз всё равно правил эти таблицы под `/polish` — добавил и `/retro`.
- **`.claude/skills/project/rules/` добавлена в `template/WORKFLOW.md` → «Project documentation».**
  Обнаружено на пути: раздел документировал `.context/notes/`, но `.claude/skills/project/`
  вообще не упоминался. Добавил строку для полноты карты — согласовано с общей задачей.
- **`.claude/skills/project/rules/` упоминается в «Initial setup» шаблона** — как рекомендация
  «настроить пораньше». Не placeholder, но по смыслу секции — «что подготовить перед первой
  сессией».

### Notes

Plan touches 12 files across two layers. This is intentional — adding one command
requires wiring into all navigation surfaces of both layers to stay coherent.
Splitting would leave the command orphaned in half the docs.

Before starting `/dev`: create ADR-023 via `/record` — fixes the design decisions
that shaped this plan (wrapper vs replacement, prose rules, `/polish` naming,
security-review deferred).
