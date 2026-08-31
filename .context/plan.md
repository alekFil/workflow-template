## Task: Переписать README.md — двухслойность, установка через template/, ключевые концепции, entry-point

### Context

Текущий `README.md` отстал: перечисляет 6 из 11 slash-команд, файловая структура не отражает `plan.md` task-local (ADR-030), `history/decisions|retros/`, `.claude/skills/project/rules/`. Двухслойность репо (мейнтейнер + `template/`) упомянута только в разделе Contributing внизу — новый пользователь не понимает главного архитектурного отличия. Ключевые концепции (ADR discipline, Artifact scope, Skill boundaries) отсутствуют. Демо-текст обещает того, чего нет.

Приоритет 1 задача, блокирующая OSS-публикацию.

Depends on: — (текущее состояние скиллов, ADR-026, ADR-029, ADR-030, ADR-031, ADR-032 — контент для секции «Core concepts»).

### What to implement

Полный rewrite `README.md` (не incremental). Новая структура — 8 секций, целевой объём ~80-120 строк.

1. **Hero (1-3 строки):** название + одно предложение о продукте + для кого. Сохранить badges (License, Claude Code).

2. **Two layers (таблица + краткий абзац):** объяснить, что репо содержит два слоя — maintainer (root) и template (`template/`). Таблица «Layer / Purpose / Installed via curl?». Явно указать: пользователь через `install.sh` получает только `template/`.

3. **Quick start:** curl one-liner + первая команда в CC («Read CLAUDE.md and help me fill in the remaining placeholders»). Ссылка на `SETUP.md` для полных деталей.

4. **What you get (файловая структура):** ASCII-дерево того, что получает пользователь после install. Актуальное состояние:
   - `CLAUDE.md`, `WORKFLOW.md`
   - `.claude/commands/` (11 файлов), `.claude/skills/meta/` (6 файлов), `.claude/skills/project/rules/`
   - `.context/blueprint.md`, `status.md`, `to-do.md`, `decisions.md` (без `plan.md` — task-local per ADR-030)
   - `.context/history/`, `.context/notes/` (пустые директории)
   - Комментарий про `plan.md`: «created by `/architect` on feature branches, cleaned by `/close`»

5. **Slash commands (таблица всех 11):** `/organize`, `/architect`, `/next`, `/record`, `/dev`, `/polish`, `/commit`, `/close`, `/report`, `/sync`, `/retro`. Одностроч. описание, без деталей.

6. **Core concepts (3 подраздела, 2-3 строки на каждый):**
   - **ADR discipline (ADR-026):** курируемые архитектурные решения, 4-пункт чек-лист в `/record`; заменённые/отклонённые уходят в архив. См. `CLAUDE.md → ADR discipline`.
   - **Artifact scope (ADR-030):** три класса артефактов `.context/` — project-wide (все ветки), task-local (`plan.md`, только `feature/*`), private (`notes/`, в `.gitignore`). См. `CLAUDE.md → Artifact scope`.
   - **Skill boundaries (ADR-031):** каждый скилл завершается в своих границах; подсказка допустима, автоматическое исполнение соседнего скилла — нет. См. `CLAUDE.md → Skill boundaries`.

7. **What a session looks like (заменяет фейковое «Demo»):** честный short walkthrough — `/architect` → `/commit` (plan.md) → `/dev` → `/commit` → `/close`. С пояснением «this is what a typical task looks like; no screencast yet». Компактно, ~10-15 строк.

8. **Contributing + License:** короткая ссылка на `CONTRIBUTION.md`; MIT.

### Files

Edit:

- `README.md` — полный rewrite согласно секциям 1-8 выше

Create/Delete: —

### Constraints

- **Целевой объём** — ~80-120 строк. Не раздувать в comprehensive-документацию; глубина — через ссылки на `CLAUDE.md`, `WORKFLOW.md`, `SETUP.md`, `CONTRIBUTION.md`.
- **Позиционирование узкое** — «for Claude Code users». Не претендовать на «any AI-assisted workflow» без покрытия других агентов.
- **Не выдумывать features.** Скринкаст не готов — не обещать в тексте, максимум «coming».
- **Файловая структура — актуальная** на момент реализации: 11 команд, 6 скиллов, нет `plan.md` на dev/main, есть `history/decisions|retros/`, есть `.claude/skills/project/rules/`.
- **Все внутренние ссылки на файлы** должны быть корректны (`SETUP.md`, `CONTRIBUTION.md`, `LICENSE`).
- **Badges** — сохранить оба существующих (License + Claude Code). Не добавлять новые (build/npm/etc. — не применимо).
- **Стиль** — английский, tone тот же, что в остальных user-facing файлах.
- **Feature-ветка:** `feature/readme-rewrite` (уже на ней).
- **Один атомарный commit** — задача связная (rewrite одного файла).

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. README содержит новые секции
grep -q "^## Two layers\|## Layers\|## Layer" README.md && echo "OK Two layers"
grep -q "^## Quick start" README.md && echo "OK Quick start"
grep -q "^## What you get" README.md && echo "OK What you get"
grep -q "^## Slash commands\|^## Commands" README.md && echo "OK Commands"
grep -q "^## Core concepts\|^### ADR discipline\|^### Artifact scope\|^### Skill boundaries" README.md && echo "OK Concepts"

# 2. Все 11 slash-команд перечислены
for cmd in organize architect next record dev polish commit close report sync retro; do
  grep -qE "\`/$cmd\`|/$cmd " README.md || echo "FAIL: /$cmd missing"
done
echo "(no FAIL above = all 11 present)"

# 3. Актуальность файловой структуры
grep -q "history/decisions\|history/retros" README.md && echo "OK history/decisions|retros"
grep -qE "project/rules|skills/project" README.md && echo "OK project rules"
! grep -qE "^\|.*plan\.md.*current task" README.md && echo "OK: plan.md not listed as always-present"

# 4. Ссылки на детали
grep -q "SETUP.md" README.md && echo "OK SETUP link"
grep -q "CONTRIBUTION.md" README.md && echo "OK CONTRIBUTION link"
grep -q "CLAUDE.md" README.md && echo "OK CLAUDE ref"

# 5. Объём в целевом диапазоне
lines=$(wc -l < README.md)
echo "README lines: $lines (target ~80-120)"
[ "$lines" -ge 60 ] && [ "$lines" -le 160 ] && echo "OK size in range"

# 6. Badges сохранены
grep -q "MIT" README.md && echo "OK MIT badge"
grep -q "Claude%20Code\|Claude Code" README.md && echo "OK Claude Code badge"
```

Manual smoke:

- Открыть новый README глазами «нового пользователя за 30 секунд»: понимает ли, что это, как поставить, какая ключевая концепция?
- Проверить, что внутренние ссылки (`SETUP.md`, `CONTRIBUTION.md`, `LICENSE`, `CLAUDE.md → ...`) реально ведут в существующие места.
- Проверить, что curl-команда в Quick start корректна (URL, ветка `main`).

### Changes along the way

—
