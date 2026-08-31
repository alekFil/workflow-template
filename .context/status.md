# Статус реализации workflow-template

Дата: 2026-08-31 02:38:38

> Previous state: commit 3673d74 (2026-08-30)

---

## Что реализовано

**Мейнтейнерский слой (корень):**

- `CLAUDE.md` — инструкции CC: роли, 11 слэш-команд, конвенции; Language-секция (Russian / Russian / English / English); модель веток; секция «Components» (логическая карта, ADR-028); секция «ADR discipline» (ADR-026); Components-строка `.context/` содержит `history/decisions` и `history/retros` (ADR-029)
- `CONTRIBUTION.md` — руководство мейнтейнера на английском
- `SETUP.md` — инструкция по развёртыванию: curl и клон; раздел «Удаление»
- `README.md` — описание репо для GitHub
- `.gitignore` — исключены `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`
- `.markdownlint.json` — конфигурация Markdown (только мейнтейнерский слой)
- `.claude/index.md` — навигатор CC на английском
- `.claude/commands/` — 11 файлов слэш-команд (включая `polish`, `retro`)
- `.claude/skills/meta/` — 6 скиллов: `cc-architect-sync` (расширен шагом Y — orphan-archival), `cc-close-task`, `cc-code-polish`, `cc-commit` (секция «Why:»), `cc-retrospective` (переведён на `history/retros/YYYY-MM-DD.md`), `cc-status-report` (упрощён по ADR-027: git-pointer вместо file-архива)
- `.claude/commands/record.md` — встроен 4-пункт чек-лист ADR (gatekeeper из ADR-026)
- `.claude/skills/project/rules/` — точка расширения (ADR-023): `markdown-conventions.md`, `no-placeholder-leaks.md`
- `.context/blueprint.md`, `to-do.md`, `decisions.md` — на русском
- **`.context/decisions.md`** содержит 17 активных ADR (после ADR-029)
- `.context/history/decisions/2026.md` — архив: 4 записи (ADR-003, 004, 016, 021) с маркерами
- `.context/history/retros/2026-06-21.md` — единственный retro-файл (ранее в `discussions/`, перенесён по ADR-029)
- `.context/discussions/` — только `.gitkeep` (для будущих human-team-обсуждений, ADR-029)
- `.context/notes/` — приватная директория (в `.gitignore`): содержит 4 AI-файла бывших discussions, `two_repo_workflow.md` (личная заметка), `.gitkeep`
- `.context/plan.md` — завершённая задача по ADR-029 (готов к переписыванию под следующую)
- `.context/status.md` — текущий файл; git-указатель на предыдущую версию вместо file-архива (ADR-027)
- `scripts/install.sh` — 4 плейсхолдера + языковой блок [one/multi] + retry-логика (3 попытки, delay 5 s)
- `scripts/uninstall.sh` — удаление ассистента; очищает `.gitignore` и `.git/info/exclude`

**Шаблонный слой (`template/`) — английский, слэш-команды:**

- `template/CLAUDE.md` — 11 слэш-команд; Language-секция с плейсхолдерами; секция «Components» (ADR-028) с `{PROJECT_LAYOUT}` для проекто-специфичных областей; секция «ADR discipline» (ADR-026)
- `template/WORKFLOW.md` — шпаргалка; секция «Initial setup» с таблицей плейсхолдеров; путь retro в Typical workday → `history/retros/YYYY-MM-DD.md`
- `template/.gitignore` — базовый .gitignore
- `template/.claude/index.md` — навигатор CC на английском
- `template/.claude/commands/` — 11 файлов
- `template/.claude/skills/meta/` — 6 скиллов (аналогично мейнтейнерскому)
- `template/.claude/commands/record.md` — встроен чек-лист ADR (симметрично)
- `template/.claude/skills/project/rules/` — `README.md` + пример `no-dead-code.md`
- `template/.context/*.md` — на английском, с плейсхолдерами
- `template/.context/notes/`, `history/`, `discussions/` — пустые директории (`.gitkeep`)

Изменения с предыдущего статуса (2026-08-30 04:50, commit 3673d74):

- **ADR-028** (Принято): разделение логической карты (CLAUDE.md → «Components») и физического дерева (status.md) — commit 6eb4212
- **ADR-029** (Принято): three-way split notes/discussions/history-retros; ретроактив: 4 AI-файла перенесены в `notes/`, retro — в `history/retros/2026-06-21.md`; `/retro` обновлён — commit 8c9ede7
- **17 активных ADR** (было 15): добавлены ADR-028, ADR-029
- **Новая директория:** `.context/history/retros/`
- **`.context/discussions/`** сжалась до `.gitkeep`-стаба

---

## Структура проекта

Физическое дерево — актуальное состояние тракинга:

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
│   ├── commands/                 ← 11 файлов
│   ├── skills/meta/              ← 6 скиллов
│   └── skills/project/rules/     ← точка расширения (ADR-023)
│       ├── markdown-conventions.md
│       └── no-placeholder-leaks.md
├── .context/
│   ├── blueprint.md
│   ├── decisions.md              ← 17 активных ADR
│   ├── plan.md
│   ├── status.md                 ← git-pointer на предыдущую версию (ADR-027)
│   ├── to-do.md
│   ├── discussions/              ← .gitkeep-стаб (ADR-029: только human-team)
│   ├── history/
│   │   ├── decisions/2026.md     ← 4 архивных ADR
│   │   └── retros/2026-06-21.md  ← retro (ADR-029)
│   └── notes/                    ← в .gitignore (AI-user private)
├── scripts/
│   ├── install.sh
│   └── uninstall.sh
└── template/
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   ├── commands/             ← 11 файлов
    │   └── skills/
    │       ├── meta/             ← 6 скиллов
    │       └── project/rules/    ← README + пример
    └── .context/
        ├── blueprint.md / decisions.md / plan.md / status.md / to-do.md
        ├── discussions/          ← .gitkeep-стаб
        ├── history/              ← .gitkeep-стаб
        └── notes/                ← .gitkeep-стаб
```

---

## Ключевые технические решения

- **17 активных ADR** в `decisions.md`; 4 архивных в `history/decisions/2026.md`; удалены из активного корпуса 8 (2, 6, 8, 9, 11, 15, 17, 22) — содержимое в git-истории
- Последние ADR:
  - **ADR-029** (Принято): three-way split — `notes/` (AI-user private) / `discussions/` (human team committed) / `history/retros/` (archived retros committed)
  - **ADR-028** (Принято): разделение логической карты (CLAUDE.md → «Components») и физического дерева (status.md, auto-generated)
  - **ADR-027** (Принято): убрать file-архив status.md, реализовать git-указатель
  - **ADR-026** (Принято): дисциплина ADR — 2 уровня (ADR + commit messages), 4-пункт чек-лист, механика архивации через триггеры X и Y
  - **ADR-025** (Принято): отмена правила bold-as-heading
  - **ADR-024** (Принято): режим `/polish --all`
  - **ADR-023** (Принято): команда `/polish`
- Архивированные (все 2026): ADR-003 (cookiecutter → ADR-014), ADR-004 (управление ростом decisions.md → ADR-026), ADR-016 (двуязычие шаблона → ADR-018), ADR-021 (dev-only branch)

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/, .claude/index.md, .claude/skills/meta/
CLAUDE.md → раздел «ADR discipline» → .claude/commands/record.md (чек-лист)
CLAUDE.md → раздел «Components» → .context/status.md (физическое дерево)
template/CLAUDE.md — симметрично мейнтейнерскому
template/WORKFLOW.md → template/CLAUDE.md, template/.context/*.md
scripts/install.sh → template/ (tar.gz из main; 4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude
.claude/commands/polish.md → .claude/skills/meta/cc-code-polish.md → .claude/skills/project/rules/*.md
.claude/commands/retro.md → .claude/skills/meta/cc-retrospective.md → .context/history/retros/
.claude/commands/record.md (checklist gating, X-триггер архивации) → .context/decisions.md, .context/history/decisions/
.claude/skills/meta/cc-architect-sync.md (Y-триггер orphan-archival) → .context/decisions.md, .context/history/decisions/
.claude/skills/meta/cc-status-report.md → .context/status.md (git-pointer, без file-архива)
```

---

## Что не реализовано из запланированного

- **Демо-скринкаст** (Приоритет 1): одна сессия от `/architect` до `/commit` — не начато
- **README полная перезапись** (Приоритет 1): двухслойная структура, демо — не начато
- **Тест install.sh end-to-end** (Приоритет 2): не начато (retry-логика проверена только `bash -n`)
- **Проверка `template/.gitignore` через install.sh** (Приоритет 3): не начато
- **`plan.md` как branch-local артефакт** (Приоритет 4): не начато — модель, при которой `plan.md` живёт только на `feature/*` и удаляется при `/close`

---

## Вопросы и неопределённости

- Демо: формат (GIF / скринкаст / ASCII), инструмент записи — не выбраны
- `uninstall.sh` доступен через curl, но URL в `SETUP.md` не проверен end-to-end
- Открытые темы, вынесенные в notes/ (не в git shared context): local LLM agent, two-repo workflow — созревают до продуктового статуса → ADR обычным путём
- Ревизия `to-do.md` (смешивает уровни приоритетов) — сквозная проблема курации, отложенная в задачах
- Проверка эффекта новой дисциплины: пройдёт ли следующий ADR-030 чек-лист безболезненно, не станет ли барьер завышенным
- `template/.context/history/retros/` не создан — шаблон стартует пустым; создастся при первом `/retro` в новом проекте
