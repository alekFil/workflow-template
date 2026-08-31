## Task: Реализовать ADR-032 — подсказка plan.md в /architect + untracked-check в /commit

### Context

Реализация ADR-032: закрываем workflow-гэп, из-за которого `plan.md` мог остаться untracked и не попасть в git-историю ветки (потеря для review). Two-point defense: `/architect` подсказывает `/commit` перед `/dev`; `/commit` при обнаружении untracked `plan.md` спрашивает включить (дефолт Yes). Оба фикса в границах ADR-031 (текст-подсказка + git-add как часть собственного scope /commit).

Работа продолжается на текущей ветке `feature/skill-boundaries` — бандлится с ADR-031-реализацией, так как оба фикса — единая workflow-дисциплина.

Depends on: ADR-032, ADR-031 (skill boundaries), ADR-030 (plan.md task-local).

### What to implement

1. **Обновить `.claude/commands/architect.md`** — добавить финальную секцию/строку про подсказку `/commit`. Формулировка (пример):

   > When you finish writing `plan.md`, remind the user: "Plan written. Run `/commit` before `/dev` to include `plan.md` in the feature branch (reviewers see it alongside the implementation)."

   Разместить в отдельном подразделе (например, `## After writing plan.md`) для видимости.

2. **Обновить `template/.claude/commands/architect.md`** — тот же подраздел, идентичная формулировка.

3. **Обновить `.claude/skills/meta/cc-commit.md`** — новый шаг между текущим step 2 («Check there is something to commit») и step 3 («Show the list of changes and ask for confirmation»). Логика:

   - Если `.context/plan.md` untracked (или modified) — вывести:

     ```text
     Detected untracked/modified .context/plan.md — design artifact for the current task.
     Include in this commit? [Y/n] (default: Y)
     ```

   - При `Y` (или пустом ответе) — `git add .context/plan.md` перед формированием diff.
   - При `n` — пропустить, продолжить обычный поток.

4. **Обновить `template/.claude/skills/meta/cc-commit.md`** — те же правки.

5. **Обновить `.context/to-do.md`** — добавить запись в «Готово» про ADR-032.

### Files

Edit:

- `.claude/commands/architect.md` — финальная подсказка про `/commit`
- `template/.claude/commands/architect.md` — то же
- `.claude/skills/meta/cc-commit.md` — новый шаг «untracked plan.md check»
- `template/.claude/skills/meta/cc-commit.md` — то же
- `.context/to-do.md` — запись в «Готово»

Create: —

### Constraints

- **Обе правки — в границах ADR-031.** `/architect`-подсказка — текст, не автоматическое исполнение. `/commit`-вопрос с дефолтом Y — не auto-execute (пользователь может ответить n), плюс git-add — часть собственного scope `/commit`, не сползание.
- **Идентичность формулировок в обоих слоях** в содержательной части. Английский, стиль как в существующих секциях.
- **Не добавлять раздел про plan.md-workflow в CLAUDE.md** — частный случай, живёт в скиллах. Общее правило skill-boundaries (ADR-031) уже в CLAUDE.md; ADR-032 — детализация в скиллах.
- **`/dev` не трогаем.** Проверка на committed plan.md туда не добавляется — по решению из обсуждения (лишний шум для редкого edge-case).
- **Feature-ветка:** `feature/skill-boundaries` (уже на ней, продолжаем бандл с ADR-031).
- **Один атомарный commit** для правок этой задачи. Плюс отдельный `chore: clean plan.md` в `/close` (по механике ADR-030 закроет всю ветку).

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. architect.md содержит подсказку про /commit
grep -qi "run.*/commit.*before.*/dev\|/commit.*before.*/dev.*reviewers" .claude/commands/architect.md && echo "OK root architect"
grep -qi "run.*/commit.*before.*/dev\|/commit.*before.*/dev.*reviewers" template/.claude/commands/architect.md && echo "OK template architect"

# 2. cc-commit.md содержит шаг про untracked plan.md
grep -qi "untracked.*plan.md\|plan.md.*untracked\|Include.*plan.md" .claude/skills/meta/cc-commit.md && echo "OK root commit"
grep -qi "untracked.*plan.md\|plan.md.*untracked\|Include.*plan.md" template/.claude/skills/meta/cc-commit.md && echo "OK template commit"

# 3. to-do.md содержит запись про ADR-032 в Готово
grep -q "ADR-032" .context/to-do.md && echo "OK to-do"

# 4. Оба слоя симметричны (тот же контент правки)
diff <(grep -A 5 "Include.*plan.md" .claude/skills/meta/cc-commit.md) \
     <(grep -A 5 "Include.*plan.md" template/.claude/skills/meta/cc-commit.md) \
     && echo "OK symmetric commit skills"
```

Manual smoke:

- Прочитать `architect.md` в обоих слоях — финальная подсказка про `/commit` видна отдельным разделом или чётко выделенной строкой.
- Прочитать `cc-commit.md` — новый шаг явно между step 2 и старым step 3; порядок и нумерация сохранены.
- Проверить, что в скилле нет автоматического `git commit` без пользовательского подтверждения — только вопрос с дефолтом Y.

### Changes along the way

—
