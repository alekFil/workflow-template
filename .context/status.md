# Статус реализации workflow-template

Дата: 2026-06-12

---

## Что реализовано

**Мейнтейнерский слой:**

- `CLAUDE.md` — инструкции CC: роли, ключевые фразы, конвенции; упрощены фразы активации Архитектора (обсудим задачу → обсудим)
- `CONTRIBUTION.md` — руководство мейнтейнера
- `SETUP.md` — инструкция по развёртыванию; оба способа (curl и клон)
- `.gitignore` — добавлен
- `.markdownlint.json` — конфигурация проверки Markdown (dash-маркеры, код с языком, заголовки, bold)
- `.claude/index.md` — навигатор CC
- `.claude/skills/meta/cc-commit.md` — скилл "фиксируем"
- `.claude/skills/meta/cc-close-task.md` — скилл "закрываем задачу"
- `.claude/skills/meta/cc-status-report.md` — скилл "текущий статус"
- `.claude/skills/meta/cc-architect-sync.md` — скилл "синхронизируем"
- `.claude/skills/meta/cc-export-chat.md` — скилл "экспорт истории"
- `.context/blueprint.md`, `.context/plan.md`, `.context/to-do.md`, `.context/decisions.md` — заполнены
- `.context/discussions/2026-06-08-install-and-mini.md` — обсуждение curl-установки и mini-версии
- `.context/discussions/2026-06-08-mini-claude-md-design.md` — драфт template-mini/CLAUDE.md
- `.context/notes/cc-commands-simplify-patch.md` — патч-файл для переноса упрощения команд в другие проекты
- `.context/notes/markdown-conventions-patch.md` — патч-файл для переноса Markdown-конвенций
- `scripts/init-project.sh` — для мейнтейнера: запускается из клона, предполагает наличие `template/` рядом
- `scripts/install.sh` — для пользователей: скачивается через curl, скачивает `template/` как tar.gz, заполняет плейсхолдеры, делает init commit (ADR-005)

**Шаблонный слой (`template/`):**

- `template/CLAUDE.md` — CLAUDE.md для нового проекта (плейсхолдеры)
- `template/WORKFLOW.md` — шпаргалка рабочего процесса
- `template/.claude/index.md` — навигатор CC (плейсхолдеры)
- `template/.claude/skills/meta/` — независимая копия пяти мета-скиллов
- `template/.markdownlint.json` — конфигурация markdownlint (идентична корневой)
- `template/.context/` — документация с плейсхолдерами: blueprint, plan, to-do, status, decisions

---

### Структура проекта

```text
workflow-template/
├── CLAUDE.md
├── CONTRIBUTION.md
├── SETUP.md
├── LICENSE
├── README.md
├── .gitignore
├── .markdownlint.json
├── .claude/
│   ├── index.md
│   └── skills/meta/
│       ├── cc-commit.md
│       ├── cc-close-task.md
│       ├── cc-status-report.md
│       ├── cc-architect-sync.md
│       └── cc-export-chat.md
├── .context/
│   ├── blueprint.md
│   ├── plan.md
│   ├── to-do.md
│   ├── status.md
│   ├── decisions.md
│   ├── history/
│   │   ├── 001-status-2026-06-05.md
│   │   └── 002-status-2026-06-05.md
│   ├── discussions/
│   │   ├── 2026-06-08-install-and-mini.md
│   │   └── 2026-06-08-mini-claude-md-design.md
│   └── notes/
│       ├── cc-commands-simplify-patch.md
│       └── markdown-conventions-patch.md
├── scripts/
│   ├── init-project.sh
│   └── install.sh
└── template/
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .markdownlint.json
    ├── .claude/
    │   ├── index.md
    │   └── skills/meta/ (5 скиллов)
    └── .context/
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

- **ADR-001**: Два слоя — мейнтейнерский (корень) и шаблонный (`template/`)
- **ADR-002**: `index.md` в `.claude/`, не в `docs/` (переименована в `.context/`)
- **ADR-003**: Cookiecutter — принято, отложено (ADR-005 покрывает текущий сценарий)
- **ADR-004**: Аудит `decisions.md` встроен в `cc-architect-sync`, не отдельным скиллом
- **ADR-005**: `install.sh` для curl-установки; `init-project.sh` остаётся для мейнтейнера

---

### Зависимости между компонентами

```text
CLAUDE.md ← .claude/skills/meta/ (скиллы по ключевым фразам)
CLAUDE.md ← .claude/index.md (навигация)
template/CLAUDE.md ← template/.claude/skills/meta/
template/CLAUDE.md ← template/.claude/index.md
scripts/install.sh → template/ (скачивает как tar.gz; основной способ для пользователей)
scripts/init-project.sh → template/ (для мейнтейнера, локальный запуск)
```

---

### Что не реализовано из запланированного

- **template-mini**: решение принято, драфт готов (`.context/discussions/2026-06-08-mini-claude-md-design.md`), реализация не начата — нет в to-do.md
- **Cookiecutter-инициализация (ADR-003)**: отложено до появления стек-специфичного кейса
- **Расширение cc-architect-sync (ADR-004)**: решение принято, реализация не начата — Приоритет 2 в to-do.md
- **`.claudeignore`, `skills/project/`**: Приоритет 4
- **`cc-export-chat.md`**: разбор отложен, Приоритет 5

---

### Вопросы и неопределённости

- `template-mini` — следующий логичный шаг, но не добавлен в to-do.md; нужно решить, берём ли в работу
- `cc-export-chat.md` — нужен ли скрипт в шаблоне или только инструкция; не разбирали
- `.context/notes/` — назначение каталога нигде не зафиксировано (патч-файлы для переноса в другие проекты)
