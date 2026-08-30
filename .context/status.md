# Статус реализации workflow-template

Дата: 2026-08-30 03:44:47

> Previous state: commit bb548a8 (2026-07-15)

---

## Что реализовано

**Мейнтейнерский слой (корень):**

- `CLAUDE.md` — инструкции CC: роли, 11 слэш-команд, конвенции; Language-секция (Russian / Russian / English / English); модель веток (hotfix → main + rebase dev, feature → dev); **новая секция «ADR discipline»** (4-пункт чек-лист, механика архивации, конвенция ссылок)
- `CONTRIBUTION.md` — руководство мейнтейнера на английском
- `SETUP.md` — инструкция по развёртыванию: curl и клон; раздел «Удаление»
- `README.md` — описание репо для GitHub; секции Demo walkthrough и Contributing
- `.gitignore` — исключены `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`
- `.markdownlint.json` — конфигурация Markdown (только мейнтейнерский слой)
- `.claude/index.md` — навигатор CC на английском с триггерами слэш-команд
- `.claude/commands/` — 11 файлов слэш-команд (добавлен `polish.md`)
- `.claude/skills/meta/` — 6 скиллов на английском: `cc-architect-sync` (расширен шагом Y — orphan-archival), `cc-close-task`, `cc-code-polish` (новый), `cc-commit` (добавлена секция «Why:»), `cc-retrospective`, `cc-status-report`
- `.claude/skills/project/rules/` — **новая точка расширения (ADR-023)**: `markdown-conventions.md` (4 пункта после отмены bold-as-heading в ADR-025), `no-placeholder-leaks.md`
- `.claude/commands/record.md` — **встроен 4-пункт чек-лист ADR** как gatekeeper (ADR-026)
- `.context/blueprint.md`, `to-do.md`, `decisions.md` — на русском; активный `decisions.md` содержит 14 записей после bulk-переклассификации
- `.context/history/decisions/2026.md` — **новый архив**: 4 архивированных ADR (003, 004, 016, 021) с маркерами в шапке
- `.context/discussions/` — пять обсуждений: curl-установка, mini-версия, локальный LLM-агент, ретроспектива 2026-06-21, **дисциплина ADR 2026-08-30**
- `.context/plan.md` — завершённая задача «Ввести дисциплину ADR» (готова к переписыванию под следующую)
- `scripts/install.sh` — 4 плейсхолдера + языковой блок [one/multi] + retry-логика (3 попытки, delay 5 s, `mktemp` + `trap EXIT`)
- `scripts/uninstall.sh` — удаление ассистента; очищает `.gitignore` и `.git/info/exclude`

**Шаблонный слой (`template/`) — английский, слэш-команды:**

- `template/CLAUDE.md` — 11 слэш-команд; Language-секция с тремя плейсхолдерами; **новая секция «ADR discipline»**
- `template/WORKFLOW.md` — шпаргалка; секция «Initial setup» с таблицей плейсхолдеров; `/retro`, `/polish` в таблице
- `template/.gitignore` — базовый .gitignore для нового проекта
- `template/.claude/index.md` — навигатор CC на английском
- `template/.claude/commands/` — 11 файлов слэш-команд (включая `polish.md`)
- `template/.claude/skills/meta/` — 6 скиллов: `cc-architect-sync` (шаг Y), `cc-close-task`, `cc-code-polish`, `cc-commit` (секция «Why:»), `cc-retrospective`, `cc-status-report`
- `template/.claude/skills/project/rules/` — `README.md` + пример `no-dead-code.md` (ADR-023)
- `template/.claude/commands/record.md` — **встроен чек-лист ADR** (симметрично мейнтейнерскому)
- `template/.context/*.md` — на английском, с плейсхолдерами
- `template/.context/notes/`, `history/`, `discussions/` — пустые директории (`.gitkeep`)

Изменения с предыдущего статуса (2026-07-15):

- **ADR-023** (Принято): команда `/polish` — пайплайн вычистки сгенерированного кода в обоих слоях (commits 502cfb8, 5e56181)
- **ADR-024** (Принято): режим `/polish --all` — полный прогон по проекту, project-rules only, `.polishignore` опционально; наполнены мейнтейнерские правила `markdown-conventions` и `no-placeholder-leaks` (commits 7e7d4cd, 51d20d7)
- **ADR-025** (Принято): отмена правила bold-as-heading — заменяет п.5 ADR-024 (commits a1410a2, 530b2d2, e5c6c8b)
- **ADR-026** (Принято): дисциплина ADR — двухуровневая модель, чек-лист, архивация (commit bc74a02)
- **Bulk-переклассификация 25 ADR:** 13 остались активными, 4 архивированы в `history/decisions/2026.md`, 8 удалены из активного (commit c1ba8d8)
- Задача «Приоритет 2 → управление ростом decisions.md (ADR-004)» — реализована в рамках ADR-026, отмечена как выполненная

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
│   ├── commands/                 ← 11 файлов слэш-команд (+ polish.md)
│   ├── skills/meta/
│   │   ├── cc-architect-sync.md
│   │   ├── cc-close-task.md
│   │   ├── cc-code-polish.md
│   │   ├── cc-commit.md
│   │   ├── cc-retrospective.md
│   │   └── cc-status-report.md
│   └── skills/project/rules/     ← точка расширения (ADR-023)
│       ├── markdown-conventions.md
│       └── no-placeholder-leaks.md
├── .context/
│   ├── blueprint.md
│   ├── decisions.md               ← 14 активных ADR
│   ├── plan.md
│   ├── status.md
│   ├── to-do.md
│   ├── discussions/               (5 файлов)
│   ├── history/                   (014 архивов статуса)
│   │   └── decisions/
│   │       └── 2026.md            ← 4 архивированных ADR (ADR-026)
│   └── notes/                     ← в .gitignore
├── scripts/
│   ├── install.sh
│   └── uninstall.sh
└── template/
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   ├── commands/              ← 11 файлов слэш-команд
    │   └── skills/
    │       ├── meta/              ← 6 скиллов на английском
    │       └── project/rules/     ← README + пример
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

- **ADR-001—ADR-026**: полный список активных — в `decisions.md` (14 записей); архивированных — в `history/decisions/2026.md` (4 записи).
- Последние ADR:
  - **ADR-026** (Принято): дисциплина ADR — 2-уровневая модель (ADR + commit messages), 4-пункт чек-лист как gatekeeper `/record`, архивация в `history/decisions/<year>.md` (триггеры X реактивный + Y периодический), маркеры в шапке, конвенция ссылок; замещает ADR-004
  - **ADR-025** (Принято): отмена правила bold-as-heading — заменяет часть ADR-024 п. 5
  - **ADR-024** (Принято): режим `/polish --all` — полный прогон, project-rules only
  - **ADR-023** (Принято): команда `/polish` — пайплайн вычистки, точка расширения `.claude/skills/project/rules/`
- Архивированные в 2026: **ADR-003** (cookiecutter, заменён ADR-014), **ADR-004** (управление ростом decisions.md, заменён ADR-026), **ADR-016** (двуязычие шаблона, частично заменён ADR-018), **ADR-021** (отказ от dev-only branch)
- Удалены из активного (в git-истории): ADR-002, 006, 008, 009, 011, 015, 017, 022 — тактические фиксы, переименования, punch-list

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/ (слэш-команды → режимы/скиллы)
CLAUDE.md ← .claude/index.md
CLAUDE.md ← .claude/skills/meta/
CLAUDE.md → раздел «ADR discipline» → .claude/commands/record.md (чек-лист)
template/CLAUDE.md ← template/.claude/commands/
template/CLAUDE.md ← template/.claude/index.md
template/CLAUDE.md ← template/.claude/skills/meta/
template/CLAUDE.md → раздел «ADR discipline» → template/.claude/commands/record.md
template/WORKFLOW.md → template/CLAUDE.md, template/.context/*.md (описание плейсхолдеров)
scripts/install.sh → template/ (tar.gz из main; 4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude
.claude/commands/retro.md → .claude/skills/meta/cc-retrospective.md
template/.claude/commands/retro.md → template/.claude/skills/meta/cc-retrospective.md
.claude/commands/polish.md → .claude/skills/meta/cc-code-polish.md → .claude/skills/project/rules/*.md
template/.claude/commands/polish.md → template/.claude/skills/meta/cc-code-polish.md → template/.claude/skills/project/rules/*.md
.claude/commands/record.md (checklist gating) → .context/decisions.md, .context/history/decisions/<year>.md (при триггере X)
.claude/skills/meta/cc-architect-sync.md (шаг Y) → .context/decisions.md, .context/history/decisions/<year>.md
```

---

## Что не реализовано из запланированного

- **Демо-скринкаст** (Приоритет 1): одна сессия от `/architect` до `/commit` — не начато
- **README полная перезапись** (Приоритет 1): двухслойная структура, демо — не начато
- **Тест install.sh end-to-end** (Приоритет 2): не начато (retry-логика проверена только `bash -n`)
- **Полнота шаблона** (Приоритет 3): нет `.claudeignore` в `template/`; `template/.gitignore` через `install.sh` не проверен
- **`plan.md` как branch-local артефакт** (Приоритет 4): не начато — модель, при которой `plan.md` живёт только на `feature/*` и удаляется при `/close`, чтобы команда могла параллельно вести задачи без конфликтов

---

## Вопросы и неопределённости

- Демо: формат (GIF / скринкаст / ASCII), инструмент записи — не выбраны
- `uninstall.sh` доступен через curl, но URL в `SETUP.md` не проверен end-to-end
- Обсуждение 2026-06-18: идея локального LLM-агента как альтернативы CC — где будет жить, не решено
- Обсуждение 2026-08-30 подняло несколько смежных тем, отложенных как отдельные задачи:
  - Two-repo модель для OSS (публичный код + приватный AI-контекст) — cwd-блокеры CC делают её дорогой; альтернативы (submodule, per-branch ACL, overlay, wiki+MCP) не выбраны; после наведения порядка в дисциплине контекста, возможно, не нужна
  - `product.md` как отдельный артефакт (WHAT/WHY vs blueprint HOW) — может быть введён независимо
  - Ревизия `to-do.md` (тоже раздут и смешивает уровни) и `discussions/` (не архивируются) — сквозная проблема курации, не только по ADR
- Проверка эффекта дисциплины ADR-026 — на реальном ADR-027, когда появится: сработает ли чек-лист, удобно ли пользоваться, не станет ли барьер слишком высоким
