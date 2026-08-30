## Task: Разделить логическую карту и физическое дерево — реализовать ADR-028

### Context

Реализация ADR-028: `CLAUDE.md` в обоих слоях содержит блок с файловым деревом, который дублирует «Структура проекта» из `status.md` и уже отстал (нет упоминаний `cc-code-polish.md`, `cc-retrospective.md`). Заменяем на компактный блок «Components» — одна строка на компонент, без ASCII-веток. Физическое дерево остаётся в `status.md` (auto-generated при `/report`). В шаблонном слое — симметрично, полностью схематичный вариант с одним плейсхолдером `{PROJECT_LAYOUT}` для проекто-специфичных областей.

Depends on: ADR-028.

### What to implement

1. **Обновить `CLAUDE.md` (root):** заменить раздел «Repo structure» с ASCII-деревом на раздел «Components» с 5-6 строками (одна на компонент). Формат по ADR-028 п.1:

   ```markdown
   ## Components

   - `.claude/` — CC tooling (index, commands, meta-skills, project rules)
   - `.context/` — workflow artifacts (blueprint, plan, to-do, status, decisions, discussions, history/decisions)
   - `scripts/` — user-facing installers (install/uninstall via curl)
   - `template/` — payload deployed into new projects
   - Top-level: `CLAUDE.md`, `CONTRIBUTION.md`, `SETUP.md`, `README.md`, `LICENSE`
   ```

2. **Обновить `template/CLAUDE.md`:** заменить раздел «Project structure» с плейсхолдерным деревом `{PROJECT_STRUCTURE}` на «Components», полностью схематичный:

   ```markdown
   ## Components

   - `.claude/` — CC tooling (index, commands, meta-skills, project rules)
   - `.context/` — workflow artifacts (blueprint, plan, to-do, status, decisions)
   - `{PROJECT_LAYOUT}` — project-specific areas (source code, tests, docs, infrastructure). Fill in during initial setup with a couple of top-level lines.
   ```

3. **Обновить плейсхолдеры в `template/WORKFLOW.md`:** если `{PROJECT_STRUCTURE}` документирован там в таблице плейсхолдеров, заменить на `{PROJECT_LAYOUT}` с обновлённым описанием («logical component map, not a file tree»); если не документирован — добавить строку про `{PROJECT_LAYOUT}` в таблице.

4. **Проверить внешние ссылки на «Repo structure» / «Project structure»** в `CONTRIBUTION.md`, `README.md`, `SETUP.md`, `.claude/index.md`, `template/.claude/index.md`. При наличии — заменить формулировку на «Components» или скорректировать описание. При отсутствии — оставить.

5. **Проверить упоминания плейсхолдера `{PROJECT_STRUCTURE}`** в `scripts/install.sh` — если скрипт делает `sed`-подстановку на него, заменить на `{PROJECT_LAYOUT}` или снять подстановку (если пользователь заполняет вручную).

### Files

Edit:

- `CLAUDE.md` — раздел «Repo structure» → «Components»
- `template/CLAUDE.md` — раздел «Project structure» → «Components», плейсхолдер `{PROJECT_STRUCTURE}` → `{PROJECT_LAYOUT}`
- `template/WORKFLOW.md` — таблица плейсхолдеров: `{PROJECT_STRUCTURE}` → `{PROJECT_LAYOUT}` (или добавить)
- `scripts/install.sh` — если есть `sed s/{PROJECT_STRUCTURE}/.../` — снять или переименовать под `{PROJECT_LAYOUT}`
- Возможно `CONTRIBUTION.md`, `README.md`, `SETUP.md`, `.claude/index.md`, `template/.claude/index.md` — сверить и при необходимости обновить

Create: —

### Constraints

- **`status.md` в обоих слоях не трогать** — там уже auto-generated физическое дерево, оно единственный источник правды по «где что реально лежит».
- **Не восстанавливать ASCII-деревья.** Даже краткое дерево на 5 строк — соблазн, но противоречит ADR-028 (дрейф + смешение уровней). Строго строчный формат «Components».
- **Формулировки «Components» в обоих слоях согласованы по стилю** — «`path/` — one-line purpose». Не путать с длинными описаниями.
- **Плейсхолдеры в `template/CLAUDE.md` остаются в фигурных скобках** и не заполняются реальными значениями (`{PROJECT_LAYOUT}` — только плейсхолдер, не подставляется).
- **Feature-ветка:** `feature/split-structure-map`.
- **Один атомарный commit** — задача маленькая, изменения связаны единой темой (ADR-028). Не разбивать.

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. ASCII-деревья убраны из CLAUDE.md обоих слоёв
if grep -qE "^├──|^│  |^└──" CLAUDE.md; then echo "FAIL: root ASCII tree remains"; else echo "OK root"; fi
if grep -qE "^├──|^│  |^└──" template/CLAUDE.md; then echo "FAIL: template ASCII tree remains"; else echo "OK template"; fi

# 2. Секция «Components» появилась в обоих
grep -q "^## Components" CLAUDE.md && echo "OK: root Components"
grep -q "^## Components" template/CLAUDE.md && echo "OK: template Components"

# 3. Секция «Repo structure» / «Project structure» удалена
! grep -q "^## Repo structure" CLAUDE.md && echo "OK: root has no old section"
! grep -q "^## Project structure" template/CLAUDE.md && echo "OK: template has no old section"

# 4. Плейсхолдер {PROJECT_STRUCTURE} не остался нигде
! grep -rq "{PROJECT_STRUCTURE}" template/ scripts/ && echo "OK: no PROJECT_STRUCTURE leftover"

# 5. Новый плейсхолдер {PROJECT_LAYOUT} присутствует в template/CLAUDE.md
grep -q "{PROJECT_LAYOUT}" template/CLAUDE.md && echo "OK: PROJECT_LAYOUT in template"

# 6. status.md обоих слоёв не тронут
! git diff --name-only HEAD | grep -q "^\.context/status\.md$" && echo "OK: root status.md untouched"
! git diff --name-only HEAD | grep -q "^template/\.context/status\.md$" && echo "OK: template status.md untouched"
```

Manual smoke:

- Прочитать раздел «Components» в обоих `CLAUDE.md` — на глаз соответствует ADR-028, покрывает все реально существующие верхнеуровневые компоненты.
- `status.md` открыть — физическое дерево на месте и актуально (было обновлено недавним `/report`).
- Если `install.sh` содержал `sed` на `{PROJECT_STRUCTURE}` — прогнать `bash -n scripts/install.sh`, убедиться в отсутствии синтаксических ошибок после правок.

### Changes along the way

- **`.claude/skills/project/rules/no-placeholder-leaks.md`** — обновлено упоминание `{PROJECT_STRUCTURE}` → `{PROJECT_LAYOUT}`. Файл перечисляет ожидаемые плейсхолдеры шаблонного слоя; при переименовании плейсхолдера этот список — часть контракта.
- **`.claude/skills/meta/cc-architect-sync.md` и `template/.claude/skills/meta/cc-architect-sync.md`** — блок проверок для `CLAUDE.md` содержал строку «Project structure if it has changed»; после ADR-028 нет секции «Project structure», есть «Components». Строка обновлена — теперь проверяется «`Components` section: new or renamed top-level component; entry outdated relative to actual purpose».
