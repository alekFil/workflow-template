## Task: Реализовать ADR-031 — раздел Skill boundaries + ревизия скиллов

### Context

Реализация ADR-031: фиксируем правило «команда не исполняет соседний скилл автоматически, подсказка допустима» как раздел в `CLAUDE.md` обоих слоёв. Усиливаем `dev.md` (главный источник нарушений) явным запретом на предложение commit'а и вызов `/commit`/`/close`. Ревизуем commands/ и skills/meta/ на аналогичные зоны сползания — правим только явно нарушающие. Приоритет 4 в to-do закрывается как замещённый ADR-031.

Depends on: ADR-031, ADR-030 (task-local `plan.md`).

### What to implement

1. **Добавить раздел «Skill boundaries» в `CLAUDE.md` (root)** — 6-10 строк после «Artifact scope» или в соседней позиции. Формат: правило + один пример (допустимо vs недопустимо) + ссылка на ADR-031. Пример должен быть про `/dev` (реальный случай нарушения).

2. **Добавить тот же раздел в `template/CLAUDE.md`.** Идентичный содержательный текст (шаблонный слой на английском, мейнтейнерский — тоже, разница только в контексте окружения).

3. **Усилить `.claude/commands/dev.md`** (оба слоя): добавить в раздел «In this mode» явный запрет:

   ```markdown
   - **After completion, report only.** Do NOT propose commit messages, run `/commit`, `/close`, or invoke any other skill automatically. Suggesting a next step in text (e.g. "Ready for /commit?") is allowed; executing it is not. See CLAUDE.md → Skill boundaries.
   ```

4. **Ревизия `.claude/commands/*.md` и `.claude/skills/meta/*.md` в обоих слоях** — прочесть, найти места, где скилл автоматически исполняет соседний (не путать с внутренней логикой скилла типа `/close` step 3 `chore: clean plan.md` — это не сползание, ADR-031 п.5 в согласовании). Править только явно нарушающие. Ожидание: скорее всего только `dev.md`, но проверка обязательна.

5. **Закрыть Приоритет 4 в `to-do.md`:** пункт «устранить `/dev` → авто-commit» пометить как выполненный «— замещён ADR-031, реализация в рамках Skill boundaries».

### Files

Edit:

- `CLAUDE.md` — новый раздел «Skill boundaries»
- `template/CLAUDE.md` — тот же раздел
- `.claude/commands/dev.md` — усиленный запрет + ссылка
- `template/.claude/commands/dev.md` — то же
- `.context/to-do.md` — Приоритет 4 в Готово

Возможные edits (по факту ревизии):

- `.claude/commands/architect.md`, `close.md`, `report.md`, `sync.md`, `commit.md`, `record.md`, `retro.md`, `polish.md`, `next.md`, `organize.md` — при обнаружении нарушений
- `.claude/skills/meta/cc-*.md` (все 6 файлов) — при обнаружении нарушений
- Симметрично в `template/`

Create: —

### Constraints

- **Правило в единственном месте.** Полный текст правила — только в CLAUDE.md обоих слоёв. В `dev.md` — усиленная формулировка запрета + ссылка «See CLAUDE.md → Skill boundaries», не полное дублирование.
- **`report.md` и `sync.md` не трогать** — они уже соответствуют (подсказка в тексте, не автоматическое исполнение). Trigger для правки — только явное нарушение.
- **Commit внутри собственного алгоритма скилла — не нарушение.** Пример: `/close` step 3 `chore: clean plan.md` — это часть собственной механики `/close` per ADR-030, не сползание в `/commit`. Не удалять и не «исправлять» такие места.
- **Не добавлять formal disclaimer в каждый скилл** («this skill does not execute /X automatically») — избыточное дублирование правила из CLAUDE.md.
- **Плейсхолдеры в `template/` не трогать.** Раздел «Skill boundaries» не содержит подстановочных значений, вставляется как есть.
- **Формулировки в обоих слоях идентичны в содержательной части.** Английский, стиль как в «Artifact scope» / «ADR discipline».
- **Feature-ветка:** `feature/skill-boundaries` (уже создана).
- **Один атомарный commit** — задача связная (ADR-031 через несколько мелких файлов). Плюс отдельный `chore: clean plan.md` в `/close` per механика ADR-030.

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. Раздел «Skill boundaries» присутствует в обоих CLAUDE.md
grep -q "^## Skill boundaries" CLAUDE.md && echo "OK root"
grep -q "^## Skill boundaries" template/CLAUDE.md && echo "OK template"

# 2. dev.md содержит усиленный запрет
grep -qi "do not propose commit\|do not run /commit\|do not invoke.*automatic" .claude/commands/dev.md && echo "OK root dev.md"
grep -qi "do not propose commit\|do not run /commit\|do not invoke.*automatic" template/.claude/commands/dev.md && echo "OK template dev.md"

# 3. dev.md ссылается на CLAUDE.md → Skill boundaries
grep -q "Skill boundaries" .claude/commands/dev.md && echo "OK root ref"
grep -q "Skill boundaries" template/.claude/commands/dev.md && echo "OK template ref"

# 4. to-do.md: Приоритет 4 в Готово
if grep -qE "^### Приоритет 4:.*/dev" .context/to-do.md; then echo "FAIL: P4 still active"; else echo "OK: P4 closed"; fi
grep -q "устранить.*dev.*ADR-031\|замещён ADR-031" .context/to-do.md && echo "OK: closure note in Готово"

# 5. Ревизия не оставила orphan'ов (все правки — либо dev.md, либо документированы в Changes along the way)
git diff --stat HEAD~ 2>/dev/null || git diff --stat --cached | head -20
```

Manual smoke:

- Прочитать секцию «Skill boundaries» в обоих `CLAUDE.md` — правило и пример явно противопоставляют «suggest next step» и «execute next skill».
- Прочитать `dev.md` в обоих слоях — запрет виден при беглом прочтении, ссылка на CLAUDE.md есть.
- Прочитать `/close` step 3 в `cc-close-task.md` — не сломан (внутренняя механика, не сползание).
- Прочитать `report.md`, `sync.md` — подсказки на выход (`Commit? (/commit)`) остались как текст, автоматически не исполняются.

### Changes along the way

—
