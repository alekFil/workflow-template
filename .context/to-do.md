# To-Do: analytics-workflow-template

> Список задач по реализации analytics-ветки.
> Ветка `analytics` — постоянная параллельная ветка `workflow-template` для аналитических проектов.
> Ключевые решения: ADR-021, ADR-022, ADR-023.

---

## В работе

### Brainstorm skill — перенос из main с аналитической адаптацией

- [x] Создать `template/.context/methodology.md` — шаблонный файл статистической методологии
- [x] Создать `template/.claude/skills/meta/cc-brainstorm.md` — аналитическая адаптация скилла
- [x] Создать `.claude/skills/meta/cc-brainstorm.md` — копия для maintainer-слоя
- [x] Создать `template/.claude/commands/brainstorm.md`
- [x] Создать `.claude/commands/brainstorm.md`
- [x] Добавить Brainstorm mode в `template/CLAUDE.md` первым в "Your roles"
- [x] Добавить `/brainstorm` и `/brainstorm done` в таблицы команд обоих CLAUDE.md
- [ ] Закоммитить всё вышеперечисленное (`/commit`)

---

## Следующее

### Task 3: Template `.context/` files

- `template/.context/blueprint.md` — переписать: источники данных, схема, пайплайн, стандартный фильтр,
  производные признаки, известные ограничения данных
- `template/.context/findings.md` — создать: реестр выводов, статусы (⏳/✅/⚠️/❌), FINDING-001 placeholder
- `template/.context/plan.md` — адаптировать: analytics формат (Question/Hypothesis/Method/Data)
- `template/.context/status.md` — адаптировать: ссылки на findings.md
- `template/.context/to-do.md` — адаптировать: разделы для гипотез, данных, планируемых анализов
- `template/.context/decisions.md` — адаптировать: analytics placeholder decisions

### Task 4: Analytics skills + commands

Новые скиллы:

- `template/.claude/skills/meta/cc-record-finding.md` — из proposal, адаптировать к slash-commands
- `template/.claude/skills/meta/cc-finding-sync.md` — из proposal, адаптировать
- `template/.claude/skills/meta/cc-report.md` — новый: читает findings.md + ноутбуки, генерирует
  `outputs/report-{date}.md`; структура: Executive Summary → Key Findings → Methodology → Data Notes
- `template/.claude/skills/meta/cc-present.md` — новый: аргумент `jupyter` (пишет presentation.ipynb
  со slideshow-метаданными) или `html` (запускает `nbconvert --to slides`)

Изменения существующих скиллов:

- `template/.claude/skills/meta/cc-close-task.md` — упростить: только `experiment/*` → `main` (ff-only)
- `template/.claude/skills/meta/cc-architect-sync.md` — УДАЛИТЬ (нет кода; заменяется cc-finding-sync)

### Task 5: Template project files

- `template/data/README.md` — провенанс, история версий, ограничения
- `template/notebooks/README.md` — конвенции именования, список с привязкой к FINDING-NNN
- `template/notebooks/.gitkeep`
- `template/src/__init__.py`
- `template/src/analysis_utils.py` — рабочий код: mw_test, chi2_test, bh_correct, run_univariate_battery
- `template/src/README.md` — что в src/, как добавлять функции
- `template/tests/test_analysis_utils.py`
- `template/outputs/README.md` — назначение папки (report-*.md, presentation.ipynb, presentation.html)
- `template/outputs/.gitkeep`
- `template/pyproject.toml` — python/uv, scipy, pandas, jupyter, pytest, nbconvert
- `template/.gitignore` — добавить: `data/*`, `!data/README.md`, `.ipynb_checkpoints/`, `outputs/*.html`
  (html не в git — генерируется), оставить `.context/notes/*.md`

### Task 6: `scripts/install.sh` adaptation

- Переписать `scripts/install.sh`:
  - Сообщения и заголовок — analytics-specific
  - Next steps: `uv sync`, `uv run jupyter lab`, "Run CC and say: read CLAUDE.md"
  - Добавить `.gitignore`-запись для `data/*` и `outputs/*.html` в процессе установки
- Адаптировать `scripts/uninstall.sh`: добавить analytics-specific файлы
  (`findings.md`, `methodology.md`, `data/`, `notebooks/`, `src/`, `outputs/`)

---

## Готово

### Task 1: Branch init + root-layer identity

- [x] Создать ветку `analytics` от `main`
- [x] Переписать `CLAUDE.md` (analytics meta-repo: описание, сравнительная таблица, структура)
- [x] Адаптировать `CONTRIBUTION.md` (два слоя, правила синхронизации analytics-скиллов)
- [x] Адаптировать `SETUP.md` (Python/uv, analytics next steps)
- [x] Переписать `.context/blueprint.md` (что такое этот репо, связь с main)
- [x] Переписать `.context/status.md` (начальное состояние analytics-ветки)
- [x] Адаптировать `.claude/index.md`

### Task 2: Template core — CLAUDE.md + WORKFLOW.md + index.md + commands

- [x] `template/CLAUDE.md` — 4 режима (Brainstorm/Architect/Analyst/Organizer), data table,
  analytics slash commands, notebook conventions, commit types
- [x] `template/WORKFLOW.md` — analytics quick reference с таблицей команд и workflow циклом
- [x] `template/.claude/index.md` — findings.md, methodology.md, analytics skills table
- [x] `template/.claude/commands/` — 13 команд: analyze, architect, close, commit, next,
  organize, present, record, record-finding, report, retro, snapshot, sync
