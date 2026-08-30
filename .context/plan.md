## Task: Убрать file-архив status.md — реализовать ADR-027

### Context

Реализация ADR-027: убираем `.context/history/{N}-status-*.md` как файловый слой, заменяем git-указателем в самом `status.md`. Снимает утечку архива в контекст CC (`.claudeignore` не создан), избавляет `/report` от шага архивации, сокращает шум в репо на ~150 KB и 14 файлов. Затрагивает только status-архив; `.context/history/decisions/<year>.md` не трогаем (референсы из активных ADR по ADR-026).

Depends on: ADR-027.

### What to implement

1. **Обновить `.claude/skills/meta/cc-status-report.md`:**
   - Убрать шаг 1 «Archive the previous status.md» целиком.
   - Добавить новый шаг 1: получить commit hash и дату последнего изменения `status.md` через `git log -1 --format='%h %ai' -- .context/status.md`. Если история пуста (первый `/report`) — pointer не вставляется.
   - В формате нового `status.md` (шаг 2 → станет шаг 3) первой строкой после `# Заголовок` и `Дата:` вставляется pointer:

     ```markdown
     > Previous state: commit <shortsha> (<YYYY-MM-DD>)
     ```

   - Убрать секцию «Working with the history archive» целиком.
   - Финальный report (в конце алгоритма) — не упоминает архивный файл.

2. **Обновить `template/.claude/skills/meta/cc-status-report.md`:** те же правки, английский текст, единая структура.

3. **Удалить 14 файлов `.context/history/{N}-status-*.md`** (001–014) и `.context/history/.gitkeep`. `.context/history/decisions/2026.md` остаётся нетронутым.

4. **Ретрофит `.context/status.md`:** добавить pointer-строку с указанием на актуальный на момент этого коммита hash последнего изменения status.md (до текущей задачи). Определяется через `git log -1 --format='%h %ai' -- .context/status.md` перед началом работы.

5. **Обновить `.context/to-do.md`:** пункт Приоритета 3 «Добавить `.claudeignore` в `template/` (исключить `.context/history/` из контекста CC)» — снять как неактуальный (после ADR-027 в `history/` остаётся только `decisions/`, а его CC должен читать). Перенести в «Готово» с пометкой «отпало (ADR-027)».

6. **Обновить `CLAUDE.md` (root):** в блоке «Repo structure» строку `history/          ← status.md archive` заменить на `history/decisions/ ← archived ADRs (ADR-026)`.

7. **Обновить `template/CLAUDE.md`:** в блоке «Project structure» строку `{  history/     ← status.md archive (not in CC context)}` заменить на `{  history/decisions/ ← archived ADRs}`. Плейсхолдерная разметка `{}` сохраняется.

8. **Проверить `.claude/index.md` и `template/.claude/index.md`** на упоминания status-архива. При наличии — согласовать формулировки. При отсутствии — оставить.

### Files

Edit:

- `.claude/skills/meta/cc-status-report.md` — убрать архивацию, добавить pointer-логику, убрать раздел «Working with the history archive»
- `template/.claude/skills/meta/cc-status-report.md` — то же
- `.context/status.md` — вставить pointer-строку (ретрофит)
- `.context/to-do.md` — снять пункт про `.claudeignore` для `history/`
- `CLAUDE.md` — обновить блок «Repo structure»
- `template/CLAUDE.md` — обновить блок «Project structure» (плейсхолдерная разметка `{}` сохраняется)
- `.claude/index.md`, `template/.claude/index.md` — сверить и при необходимости обновить

Delete:

- `.context/history/001-status-2026-06-05.md`
- `.context/history/002-status-2026-06-05.md`
- `.context/history/003-status-2026-06-12.md`
- `.context/history/004-status-2026-06-13.md`
- `.context/history/005-status-2026-06-13.md`
- `.context/history/006-status-2026-06-20.md`
- `.context/history/007-status-2026-06-20.md`
- `.context/history/008-status-2026-06-20.md`
- `.context/history/009-status-2026-06-20.md`
- `.context/history/010-status-2026-06-21.md`
- `.context/history/011-status-2026-06-21.md`
- `.context/history/012-status-2026-07-08.md`
- `.context/history/013-status-2026-07-15.md`
- `.context/history/014-status-2026-08-30.md`
- `.context/history/.gitkeep`

### Constraints

- **`.context/history/decisions/2026.md` не трогать.** Другой вид истории (ADR-026, references из активных ADR).
- **`template/.context/history/.gitkeep` не удалять.** Шаблонный слой начинает с пустой структуры для нового проекта; там ещё нет ни `decisions/`, ни статусов.
- **Формат pointer-строки строго `> Previous state: commit <shortsha> (<YYYY-MM-DD>)`.** Идентичен в обоих скиллах. `<shortsha>` — 7 символов, `<date>` — только дата коммита, без времени и часового пояса.
- **Ретрофит `.context/status.md`** делается один раз, в этой задаче. Значение `<shortsha>` — из `git log -1 --format='%h %ai' -- .context/status.md`, полученное *до* правок status.md в рамках этой задачи (т.е. hash последнего commit'а, где status.md был обновлён предыдущим `/report`-циклом).
- **Feature-ветка:** `feature/drop-status-archive`.
- **Один атомарный commit** — задача маленькая и связная. Не разбивать.

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. Status-архива больше нет
! ls .context/history/*.md 2>/dev/null | grep -q status
! test -f .context/history/.gitkeep

# 2. decisions-архив на месте
test -f .context/history/decisions/2026.md

# 3. Скилл в обоих слоях не упоминает архивацию status.md
! grep -qi "three-digit\|Archive the previous\|001-status\|N-status-" .claude/skills/meta/cc-status-report.md
! grep -qi "three-digit\|Archive the previous\|001-status\|N-status-" template/.claude/skills/meta/cc-status-report.md

# 4. Скилл в обоих слоях содержит pointer-логику
grep -q "Previous state:" .claude/skills/meta/cc-status-report.md
grep -q "Previous state:" template/.claude/skills/meta/cc-status-report.md
grep -qE "git log.*status.md" .claude/skills/meta/cc-status-report.md
grep -qE "git log.*status.md" template/.claude/skills/meta/cc-status-report.md

# 5. Секция "Working with the history archive" удалена
! grep -qi "Working with the history archive" .claude/skills/meta/cc-status-report.md
! grep -qi "Working with the history archive" template/.claude/skills/meta/cc-status-report.md

# 6. Текущий status.md содержит pointer-строку
grep -qE "^> Previous state: commit [0-9a-f]{7,} \([0-9]{4}-[0-9]{2}-[0-9]{2}\)" .context/status.md

# 7. Шаблонная структура сохраняется
test -f template/.context/history/.gitkeep

# 8. to-do.md обновлён — пункт про .claudeignore для history отсутствует в активных
! grep -q "\[ \] Добавить .claudeignore.*history" .context/to-do.md

# 9. CLAUDE.md обоих слоёв обновлён
! grep -q "history/.*status.md archive" CLAUDE.md
! grep -q "history/.*status.md archive" template/CLAUDE.md
grep -q "history/decisions" CLAUDE.md
grep -q "history/decisions" template/CLAUDE.md
```

Manual smoke:

- Открыть текущий `status.md` — pointer-строка видна первой после заголовка и даты, hash кликабельно копируется.
- `git show <shortsha>:.context/status.md` возвращает содержимое предыдущего status.md — проверка реальной работоспособности механизма.
- Прочитать обновлённый `cc-status-report.md` в обоих слоях — алгоритм пошаговый, без упоминаний архивации.

### Changes along the way

—
