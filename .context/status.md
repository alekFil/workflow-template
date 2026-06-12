# Статус реализации workflow-template

Дата: 2026-06-12 (текущий срез)

---

## Что реализовано

**Мейнтейнерский слой:**

- `CLAUDE.md` — инструкции CC: роли, ключевые фразы, конвенции
- `CONTRIBUTION.md` — руководство мейнтейнера
- `SETUP.md` — инструкция по развёртыванию (curl и клон)
- `.gitignore` — добавлен
- `.markdownlint.json` — конфигурация проверки Markdown
- `.claude/index.md` — навигатор CC
- `.claude/skills/meta/cc-commit.md` — скилл "фиксируем"
- `.claude/skills/meta/cc-close-task.md` — скилл "закрываем задачу"
- `.claude/skills/meta/cc-status-report.md` — скилл "текущий статус"
- `.claude/skills/meta/cc-architect-sync.md` — скилл "синхронизируем"
- `.claude/skills/meta/cc-export-chat.md` — скилл "экспорт истории"
- `.claude/settings.local.json` — содержит устаревшие `sed`-разрешения от операции переименования `docs/` → `.context/` (ADR-006); в работе не используется
- `.context/blueprint.md`, `.context/plan.md`, `.context/to-do.md`, `.context/decisions.md` — заполнены
- `.context/discussions/2026-06-08-install-and-mini.md` — обсуждение curl-установки и mini-версии
- `.context/discussions/2026-06-08-mini-claude-md-design.md` — драфт template-mini/CLAUDE.md
- `.context/notes/cc-commands-simplify-patch.md` — патч-файл для переноса упрощения команд в другие проекты
- `.context/notes/markdown-conventions-patch.md` — патч-файл для переноса Markdown-конвенций
- `scripts/install.sh` — curl-установка для пользователей: скачивает `template/` как tar.gz, заполняет плейсхолдеры, делает init commit (ADR-005, ADR-007)

**Шаблонный слой (`template/`):**

- `template/CLAUDE.md` — CLAUDE.md для нового проекта (плейсхолдеры)
- `template/WORKFLOW.md` — шпаргалка рабочего процесса
- `template/.markdownlint.json` — конфигурация markdownlint (идентична корневой)
- `template/.claude/index.md` — навигатор CC (плейсхолдеры)
- `template/.claude/skills/meta/` — независимая копия пяти мета-скиллов
- `template/.context/` — документация с плейсхолдерами: blueprint, plan, to-do, status, decisions

---

## Структура проекта

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
│   ├── settings.local.json       ← устаревшие разрешения от ADR-006
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
│   │   ├── 002-status-2026-06-05.md
│   │   └── 003-status-2026-06-12.md
│   ├── discussions/
│   │   ├── 2026-06-08-install-and-mini.md
│   │   └── 2026-06-08-mini-claude-md-design.md
│   └── notes/
│       ├── cc-commands-simplify-patch.md
│       └── markdown-conventions-patch.md
├── scripts/
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

## Ключевые технические решения

- **ADR-001**: Два слоя — мейнтейнерский (корень) и шаблонный (`template/`)
- **ADR-002**: `index.md` в `.claude/`, не в `docs/`
- **ADR-003**: Cookiecutter — принято, отложено (ADR-005 покрывает текущий сценарий)
- **ADR-004**: Аудит `decisions.md` встроен в `cc-architect-sync`, не отдельным скиллом
- **ADR-005**: `install.sh` для curl-установки
- **ADR-006**: `docs/` переименована в `.context/` в обоих слоях
- **ADR-007**: `scripts/init-project.sh` удалён; `install.sh` — единственный способ установки

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/skills/meta/ (скиллы по ключевым фразам)
CLAUDE.md ← .claude/index.md (навигация)
template/CLAUDE.md ← template/.claude/skills/meta/
template/CLAUDE.md ← template/.claude/index.md
scripts/install.sh → template/ (скачивает как tar.gz; основной способ для пользователей)
```

---

## Что не реализовано из запланированного

- **template-mini** (Приоритет 1): драфт готов, реализация не начата
- **Cookiecutter-инициализация (ADR-003)** (Приоритет 2): отложено до появления стек-специфичного кейса
- **Расширение cc-architect-sync (ADR-004)** (Приоритет 3): решение принято, реализация не начата
- **`.claudeignore`, `skills/project/`** (Приоритет 4): не начато
- **`cc-export-chat.md`-разбор** (Приоритет 5): не начато

---

## Вопросы и неопределённости

- `.claude/settings.local.json` — содержит захардкоженные `sed`-разрешения от переименования ADR-006; можно очистить или удалить (оставить только `"Bash(git *)"`)
- `template-mini` — следующий логичный шаг, но не начат; нужно решить, берём ли в работу
- `cc-export-chat.md` — нужен ли скрипт в шаблоне или только инструкция; не разбирали
- `.context/notes/` — назначение каталога нигде не зафиксировано (патч-файлы для переноса в другие проекты)
