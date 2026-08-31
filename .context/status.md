# Статус реализации workflow-template

Дата: 2026-08-31 04:05:00

> Previous state: commit b9af447 (2026-08-31)

---

## Что реализовано

**Мейнтейнерский слой (корень):**

- `CLAUDE.md` — инструкции CC: роли, 11 слэш-команд, конвенции; Language-секция; секции «Components» (ADR-028), «Artifact scope» (ADR-030), «Skill boundaries» (ADR-031), «ADR discipline» (ADR-026)
- `CONTRIBUTION.md` — руководство мейнтейнера на английском
- `SETUP.md` — инструкция по развёртыванию
- **`README.md` — полностью переписан:** hero + Two layers таблица + Quick start + What you get (актуальная структура) + Slash commands (все 11) + Core concepts (ADR discipline / Artifact scope / Skill boundaries) + honest session walkthrough + Contributing + License. 150 строк. P1 blocker для OSS-публикации закрыт.
- `.gitignore` — исключает `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`
- `.markdownlint.json` — конфигурация Markdown (только мейнтейнерский слой)
- `.claude/index.md` — навигатор CC
- `.claude/commands/` — 11 файлов слэш-команд:
  - **`architect.md`** — секция «Branch check» (ADR-030) + секция «After writing plan.md» с подсказкой про `/commit` (ADR-032)
  - **`dev.md`** — усиленный запрет по ADR-031: report only, no auto-commit, ссылка на «Skill boundaries»
  - `record.md` — 4-пункт чек-лист ADR (ADR-026)
  - остальные: `commit`, `close`, `dev`, `next`, `organize`, `polish`, `report`, `retro`, `sync`
- `.claude/skills/meta/` — 6 скиллов:
  - **`cc-commit.md`** — 7 шагов (было 6); новый шаг 3 «Include untracked/modified plan.md» с дефолтом Y (ADR-032); «Why:» convention (ADR-026)
  - **`cc-close-task.md`** — шаг 3 «Clean plan.md» с отдельным коммитом до rebase (ADR-030)
  - `cc-architect-sync.md` — шаг Y orphan-archival ADR (ADR-026); plan.md-violation flag (ADR-030)
  - `cc-retrospective.md` — пишет в `.context/history/retros/YYYY-MM-DD.md` (ADR-029)
  - `cc-code-polish.md` — пайплайн /polish (ADR-023, ADR-024); уже реализует Skill boundaries
  - `cc-status-report.md` — git-pointer вместо file-архива (ADR-027)
- `.claude/skills/project/rules/` — точка расширения /polish: `markdown-conventions.md`, `no-placeholder-leaks.md`
- `.context/blueprint.md`, `to-do.md`, `decisions.md` — на русском
- **`.context/decisions.md`** — 20 активных ADR (после ADR-031, ADR-032)
- `.context/history/decisions/2026.md` — архив: 4 записи (ADR-003, 004, 016, 021)
- `.context/history/retros/2026-06-21.md`, `2026-08-31.md` — 2 retro-файла
- `.context/discussions/` — только `.gitkeep`-стаб (ADR-029)
- `.context/notes/` — приватная директория (в `.gitignore`); содержит AI-user drafts, `two_repo_workflow.md`
- **`.context/plan.md`** — отсутствует (ADR-030: task-local)
- `.context/status.md` — текущий файл; git-указатель на предыдущую версию
- `scripts/install.sh` — 4 плейсхолдера + языковой блок + retry-логика
- `scripts/uninstall.sh` — удаление ассистента

**Шаблонный слой (`template/`) — английский:**

- `template/CLAUDE.md` — 11 slash-команд; секции «Components» с `{PROJECT_LAYOUT}`, «Artifact scope», «Skill boundaries», «ADR discipline»
- `template/WORKFLOW.md` — Initial setup + Typical workday (обновлён с branch-упоминанием для `plan.md`)
- `template/.gitignore` — базовый .gitignore
- `template/.claude/index.md` — навигатор CC
- `template/.claude/commands/` — 11 файлов, синхронно с мейнтейнерскими (архитект с Branch check и After writing plan.md; dev с усиленным запретом)
- `template/.claude/skills/meta/` — 6 скиллов, синхронно
- `template/.claude/skills/project/rules/` — `README.md` + пример `no-dead-code.md`
- `template/.context/*.md` — на английском, с плейсхолдерами: `blueprint`, `decisions`, `status`, `to-do` (**без `plan.md`** — ADR-030)
- `template/.context/notes/`, `history/`, `discussions/` — пустые `.gitkeep`

Изменения с предыдущего статуса (2026-08-31 03:14, commit b9af447):

- **ADR-031** реализован (design + план + impl + close + cleanup)
- **ADR-032** реализован (бандлом на той же ветке `feature/skill-boundaries`)
- **Ретроспектива 2026-08-31** — запись + выход в to-do и ADR-031
- **Приоритет 4** («устранить /dev → авто-commit») — замещён ADR-031 и закрыт
- **Приоритет 5** («Hook-based enforcement Уровень 1+3») — новый пункт, ждёт документирования модели
- **README.md полный rewrite** — Приоритет 1 закрыт; OSS-публикация больше не заблокирована со стороны README
- **20 активных ADR** (было 18)

---

## Структура проекта

```text
workflow-template/
├── CLAUDE.md
├── CONTRIBUTION.md
├── SETUP.md
├── LICENSE
├── README.md                       ← переписан (P1 закрыт)
├── .gitignore
├── .markdownlint.json
├── .claude/
│   ├── index.md
│   ├── settings.local.json         ← в .gitignore
│   ├── commands/                   ← 11 файлов (architect с Branch check + After writing plan.md; dev с запретом)
│   ├── skills/meta/                ← 6 скиллов (cc-commit — 7 шагов; cc-close-task — clean plan.md)
│   └── skills/project/rules/       ← точка расширения (ADR-023)
├── .context/
│   ├── blueprint.md
│   ├── decisions.md                ← 20 активных ADR
│   ├── status.md                   ← git-pointer (ADR-027)
│   ├── to-do.md
│   ├── discussions/                ← .gitkeep-стаб (ADR-029)
│   ├── history/
│   │   ├── decisions/2026.md       ← 4 архивных ADR
│   │   └── retros/                 ← 2 retro-файла (2026-06-21, 2026-08-31)
│   └── notes/                      ← в .gitignore (AI-user private)
├── scripts/
│   ├── install.sh
│   └── uninstall.sh
└── template/
    ├── CLAUDE.md                   ← секции Artifact scope + Skill boundaries + ADR discipline
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   ├── commands/               ← 11 файлов, синхронно
    │   └── skills/
    │       ├── meta/               ← 6 скиллов, синхронно
    │       └── project/rules/      ← README + пример
    └── .context/
        ├── blueprint / decisions / status / to-do   (без plan.md — ADR-030)
        ├── discussions/            ← .gitkeep-стаб
        ├── history/                ← .gitkeep-стаб
        └── notes/                  ← .gitkeep-стаб
```

---

## Ключевые технические решения

- **20 активных ADR** в `decisions.md`; 4 архивных в `history/decisions/2026.md`; 8 удалены из активного корпуса (2, 6, 8, 9, 11, 15, 17, 22)
- Последние ADR:
  - **ADR-032** (Принято): Commit `plan.md` after `/architect` — reviewability guarantee. Two-point defense: подсказка в `/architect` + untracked-check в `/commit` с дефолтом Y. В границах ADR-031.
  - **ADR-031** (Принято): Skill boundaries — команда не исполняет соседний скилл автоматически. Мягкая формулировка: подсказка в тексте допустима. Секция в CLAUDE.md обоих слоёв.
  - **ADR-030** (Принято): `plan.md` как task-local; классификация артефактов по scope (project-wide / task-local / private)
  - **ADR-029** (Принято): three-way split — notes / discussions / history-retros
  - **ADR-028** (Принято): разделение логической карты (Components) и физического дерева (status.md)
  - **ADR-027** (Принято): git-pointer вместо file-архива status.md
  - **ADR-026** (Принято): дисциплина ADR — чек-лист, архивация
- Архивированные (2026): ADR-003, 004, 016, 021

---

## Зависимости между компонентами

```text
CLAUDE.md → раздел «Skill boundaries» → .claude/commands/dev.md (усиленный запрет)
                                     → cc-code-polish.md (уже реализует)
CLAUDE.md → раздел «Artifact scope» → .claude/commands/architect.md (branch check),
                                    → cc-close-task.md (clean plan.md),
                                    → cc-architect-sync.md (plan.md violation flag)
CLAUDE.md → раздел «ADR discipline» → .claude/commands/record.md (чек-лист)
CLAUDE.md → раздел «Components» → .context/status.md (физическое дерево)

.claude/commands/architect.md → After writing plan.md → напоминание про /commit (ADR-032)
.claude/skills/meta/cc-commit.md → step 3 Include plan.md → добавление untracked plan.md с дефолтом Y (ADR-032)

template/CLAUDE.md — симметрично мейнтейнерскому
scripts/install.sh → template/ (4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude

README.md → SETUP.md (инструкция), CONTRIBUTION.md (для контрибьюторов), CLAUDE.md (концепции)
```

---

## Что не реализовано из запланированного

- **Демо-скринкаст** (после MVP — тех.долг): не начато; формат/инструмент не выбраны; отложено до стабилизации модели
- **Тест install.sh end-to-end** (Приоритет 2): не начато
- **Проверка `template/.gitignore` через install.sh** (Приоритет 3): не начато
- **Hook-based enforcement Уровень 1+3** (Приоритет 5, новый):
  - Документировать модель enforcement (какие правила hard, какие soft, критерии) — предварительный шаг
  - Реализовать Уровень 1: `PostToolUse` инвариант-хуки (plan.md на dev, untracked plan.md)
  - Реализовать Уровень 3: `PreToolUse` hard-block (push, commit на защищённой ветке, amend/rebase/reset, write plan.md на dev)
  - Синхронизация в `template/.claude/settings.json`
  - Уровень 2 (prompt-injection reminders) отложен как experiment

---

## Вопросы и неопределённости

- **Демо**: формат и инструмент — открыты; отложено сознательно (сначала стабилизация модели, потом screencast)
- `uninstall.sh` через curl: URL в `SETUP.md` не проверен end-to-end
- Ревизия `to-do.md` (смешивает уровни приоритетов) — сквозная проблема курации, отложена
- **Приоритет 5 (hooks)** — крупная задача; сначала документировать модель enforcement, чтобы избежать hooks, дающих false positives
- Открытые идеи в notes/: local LLM agent, two-repo workflow — созревают до продуктового статуса → ADR обычным путём
