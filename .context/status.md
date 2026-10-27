# Статус реализации workflow-template

Дата: 2026-10-27 07:26:54

> Previous state: commit 822d4e8 (2026-10-27)

---

## Что реализовано

**Мейнтейнерский слой (корень):**

- `CLAUDE.md` – инструкции CC: роли, 11 слэш-команд, конвенции; Language-секция с исключением для файлов стиля; секции «Components» (ADR-028), «Artifact scope» (ADR-030), «Skill boundaries» (ADR-031), «ADR discipline» (ADR-026), «Code conventions» и «Markdown conventions» с длиной строки 88 (ADR-033)
- `CONTRIBUTION.md` – руководство мейнтейнера на английском
- `SETUP.md` – инструкция по развертыванию
- `README.md` – entry point; дерево «What you get» включает файлы стиля
- `.gitignore` – исключает `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`
- `.markdownlint.json` – конфигурация Markdown (только мейнтейнерский слой); `MD013` выключен
- `.claude/index.md` – навигатор CC; таблица «Text style»
- `.claude/technical-text-style.md` – правила русского текста по ASD-STE100, на русском (ADR-033)
- `.claude/writing-style.md` – стиль «как пишет человек», только по просьбе владельца (ADR-033)
- `.claude/commands/` – 11 файлов слэш-команд:
  - `architect.md` – секция «Branch check» (ADR-030) + секция «After writing plan.md» (ADR-032)
  - `dev.md` – усиленный запрет по ADR-031: report only, no auto-commit
  - `record.md` – 4-пункт чек-лист ADR (ADR-026)
  - остальные: `commit`, `close`, `next`, `organize`, `polish`, `report`, `retro`, `sync`
- `.claude/skills/meta/` – 6 скиллов:
  - `cc-commit.md` – 7 шагов; шаг 3 «Include untracked/modified plan.md» с дефолтом Y (ADR-032); «Why:» convention (ADR-026)
  - `cc-close-task.md` – шаг 3 «Clean plan.md» с отдельным коммитом до rebase (ADR-030)
  - `cc-architect-sync.md` – шаг Y orphan-archival ADR (ADR-026); plan.md-violation flag (ADR-030)
  - `cc-retrospective.md` – пишет в `.context/history/retros/YYYY-MM-DD.md` (ADR-029)
  - `cc-code-polish.md` – пайплайн /polish (ADR-023, ADR-024)
  - `cc-status-report.md` – git-pointer вместо file-архива (ADR-027)
- `.claude/skills/project/rules/` – точка расширения /polish: `markdown-conventions.md` (с длиной строки), `no-placeholder-leaks.md`, `dash-conventions.md` (ADR-033)
- `.context/blueprint.md`, `to-do.md`, `decisions.md` – на русском
- `.context/decisions.md` – 21 активный ADR (после ADR-033)
- `.context/history/decisions/2026.md` – архив: 4 записи (ADR-003, 004, 016, 021)
- `.context/history/retros/2026-06-21.md`, `2026-08-31.md` – 2 retro-файла
- `.context/discussions/` – только `.gitkeep`-стаб (ADR-029)
- `.context/notes/` – приватная директория (в `.gitignore`)
- `.context/plan.md` – отсутствует (ADR-030: task-local)
- `.context/status.md` – текущий файл; git-указатель на предыдущую версию
- `scripts/install.sh` – 4 плейсхолдера + языковой блок + retry-логика
- `scripts/uninstall.sh` – удаление ассистента

**Шаблонный слой (`template/`) – английский, кроме файлов стиля:**

- `template/CLAUDE.md` – 11 slash-команд; секции «Components» с `{PROJECT_LAYOUT}`, «Artifact scope», «Skill boundaries», «ADR discipline»; «Code conventions» с правилами ё и тире перед `{CODE_CONVENTIONS}`; «Markdown conventions» с длиной строки (ADR-033)
- `template/WORKFLOW.md` – Initial setup + Typical workday; абзац про `rules/` отделяет пример `no-dead-code.md` от правил стиля
- `template/.gitignore` – базовый .gitignore
- `template/.claude/index.md` – навигатор CC; таблица «Text style»
- `template/.claude/technical-text-style.md`, `writing-style.md` – копии мейнтейнерских (ADR-033)
- `template/.claude/commands/` – 11 файлов, синхронно с мейнтейнерскими
- `template/.claude/skills/meta/` – 6 скиллов, синхронно
- `template/.claude/skills/project/rules/` – `README.md`, пример `no-dead-code.md`, `dash-conventions.md`, `markdown-conventions.md` (ADR-033)
- `template/.context/*.md` – на английском, с плейсхолдерами: `blueprint`, `decisions`, `status`, `to-do` (без `plan.md` – ADR-030)
- `template/.context/notes/`, `history/`, `discussions/` – пустые `.gitkeep`

Изменения с предыдущего статуса (2026-08-31 04:05):

- ADR-033 реализован на ветке `feature/text-style`: правила стиля текста в обоих
  слоях.
- Коммит 822d4e8 заменил 808 строк в 42 файлах: длинное тире на короткое, ё на е.
- Запрет bold вместо заголовка не возвращен. ADR-025 действует, кроме п. 4.
- Активных ADR стало 21.

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
│   ├── settings.local.json         ← в .gitignore
│   ├── technical-text-style.md     ← ADR-033
│   ├── writing-style.md            ← ADR-033
│   ├── commands/                   ← 11 файлов
│   ├── skills/meta/                ← 6 скиллов
│   └── skills/project/rules/       ← dash-conventions, markdown-conventions, no-placeholder-leaks
├── .context/
│   ├── blueprint.md
│   ├── decisions.md                ← 21 активный ADR
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
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   ├── technical-text-style.md ← ADR-033
    │   ├── writing-style.md        ← ADR-033
    │   ├── commands/               ← 11 файлов, синхронно
    │   └── skills/
    │       ├── meta/               ← 6 скиллов, синхронно
    │       └── project/rules/      ← README, no-dead-code, dash-conventions, markdown-conventions
    └── .context/
        ├── blueprint / decisions / status / to-do   (без plan.md – ADR-030)
        ├── discussions/            ← .gitkeep-стаб
        ├── history/                ← .gitkeep-стаб
        └── notes/                  ← .gitkeep-стаб
```

---

## Ключевые технические решения

- 21 активный ADR в `decisions.md`; 4 архивных в `history/decisions/2026.md`
- Последние ADR:
  - ADR-033 (Принято): правила стиля текста в обоих слоях. Шаблон получает набор без
    изменений. Старый текст заменен сразу. Заменяет п. 4 ADR-025.
  - ADR-032 (Принято): Commit `plan.md` after `/architect` – reviewability guarantee
  - ADR-031 (Принято): Skill boundaries – команда не исполняет соседний скилл автоматически
  - ADR-030 (Принято): `plan.md` как task-local; классификация артефактов по scope
- Архивированные (2026): ADR-003, 004, 016, 021

---

## Зависимости между компонентами

```text
CLAUDE.md → разделы «Code conventions», «Markdown conventions» → .claude/technical-text-style.md,
             .claude/skills/project/rules/dash-conventions.md, markdown-conventions.md (ADR-033)
CLAUDE.md → раздел «Skill boundaries» → .claude/commands/dev.md (усиленный запрет)
CLAUDE.md → раздел «Artifact scope» → .claude/commands/architect.md (branch check),
                                    → cc-close-task.md (clean plan.md),
                                    → cc-architect-sync.md (plan.md violation flag)
CLAUDE.md → раздел «ADR discipline» → .claude/commands/record.md (чек-лист)
CLAUDE.md → раздел «Components» → .context/status.md (физическое дерево)

.claude/commands/polish.md → cc-code-polish.md → .claude/skills/project/rules/*.md
.claude/commands/architect.md → After writing plan.md → напоминание про /commit (ADR-032)
.claude/skills/meta/cc-commit.md → step 3 Include plan.md с дефолтом Y (ADR-032)

template/CLAUDE.md – симметрично мейнтейнерскому
scripts/install.sh → template/ (4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude
```

---

## Что не реализовано из запланированного

- Демо-скринкаст (после MVP): не начато; формат и инструмент не выбраны
- Тест install.sh end-to-end (Приоритет 2): не начато
- Проверка `template/.gitignore` через install.sh (Приоритет 3): не начато
- Hook-based enforcement Уровень 1+3 (Приоритет 5): не начато; первый шаг –
  документировать модель enforcement

---

## Вопросы и неопределенности

- Длинные строки старого текста не перенесены. `MD013` в `.markdownlint.json` выключен.
  Линтер не проверяет длину строки, проверку выполняет только `/polish`.
- Файлы стиля и правило про ё упоминают букву ё как запрещенный символ. Правило не
  выделяет такие упоминания в исключение, в отличие от `dash-conventions.md`.
- Демо: формат и инструмент открыты
- `uninstall.sh` через curl: URL в `SETUP.md` не проверен end-to-end
- Ревизия `to-do.md` (смешивает уровни приоритетов) отложена
- Открытые идеи в notes/: local LLM agent, two-repo workflow
