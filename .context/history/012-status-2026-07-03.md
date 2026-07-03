# Статус реализации analytics-workflow-template

Дата: 2026-06-21 (ветка `analytics`)

---

## Что реализовано

**Мейнтейнерский слой (корень) — Task 1:**

- Ветка `analytics` создана от `main` HEAD (ADR-021)
- `CLAUDE.md` — переписан: идентифицирует репо как analytics-variant; сравнительная таблица
  dev vs analytics; обновлена структура (data/, notebooks/, src/, outputs/ в template); правило
  синхронизации analytics-скиллов (только в template/)
- `CONTRIBUTION.md` — адаптирован: analytics-описание, правило analytics-скиллов
- `SETUP.md` — адаптирован: Python/uv prerequisites и next steps; analytics-specific файлы в
  "What the template includes"; URL установки указывает на ветку `analytics`
- `.context/blueprint.md` — переписан: analytics meta-repo обзор, ADR-021/022/023, компоненты
- `.context/status.md` — этот файл
- `.context/decisions.md` — добавлены ADR-021, ADR-022, ADR-023
- `.context/to-do.md` — переписан: 6 задач analytics-ветки
- `.claude/index.md` — адаптирован: analytics-контекст, cc-finding-sync вместо cc-architect-sync

**Шаблонный слой (`template/`) — унаследован от `main`, ещё не адаптирован:**

- Весь template/ из main присутствует (CLAUDE.md, WORKFLOW.md, скиллы, .context/, .gitignore)
- Требует полной адаптации под аналитику в Tasks 2–6

---

## Структура проекта

```text
analytics-workflow-template/
├── CLAUDE.md               ← адаптирован (analytics meta-repo)
├── CONTRIBUTION.md         ← адаптирован
├── SETUP.md                ← адаптирован (Python/uv)
├── LICENSE
├── README.md               ← не адаптирован (унаследован от main)
├── .gitignore
├── .markdownlint.json
├── .claude/
│   ├── index.md            ← адаптирован
│   ├── commands/           ← 9 файлов (без /dev — не нужен мейнтейнеру)
│   └── skills/meta/        ← 5 скиллов (общие; analytics-скиллы только в template)
├── .context/
│   ├── blueprint.md        ← переписан (analytics)
│   ├── plan.md             ← Task 1 (выполнена)
│   ├── to-do.md            ← 6 задач analytics
│   ├── status.md           ← этот файл
│   ├── decisions.md        ← ADR-001..023
│   ├── history/
│   ├── discussions/
│   └── notes/
├── scripts/
│   ├── install.sh          ← не адаптирован (Task 6)
│   └── uninstall.sh        ← не адаптирован (Task 6)
└── template/               ← унаследован от main, ждёт Tasks 2–6
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    └── .context/
```

---

## Что не реализовано

- **Task 2**: `template/CLAUDE.md`, `WORKFLOW.md`, `template/.claude/index.md` — аналитическая адаптация
- **Task 3**: `template/.context/methodology.md`, `findings.md`, analytics-формат plan.md/blueprint.md
- **Task 4**: Analytics-скиллы в template (cc-record-finding, cc-finding-sync, cc-report, cc-present)
- **Task 5**: `template/data/`, `notebooks/`, `src/`, `outputs/`, `pyproject.toml`, `.gitignore` обновление
- **Task 6**: `scripts/install.sh` и `uninstall.sh` — адаптация под аналитику

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/
CLAUDE.md ← .claude/index.md
template/CLAUDE.md ← template/.claude/commands/ (Task 2+4)
template/CLAUDE.md ← template/.claude/skills/meta/ (Task 4)
scripts/install.sh → template/ (Task 6, после Tasks 2–5)
```
