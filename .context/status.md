# Статус реализации workflow-template

Дата: 2026-08-31 03:07:42

> Previous state: commit 0ad93e1 (2026-08-31)

---

## Что реализовано

**Мейнтейнерский слой (корень):**

- `CLAUDE.md` — инструкции CC: роли, 11 слэш-команд, конвенции; Language-секция (Russian / Russian / English / English); секция «Components» (ADR-028); секция «Artifact scope» (ADR-030: project-wide / task-local / private); секция «ADR discipline» (ADR-026)
- `CONTRIBUTION.md` — руководство мейнтейнера на английском
- `SETUP.md` — инструкция по развёртыванию: curl и клон; раздел «Удаление»
- `README.md` — описание репо для GitHub
- `.gitignore` — исключены `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`
- `.markdownlint.json` — конфигурация Markdown (только мейнтейнерский слой)
- `.claude/index.md` — навигатор CC на английском
- `.claude/commands/` — 11 файлов слэш-команд
- **`.claude/commands/architect.md`** — теперь включает секцию «Branch check» (ADR-030: перед записью `plan.md` спросить про feature-ветку без автоматического создания)
- **`.claude/commands/record.md`** — встроен 4-пункт чек-лист ADR (gatekeeper из ADR-026)
- `.claude/skills/meta/` — 6 скиллов:
  - `cc-architect-sync` — шаг Y (orphan-archival ADR, ADR-026); чтение `plan.md` условное + violation flag (ADR-030)
  - `cc-close-task` — новый шаг 3 «Clean plan.md» с отдельным коммитом до rebase (ADR-030); шаги 4-7 перенумерованы
  - `cc-code-polish` — пайплайн /polish (ADR-023, ADR-024)
  - `cc-commit` — секция «Why:» для нетривиальных фиксов (ADR-026)
  - `cc-retrospective` — пишет в `.context/history/retros/YYYY-MM-DD.md` (ADR-029); step 1 читает `history/retros/*.md` для continuity
  - `cc-status-report` — git-pointer вместо file-архива (ADR-027)
- `.claude/skills/project/rules/` — точка расширения (ADR-023): `markdown-conventions.md`, `no-placeholder-leaks.md`
- `.context/blueprint.md`, `to-do.md`, `decisions.md` — на русском
- **`.context/decisions.md`** содержит 18 активных ADR (после ADR-030)
- `.context/history/decisions/2026.md` — архив: 4 записи (ADR-003, 004, 016, 021) с маркерами
- `.context/history/retros/2026-06-21.md` — единственный retro-файл
- `.context/discussions/` — только `.gitkeep` (для будущих human-team-обсуждений, ADR-029)
- `.context/notes/` — приватная директория (в `.gitignore`)
- **`.context/plan.md`** — **отсутствует** (ADR-030: task-local артефакт, живёт только на `feature/*`)
- `.context/status.md` — текущий файл; git-указатель на предыдущую версию (ADR-027)
- `scripts/install.sh` — 4 плейсхолдера + языковой блок [one/multi] + retry-логика (3 попытки, delay 5 s)
- `scripts/uninstall.sh` — удаление ассистента; очищает `.gitignore` и `.git/info/exclude`

**Шаблонный слой (`template/`) — английский, слэш-команды:**

- `template/CLAUDE.md` — 11 слэш-команд; Language-секция с плейсхолдерами; секция «Components» с `{PROJECT_LAYOUT}` (ADR-028); **секция «Artifact scope» (ADR-030)**; секция «ADR discipline» (ADR-026)
- `template/WORKFLOW.md` — шпаргалка; секция «Initial setup»; **Typical workday шаги 2/3 обновлены**: `/architect` упоминает feature-ветку перед `plan.md` (ADR-030), `/dev` не создаёт ветку если уже на ней
- `template/.gitignore` — базовый .gitignore
- `template/.claude/index.md` — навигатор CC на английском
- `template/.claude/commands/` — 11 файлов, включая обновлённый `architect.md` с секцией «Branch check»
- `template/.claude/skills/meta/` — 6 скиллов, синхронно с мейнтейнерскими
- `template/.claude/skills/project/rules/` — `README.md` + пример `no-dead-code.md`
- `template/.context/*.md` — на английском, с плейсхолдерами: `blueprint.md`, `decisions.md`, `status.md`, `to-do.md` (**без `plan.md`** — ADR-030: новый проект стартует без активной задачи)
- `template/.context/notes/`, `history/`, `discussions/` — пустые директории (`.gitkeep`)

Изменения с предыдущего статуса (2026-08-31 03:00, commit 0ad93e1):

- **ADR-030** реализация закрыта через `/close`; естественный ретроактив сработал (commit `53bd5a4 chore: clean plan.md` перед ff-merge → `dev` без `plan.md`)
- **Приоритет 4 в to-do**: устранить `/dev` → авто-commit — записан по замечанию пользователя (commit a725bda). `/dev` по скиллу должен заканчиваться отчётом, но модель на практике предлагает commit-сообщение — граница между `/dev` и `/commit` размыта
- **18 активных ADR** (было 17): добавлен ADR-030

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
│   ├── commands/                 ← 11 файлов (architect.md с Branch check)
│   ├── skills/meta/              ← 6 скиллов
│   └── skills/project/rules/     ← точка расширения (ADR-023)
├── .context/
│   ├── blueprint.md
│   ├── decisions.md              ← 18 активных ADR
│   ├── status.md                 ← git-pointer на предыдущую версию (ADR-027)
│   ├── to-do.md
│   ├── discussions/              ← .gitkeep-стаб (ADR-029)
│   ├── history/
│   │   ├── decisions/2026.md
│   │   └── retros/2026-06-21.md
│   └── notes/                    ← в .gitignore (AI-user private)
├── scripts/
│   ├── install.sh
│   └── uninstall.sh
└── template/
    ├── CLAUDE.md                 ← с секцией Artifact scope
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   ├── commands/             ← 11 файлов
    │   └── skills/
    │       ├── meta/             ← 6 скиллов
    │       └── project/rules/    ← README + пример
    └── .context/
        ├── blueprint.md / decisions.md / status.md / to-do.md   (без plan.md)
        ├── discussions/          ← .gitkeep-стаб
        ├── history/              ← .gitkeep-стаб
        └── notes/                ← .gitkeep-стаб
```

Заметно: **`.context/plan.md` отсутствует в обоих слоях** — по ADR-030 артефакт task-local, появляется только на `feature/*`.

---

## Ключевые технические решения

- **18 активных ADR** в `decisions.md`; 4 архивных в `history/decisions/2026.md`; 8 удалены из активного корпуса (2, 6, 8, 9, 11, 15, 17, 22)
- Последние ADR:
  - **ADR-030** (Принято): `plan.md` как task-local — жизненный цикл (`/architect` создаёт после ветки, `/close` удаляет коммитом `chore: clean plan.md` до ff-merge); классификация артефактов по scope (project-wide / task-local / private) в CLAUDE.md обоих слоёв
  - **ADR-029** (Принято): three-way split — notes (AI-user private) / discussions (team) / history/retros (archived retros)
  - **ADR-028** (Принято): разделение логической карты (CLAUDE.md → Components) и физического дерева (status.md, auto-generated)
  - **ADR-027** (Принято): убрать file-архив status.md, git-указатель
  - **ADR-026** (Принято): дисциплина ADR — 2 уровня, чек-лист, архивация
- Архивированные (все 2026): ADR-003, ADR-004, ADR-016, ADR-021

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/, .claude/index.md, .claude/skills/meta/
CLAUDE.md → раздел «Artifact scope» → .claude/commands/architect.md (branch check),
             .claude/skills/meta/cc-close-task.md (clean plan.md),
             .claude/skills/meta/cc-architect-sync.md (plan.md violation flag)
CLAUDE.md → раздел «ADR discipline» → .claude/commands/record.md (чек-лист)
CLAUDE.md → раздел «Components» → .context/status.md (физическое дерево)
template/CLAUDE.md — симметрично мейнтейнерскому
template/WORKFLOW.md → template/CLAUDE.md, template/.context/*.md
scripts/install.sh → template/ (tar.gz из main; 4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude
.claude/commands/polish.md → .claude/skills/meta/cc-code-polish.md → .claude/skills/project/rules/*.md
.claude/commands/retro.md → .claude/skills/meta/cc-retrospective.md → .context/history/retros/
.claude/commands/record.md (checklist + X-триггер) → .context/decisions.md, .context/history/decisions/
.claude/commands/architect.md (branch check) → .context/plan.md (создание на feature/*)
.claude/skills/meta/cc-close-task.md (clean plan.md) → удаление .context/plan.md до ff-merge
.claude/skills/meta/cc-architect-sync.md (Y-триггер, violation) → .context/decisions.md, .context/plan.md
.claude/skills/meta/cc-status-report.md → .context/status.md (git-pointer)
```

---

## Что не реализовано из запланированного

- **Демо-скринкаст** (Приоритет 1): одна сессия от `/architect` до `/commit` — не начато
- **README полная перезапись** (Приоритет 1): двухслойная структура, демо — не начато
- **Тест install.sh end-to-end** (Приоритет 2): не начато
- **Проверка `template/.gitignore` через install.sh** (Приоритет 3): не начато
- **Дисциплина команд `/dev` → без auto-commit** (Приоритет 4, новый): уточнить `dev.md` в обоих слоях; проверить симметрично `architect.md` и другие команды на сползание в соседние скиллы

---

## Вопросы и неопределённости

- Демо: формат (GIF / скринкаст / ASCII), инструмент записи — не выбраны
- `uninstall.sh` доступен через curl, но URL в `SETUP.md` не проверен end-to-end
- Открытые темы в notes/ (не в git shared context): local LLM agent, two-repo workflow — созревают до продуктового статуса → ADR обычным путём
- Ревизия `to-do.md` (смешивает уровни приоритетов) — сквозная проблема курации, отложенная
- **Наблюдение (обозначено Приоритетом 4):** граница /dev↔/commit размыта не только у меня, но и потенциально у пользователя нового проекта; общее правило «команда не сползает в соседний скилл» стоит зафиксировать явно
- Проверка эффекта ADR-030 в команде: как поведёт себя `/close`, если пользователь забудет очистить `plan.md` — сработает ли merge-конфликт как fail-loud (гипотеза из ADR)
