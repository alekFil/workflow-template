# Статус реализации analytics-workflow-template

Дата: 2026-07-03 (ветка `analytics`)

---

## Что реализовано

**Task 1: Root-layer identity** — завершена (commit ca128da)

- `CLAUDE.md` — идентифицирует репо как analytics-variant; сравнительная таблица dev vs analytics;
  правило синхронизации analytics-скиллов; `/brainstorm` добавлен в таблицу команд (unstaged)
- `CONTRIBUTION.md` — analytics-описание, правило analytics-скиллов (только в template/)
- `SETUP.md` — Python/uv prerequisites, analytics next steps, URL ветки `analytics`
- `.context/blueprint.md` — analytics meta-repo обзор, связь с main, ADR-021/022/023
- `.context/decisions.md` — ADR-001..023 + staged ADR для brainstorm-скилла
- `.context/to-do.md` — 6 задач analytics-ветки (структура задана, не обновлялась с Task 1)
- `.claude/index.md` — analytics-контекст, cc-finding-sync вместо cc-architect-sync
- `.claude/commands/` — 10 файлов зафиксированы; `brainstorm.md` untracked

**Task 2: Template core** — завершена (commit 4b891be)

- `template/CLAUDE.md` — 4 режима: Brainstorm / Analytics Architect / Analyst / Organizer;
  data-таблица источников вместо Stack; analytics plan.md формат; slash commands аналитические;
  Brainstorm mode + строки в таблице — unstaged (part of brainstorm-skill task)
- `template/WORKFLOW.md` — analytics quick reference: таблица команд, workflow цикл
  (вопрос → ноутбук → `/record-finding` → коммит → `/report`/`/present`)
- `template/.claude/index.md` — analytics контекст, findings.md, methodology.md
- `template/.claude/commands/` — 14 файлов: analyze, architect, brainstorm (untracked), close,
  commit, next, organize, present, record, record-finding, report, retro, snapshot, sync

**Brainstorm skill** — в работе, файлы созданы, не закоммичены (из `plan.md`)

- `template/.context/methodology.md` — шаблонный файл: Statistical approach, Key assumptions,
  Validation standards, Model standards, Known data caveats — untracked
- `template/.claude/skills/meta/cc-brainstorm.md` — аналитическая адаптация скилла — untracked
- `.claude/skills/meta/cc-brainstorm.md` — копия для maintainer-слоя — untracked
- `template/.claude/commands/brainstorm.md` — команда — untracked
- `.claude/commands/brainstorm.md` — команда для maintainer-слоя — untracked
- Изменения в `template/CLAUDE.md` и `CLAUDE.md` — unstaged
- `.context/decisions.md` — staged (ADR добавлен)
- `plan.md` — modified unstaged (задача описана, но ещё не закрыта)

---

## Структура проекта

```text
analytics-workflow-template/
├── CLAUDE.md                    ← адаптирован (analytics meta-repo)
├── CONTRIBUTION.md              ← адаптирован
├── SETUP.md                     ← адаптирован (Python/uv)
├── README.md                    ← не адаптирован (унаследован от main)
├── .gitignore
├── .markdownlint.json
├── .claude/
│   ├── index.md                 ← адаптирован
│   ├── commands/                ← 10 файлов (+ brainstorm.md untracked)
│   └── skills/meta/             ← 5 файлов (+ cc-brainstorm.md untracked)
├── .context/
│   ├── blueprint.md             ← переписан (analytics)
│   ├── plan.md                  ← brainstorm-skill task (in progress, unstaged)
│   ├── to-do.md                 ← 6 задач analytics (не обновлялась)
│   ├── status.md                ← этот файл
│   ├── decisions.md             ← ADR-001..023 + staged ADR brainstorm
│   ├── history/                 ← 012 файлов + .gitkeep
│   ├── discussions/             ← 4 файла + .gitkeep
│   └── notes/
├── scripts/
│   ├── install.sh               ← не адаптирован (Task 6)
│   └── uninstall.sh             ← не адаптирован (Task 6)
└── template/
    ├── CLAUDE.md                ← адаптирован: 4 режима, data table, analytics commands (unstaged изменения)
    ├── WORKFLOW.md              ← analytics quick reference
    ├── .gitignore
    ├── .claude/
    │   ├── index.md             ← адаптирован для аналитики
    │   ├── commands/            ← 13 файлов (+ brainstorm.md untracked)
    │   └── skills/meta/         ← 5 файлов (+ cc-brainstorm.md untracked; analytics-specific НЕТ)
    └── .context/
        ├── blueprint.md         ← не адаптирован (Task 3)
        ├── methodology.md       ← шаблон создан (untracked)
        ├── plan.md              ← не адаптирован (Task 3)
        ├── status.md            ← не адаптирован (Task 3)
        ├── to-do.md             ← не адаптирован (Task 3)
        ├── decisions.md         ← не адаптирован (Task 3)
        ├── discussions/ history/ notes/
```

---

## Ключевые технические решения

- **analytics-ветка — постоянная** (ADR-021): не сливается с `main`, независимый шаблон
- **Две ветки на один репо** (ADR-022): `main` = software, `analytics` = data analysis — разные
  шаблоны, разный workflow, ни одна не зависит от другой
- **analytics-скиллы — только в template/** (ADR-023): cc-record-finding, cc-finding-sync,
  cc-report, cc-present не нужны на maintainer-уровне
- **template/CLAUDE.md**: режим Analyst вместо Developer (работает в `main`/`experiment/*`,
  не создаёт feature-ветки); `/sync` заменён на `/snapshot` (нет кода для синхронизации)
- **brainstorm в обоих слоях**: maintainer использует brainstorm для обсуждения улучшений шаблона

---

## Зависимости между компонентами

```text
CLAUDE.md (maintainer)
  ← .claude/commands/           — команды ссылаются на CLAUDE.md
  ← .claude/skills/meta/        — скиллы описаны в CLAUDE.md

template/CLAUDE.md
  ← template/.claude/commands/  — команды используют режимы из CLAUDE.md
  ← template/.claude/skills/meta/ — скиллы описаны в CLAUDE.md

scripts/install.sh → template/  (Task 6, после Tasks 3–5)

template/.claude/commands/record-finding.md → template/.claude/skills/meta/cc-record-finding.md  ← НЕТ
template/.claude/commands/present.md        → template/.claude/skills/meta/cc-present.md         ← НЕТ
template/.claude/commands/sync.md           → template/.claude/skills/meta/cc-finding-sync.md    ← НЕТ
template/.claude/commands/report.md         → template/.claude/skills/meta/cc-report.md          ← НЕТ
```

---

## Что не реализовано из запланированного

- **Brainstorm skill commit** — файлы созданы, но не закоммичены (текущий plan.md)
- **Task 3**: `template/.context/blueprint.md` аналитический формат; `findings.md` (реестр
  выводов); `plan.md`, `status.md`, `to-do.md`, `decisions.md` — analytics формат
- **Task 4**: скиллы `cc-record-finding`, `cc-finding-sync`, `cc-report`, `cc-present` —
  команды для них уже созданы, backing skills отсутствуют
- **Task 5**: директории `template/data/`, `template/notebooks/`, `template/src/`,
  `template/outputs/`; `template/pyproject.toml`; `template/.gitignore` обновление
- **Task 6**: `scripts/install.sh` и `scripts/uninstall.sh` — analytics-specific адаптация
- **README.md** (корень) — унаследован от `main`, не адаптирован под analytics

---

## Вопросы и неопределённости

- **Рассинхрон to-do.md**: Tasks 1 и 2 выполнены, но в `.context/to-do.md` до сих пор помечены
  как активные/следующие. Обновление to-do.md — часть текущего `/report`.
- **Команды без скиллов** (Task 4): `record-finding`, `present`, `sync` (finding-sync),
  `report` — команды существуют, но скиллы отсутствуют. Команды вызывают несуществующие файлы.
- **cc-architect-sync в template/**: по плану (Task 4) — удалить, заменить cc-finding-sync.
  Пока присутствует (унаследован от main).
