# Статус реализации workflow-template

Дата: 2026-06-05

---

## Что реализовано

**Мейнтейнерский слой:**

- `CLAUDE.md` — инструкции CC для работы с этим репо: роли, ключевые фразы, конвенции ветвления
- `CONTRIBUTION.md` — руководство мейнтейнера: рабочий цикл, синхронизация улучшений
- `SETUP.md` — инструкция по развёртыванию шаблона
- `.claude/index.md` — навигатор CC для мейнтейнерского контекста
- `.claude/skills/meta/cc-commit.md` — скилл "фиксируем"
- `.claude/skills/meta/cc-close-task.md` — скилл "закрываем задачу"
- `.claude/skills/meta/cc-status-report.md` — скилл "текущий статус"
- `.claude/skills/meta/cc-architect-sync.md` — скилл "синхронизируем"
- `.claude/skills/meta/cc-export-chat.md` — скилл "экспорт истории"
- `docs/blueprint.md`, `docs/status.md`, `docs/plan.md`, `docs/to-do.md`, `docs/decisions.md` — заполнены реальным содержимым
- `scripts/init-project.sh` — заглушка скрипта инициализации

**Шаблонный слой (`template/`):**

- `template/CLAUDE.md` — CLAUDE.md для нового проекта (плейсхолдеры)
- `template/WORKFLOW.md` — шпаргалка рабочего процесса для нового проекта
- `template/.claude/index.md` — навигатор CC (плейсхолдеры)
- `template/.claude/skills/meta/` — независимая копия пяти мета-скиллов
- `template/docs/` — документация для нового проекта (плейсхолдеры): blueprint, plan, to-do, status, decisions

---

### Структура проекта

```text
workflow-template/
├── CLAUDE.md
├── CONTRIBUTION.md
├── SETUP.md
├── .claude/
│   ├── index.md
│   └── skills/meta/
│       ├── cc-commit.md
│       ├── cc-close-task.md
│       ├── cc-status-report.md
│       ├── cc-architect-sync.md
│       └── cc-export-chat.md
├── docs/
│   ├── blueprint.md
│   ├── plan.md
│   ├── to-do.md
│   ├── status.md
│   ├── decisions.md
│   ├── history/
│   └── discussions/
├── scripts/
│   └── init-project.sh
└── template/
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .claude/
    │   ├── index.md
    │   └── skills/meta/ (5 скиллов)
    └── docs/
        ├── blueprint.md
        ├── plan.md
        ├── to-do.md
        ├── status.md
        ├── decisions.md
        ├── history/
        └── discussions/
```

---

### Ключевые технические решения

- **ADR-001**: Два слоя в одном репо — мейнтейнерский (корень) и шаблонный (`template/`)
- **ADR-002**: Навигатор `index.md` перенесён из `docs/` в `.claude/`

---

### Зависимости между компонентами

```text
CLAUDE.md ← .claude/skills/meta/ (скиллы по ключевым фразам)
CLAUDE.md ← .claude/index.md (навигация)
template/CLAUDE.md ← template/.claude/skills/meta/
template/CLAUDE.md ← template/.claude/index.md
scripts/init-project.sh → template/ (разворачивает шаблон)
```

---

### Что не реализовано из запланированного

- `scripts/init-project.sh`: только заглушка — логика инициализации не реализована (скоуп отдельной задачи)

---

### Вопросы и неопределённости

- Скоуп `scripts/init-project.sh`: какие плейсхолдеры заполнять интерактивно, нужна ли интеграция с GitHub CLI
