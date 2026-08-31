## Task: Three-way split — notes / discussions / history-retros — реализовать ADR-029

### Context

Реализация ADR-029: `.context/discussions/` перестаёт быть свалкой AI-думания. Семантика разделяется на три директории по источнику и режиму видимости — `notes/` (private, AI-user), `discussions/` (committed, team-only), `history/retros/` (committed, archived retros). Ретроактив: 4 AI-файла и 1 retro переезжают на правильные места. Скилл `/retro` обновляется, `CLAUDE.md` в обоих слоях получает актуальную Components-строку.

Depends on: ADR-029, ADR-028 (Components-строка), ADR-011 (`notes/` в `.gitignore`).

### What to implement

1. **Создать директорию `.context/history/retros/`.** Она будет непустой сразу (переезжает retro-файл), `.gitkeep` не нужен.

2. **Переместить retro-файл в новую директорию:**

   ```bash
   git mv .context/discussions/retro-2026-06-21.md .context/history/retros/2026-06-21.md
   ```

   Префикс `retro-` снят — папка сама говорит «что это»; формат согласован с `history/decisions/`.

3. **Переместить 4 AI-файла в `notes/`:**

   ```bash
   git mv .context/discussions/2026-06-08-install-and-mini.md .context/notes/
   git mv .context/discussions/2026-06-08-mini-claude-md-design.md .context/notes/
   git mv .context/discussions/2026-06-18-local-llm-agent.md .context/notes/
   git mv .context/discussions/2026-08-30-adr-discipline.md .context/notes/
   ```

   Так как `.context/notes/` в `.gitignore`, git видит источник как удалённый, destination — как untracked (не попадает в commit). Локальная копия у мейнтейнера остаётся.

4. **Обеспечить `.gitkeep` в `.context/discussions/`.** Проверить наличие; если нет — создать (директория пустая после переезда, git её не сохранит без stub'а).

5. **Обновить `cc-retrospective.md` в мейнтейнерском слое:**
   - Найти все ссылки на путь записи (`discussions/retro-*` или подобное).
   - Заменить на `.context/history/retros/YYYY-MM-DD.md` (без префикса `retro-`).
   - Также обновить формулировки в описании скилла, если упоминают «в discussions».

6. **Обновить `template/.claude/skills/meta/cc-retrospective.md`:** те же правки, что и в мейнтейнерском.

7. **Обновить `CLAUDE.md` (root) — Components-строка `.context/`:** сейчас перечисляет `blueprint, plan, to-do, status, decisions, discussions, history/decisions`. Добавить `history/retros`:

   ```markdown
   - `.context/` — workflow artifacts (blueprint, plan, to-do, status, decisions, discussions, history/decisions, history/retros)
   ```

8. **Обновить `template/CLAUDE.md` — Components-строка `.context/`:** сверить текущий текст, при необходимости синхронизировать.

9. **Проверить `cc-status-report.md`, `cc-architect-sync.md` и другие скиллы** в обоих слоях — не ссылаются ли на `discussions/retro-*` или `discussions/` как на shared-архив. При наличии — обновить.

10. **Обратные ссылки:** сверить активные ADR (в том числе ADR-026) на упоминания `discussions/2026-08-30-adr-discipline.md`. Скорее всего таких ссылок нет, но проверить и при наличии обновить (файл уходит из git).

11. **Обновить `.context/to-do.md`:** отметить ADR-029 в Готово.

### Files

Create:

- `.context/history/retros/2026-06-21.md` — через `git mv`, не через новое создание содержимого
- `.context/discussions/.gitkeep` — если отсутствует

Edit:

- `.claude/skills/meta/cc-retrospective.md` — write-path, формулировки
- `template/.claude/skills/meta/cc-retrospective.md` — то же
- `CLAUDE.md` — Components-строка `.context/`
- `template/CLAUDE.md` — Components-строка `.context/`
- `.context/to-do.md` — ADR-029 в Готово
- Другие скиллы/файлы — по факту обнаружения ссылок на `discussions/retro-*`

Move (git mv):

- `.context/discussions/retro-2026-06-21.md` → `.context/history/retros/2026-06-21.md`
- `.context/discussions/2026-06-08-install-and-mini.md` → `.context/notes/`
- `.context/discussions/2026-06-08-mini-claude-md-design.md` → `.context/notes/`
- `.context/discussions/2026-06-18-local-llm-agent.md` → `.context/notes/`
- `.context/discussions/2026-08-30-adr-discipline.md` → `.context/notes/`

### Constraints

- **`git mv` в `notes/` — не `git rm`.** Локальная копия у мейнтейнера сохраняется by design.
- **Не восстанавливать префикс `retro-`** в новом пути. Папка = семантика; префикс избыточен.
- **`.gitkeep` в `.context/discussions/`** сохраняется/добавляется в мейнтейнерском слое; в `template/.context/discussions/` уже есть.
- **Директория `.context/history/retros/` — без `.gitkeep`.** Сразу с содержимым (2026-06-21.md), stub не нужен.
- **Не создавать `.context/history/retros/` в `template/`** — шаблон стартует с пустой историей, retros там нет.
- **Feature-ветка:** `feature/split-notes-discussions-retros`.
- **Один атомарный commit** — задача единая тематически (ADR-029), небольшая по объёму. Не разбивать.

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. Retro переехал
test -f .context/history/retros/2026-06-21.md && echo "OK: retro moved"
! test -f .context/discussions/retro-2026-06-21.md && echo "OK: old retro path empty"

# 2. AI-файлы ушли из committed корпуса
for f in 2026-06-08-install-and-mini.md 2026-06-08-mini-claude-md-design.md 2026-06-18-local-llm-agent.md 2026-08-30-adr-discipline.md; do
  if git ls-files --error-unmatch ".context/discussions/$f" 2>/dev/null; then
    echo "FAIL: $f still tracked"
  fi
done
echo "OK: 4 AI files no longer tracked in discussions/"

# 3. discussions/ в мейнтейнерском слое — только .gitkeep
ls .context/discussions/ | grep -qxF ".gitkeep" && [ "$(ls .context/discussions/ | wc -l)" = "1" ] && echo "OK: discussions has only .gitkeep"

# 4. Скилл /retro в обоих слоях пишет в новую директорию
grep -q "history/retros" .claude/skills/meta/cc-retrospective.md && echo "OK: root retro path"
grep -q "history/retros" template/.claude/skills/meta/cc-retrospective.md && echo "OK: template retro path"
! grep -q "discussions/retro-" .claude/skills/meta/cc-retrospective.md && echo "OK: no old path root"
! grep -q "discussions/retro-" template/.claude/skills/meta/cc-retrospective.md && echo "OK: no old path template"

# 5. CLAUDE.md обоих слоёв упоминает history/retros
grep -q "history/retros" CLAUDE.md && echo "OK: root CLAUDE"
grep -q "history/retros" template/CLAUDE.md && echo "OK: template CLAUDE"

# 6. Другие скиллы не ссылаются на discussions/retro-*
! grep -rq "discussions/retro-" .claude/skills/ template/.claude/skills/ && echo "OK: no orphan retro refs"

# 7. template/.context/history/ и template/.context/discussions/ по-прежнему .gitkeep-стабы
[ "$(ls template/.context/history/)" = ".gitkeep" ] && echo "OK: template history stub"
[ "$(ls template/.context/discussions/)" = ".gitkeep" ] && echo "OK: template discussions stub"
```

Manual smoke:

- Открыть `.context/history/retros/2026-06-21.md` — содержимое ретро на месте.
- `.context/notes/` — 4 AI-файла лежат локально, `git status` их не показывает (в `.gitignore`).
- `git log --follow .context/history/retros/2026-06-21.md` — история сохранилась через `git mv`.

### Changes along the way

- **`cc-retrospective.md` step 1 в обоих слоях** — было `.context/history/*.md` — previous status snapshots (if any)`. После ADR-027 файлового status-архива нет; читать `history/*.md` теперь бессмысленно (там `decisions/2026.md` и после этой задачи — `retros/`). Заменено на `.context/history/retros/*.md` — previous retrospectives (for continuity across sessions)`. Это правка тех-долга на пути (устаревшая ссылка после ADR-027), и она осмысленно легла на новый путь: `/retro` теперь читает прошлые ретро, что естественно для continuity.

