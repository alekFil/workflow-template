# To-Do: analytics-workflow-template

> Список задач по реализации analytics-ветки.
> Ветка `analytics` — постоянная параллельная ветка `workflow-template` для аналитических проектов.
> Ключевые решения: ADR-021, ADR-022, ADR-023.

---

## В работе

### Task 1: Branch init + root-layer identity

- [ ] Создать ветку `analytics` от `main`
- [ ] Переписать `CLAUDE.md` (analytics meta-repo: описание, сравнительная таблица, структура)
- [ ] Адаптировать `CONTRIBUTION.md` (два слоя, правила синхронизации analytics-скиллов)
- [ ] Адаптировать `SETUP.md` (Python/uv, analytics next steps)
- [ ] Переписать `.context/blueprint.md` (что такое этот репо, связь с main)
- [ ] Переписать `.context/status.md` (начальное состояние analytics-ветки)
- [ ] Адаптировать `.claude/index.md`

---

## Следующее

### Task 2: Template core — CLAUDE.md + WORKFLOW.md + index.md

`template/CLAUDE.md`:

- Данные вместо Stack (таблица источников + `data/README.md`)
- Навигация: добавить `findings.md`, `methodology.md`, `data/README.md`; убрать `/sync` → заменить `/snapshot`
- Режимы: Developer → Analyst (работает в `main` или `experiment/<name>`); Architect → Analytics Architect
  (сверяется с `findings.md` перед предложением метода)
- plan.md формат: Question / Hypothesis / Related findings / Data & filters / Method
- Slash commands: убрать `/dev` и `/sync`; добавить `/record-finding`, `/report` (MD отчёт),
  `/present` (`jupyter`/`html`), `/snapshot` (статус); переименовать `/close` → только для `experiment/*`
- Key analysis rules (вместо "Key architecture rules"): domain-specific placeholders
- Branching: `main` + `experiment/<name>` + `hotfix/<name>` (ADR-022)
- Commit types: `analysis:`, `finding:`, `fix:`, `refactor:`, `docs:`, `chore:`
- Notebook conventions: `NN-short-name.ipynb`, self-contained, run end-to-end before commit

`template/WORKFLOW.md`:

- Таблица режимов и команд (обновлённый набор)
- Типичный цикл: задача → ноутбук → анализ → `/record-finding` → коммит → `/report` или `/present`
- Когда создавать `experiment/<name>` (и когда не нужно)

`template/.claude/index.md`:

- Добавить `findings.md`, `methodology.md`, `data/README.md`
- Обновить таблицу скиллов: добавить cc-record-finding, cc-finding-sync, cc-report, cc-present

### Task 3: Template `.context/` files

- `template/.context/blueprint.md` — переписать: источники данных, схема, пайплайн, стандартный фильтр,
  производные признаки, известные ограничения данных
- `template/.context/methodology.md` — создать: одномерные тесты, многомерные модели, правило сегментов,
  воспроизводимость, глоссарий
- `template/.context/findings.md` — создать: реестр выводов, статусы (⏳/✅/⚠️/❌), FINDING-001 placeholder
- `template/.context/plan.md` — адаптировать: analytics формат (Question/Hypothesis/Method/Data)
- `template/.context/status.md` — адаптировать: ссылки на findings.md
- `template/.context/to-do.md` — адаптировать: разделы для гипотез, данных, планируемых анализов

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

Команды:

- `template/.claude/commands/record-finding.md` — создать
- `template/.claude/commands/report.md` — переписать (аналитический отчёт, не status)
- `template/.claude/commands/present.md` — создать (принимает аргумент `jupyter`/`html`)
- `template/.claude/commands/snapshot.md` — создать (триггерит cc-status-report, бывший `/report`)
- `template/.claude/commands/sync.md` — переписать: триггерит cc-finding-sync
- `template/.claude/commands/dev.md` — УДАЛИТЬ (нет feature-flow в аналитике)
- `template/.claude/commands/retro.md` — сохранить (ретроспектива полезна в аналитике)

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

(нет — ветка только создаётся)
