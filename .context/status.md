# Статус реализации workflow-template

Дата: 2026-07-08 18:00:00

---

## Что реализовано

**Мейнтейнерский слой (корень):**

- `CLAUDE.md` — инструкции CC: роли, 10 слэш-команд, конвенции; Language-секция (Russian/Russian/English/English); уточнена модель веток (hotfix → main + rebase dev, feature → dev); `/retro` и `/sync` переведены на английский (ADR-008, ADR-009, ADR-018, ADR-019, ADR-020)
- `CONTRIBUTION.md` — руководство мейнтейнера на английском
- `SETUP.md` — инструкция по развёртыванию; curl и клон; раздел «Удаление»
- `README.md` — описание репо для GitHub; секции Demo walkthrough и Contributing
- `.gitignore` — исключены `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`, `memory/`
- `.markdownlint.json` — конфигурация Markdown (только мейнтейнерский слой)
- `.claude/index.md` — навигатор CC на английском с триггерами слэш-команд
- `.claude/commands/` — 10 файлов слэш-команд: `architect.md`, `close.md`, `commit.md`, `dev.md`, `next.md`, `organize.md`, `record.md`, `report.md`, `retro.md`, `sync.md`
- `.claude/skills/meta/cc-architect-sync.md` — добавлен аудит `.claude/skills/project/*.md` (если директория существует); принцип «Skills must match the actual code»
- `.claude/skills/meta/cc-close-task.md`, `cc-commit.md` — точечные исправления из бэкпорта шаблонного слоя
- `.claude/skills/meta/cc-status-report.md`, `cc-retrospective.md` — без изменений с 2026-06-21
- `.context/blueprint.md`, `plan.md`, `to-do.md`, `decisions.md` — на русском; plan.md содержит завершённую задачу fix-install-oss-to-main
- `.context/discussions/` — четыре обсуждения: curl-установка, mini-версия, локальный LLM-агент, ретроспектива 2026-06-21
- `scripts/install.sh` — **исправлен**: скачивает `main.tar.gz` (вместо `oss.tar.gz`), путь распаковки `workflow-template-main/template`; языковой блок вопросов [one/multi]; 4 плейсхолдера (ADR-005, ADR-007, ADR-012, ADR-013, ADR-014, ADR-020)
- `scripts/uninstall.sh` — удаление ассистента; очищает `.gitignore` и `.git/info/exclude`

**Шаблонный слой (`template/`) — английский, слэш-команды:**

- `template/CLAUDE.md` — 10 слэш-команд; Language-секция с тремя плейсхолдерами; `{CODE_CONVENTIONS}` без упоминания Comment language (ADR-014—ADR-020)
- `template/WORKFLOW.md` — шпаргалка; `/retro` в таблице и в "Typical workday"
- `template/.gitignore` — базовый .gitignore для нового проекта
- `template/.claude/index.md` — навигатор CC на английском
- `template/.claude/commands/` — 10 файлов слэш-команд
- `template/.claude/skills/meta/cc-architect-sync.md` — **исправлен**: ссылка `/report` вместо `/status` (ADR-017)
- `template/.claude/skills/meta/cc-status-report.md` — **исправлен**: имя команды `/report` вместо `/status` (ADR-017)
- `template/.claude/skills/meta/cc-commit.md`, `cc-close-task.md`, `cc-retrospective.md` — без изменений
- `template/.context/*.md` — на английском, с плейсхолдерами
- `template/.context/notes/`, `history/`, `discussions/` — пустые директории (`.gitkeep`)

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
│   ├── settings.local.json       ← в .gitignore
│   ├── commands/                 ← 10 файлов слэш-команд
│   └── skills/meta/
│       ├── cc-architect-sync.md
│       ├── cc-close-task.md
│       ├── cc-commit.md
│       ├── cc-retrospective.md
│       └── cc-status-report.md
├── .context/
│   ├── blueprint.md
│   ├── decisions.md
│   ├── plan.md
│   ├── status.md
│   ├── to-do.md
│   ├── discussions/     (4 файла)
│   ├── history/         (012 архивов)
│   └── notes/           ← в .gitignore
├── memory/              ← в .gitignore
├── scripts/
│   ├── install.sh
│   └── uninstall.sh
└── template/
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   ├── commands/    ← 10 файлов слэш-команд
    │   └── skills/meta/ ← 5 скиллов на английском
    └── .context/
        ├── blueprint.md
        ├── decisions.md
        ├── plan.md
        ├── status.md
        ├── to-do.md
        ├── discussions/
        ├── history/
        └── notes/
```

---

## Ключевые технические решения

- **ADR-001–ADR-020**: все действующие (список в `decisions.md`)
- Последнее решение — ADR-020: явная языковая настройка в установщике и CLAUDE.md

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/ (слэш-команды → режимы/скиллы)
CLAUDE.md ← .claude/index.md
CLAUDE.md ← .claude/skills/meta/
template/CLAUDE.md ← template/.claude/commands/
template/CLAUDE.md ← template/.claude/index.md
template/CLAUDE.md ← template/.claude/skills/meta/
scripts/install.sh → template/ (tar.gz; 4 плейсхолдера: PROJECT_NAME + 3 языковых)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude
.claude/commands/retro.md → .claude/skills/meta/cc-retrospective.md
template/.claude/commands/retro.md → template/.claude/skills/meta/cc-retrospective.md
```

---

## Что не реализовано из запланированного

- **Демо-скринкаст** (Приоритет 1): одна сессия от `/architect` до `/commit` — не начато
- **README полная перезапись** (Приоритет 1): двухслойная структура, демо — не начато
- **Управление decisions.md (ADR-004)** (Приоритет 2): `cc-architect-sync` не расширен в части архивации ADR со статусом «Заменено»; `.context/history/decisions/` не создана
- **Тест install.sh end-to-end** (Приоритет 2): не начато
- **Полнота шаблона** (Приоритет 3): нет `.claudeignore` в `template/`, нет `template/.claude/skills/project/`

---

## Вопросы и неопределённости

- Демо: формат (GIF / скринкаст / ASCII), инструмент записи — не выбраны
- `uninstall.sh` доступен через curl, но URL в `SETUP.md` не проверен end-to-end — нужен тест
- `plan.md` содержит завершённую задачу (fix-install-oss-to-main) — нужно очистить или сбросить для следующей задачи
- Обсуждение 2026-06-18: идея локального LLM-агента как альтернативы CC — где будет жить, не решено
- `memory/` в корне репо (автопамять CC) — исключён из git; статус в долгосрочной перспективе не определён
