# workflow-template – Blueprint

> Как устроен шаблон. Отражает фактическую реализацию.
> Обновляется командой `/sync`.

---

## 1. Обзор системы

`workflow-template` – шаблонный репозиторий рабочего процесса для Claude Code. Два
слоя в одном репо: мейнтейнерский (корень) и шаблонный (`template/`), который
`scripts/install.sh` копирует в новый проект.

Назначение и принципы – `docs/product.md`. Решения – `docs/decisions/`.

---

## 2. Компоненты

### 2.1 Мейнтейнерский слой

Живет в корне репо. При развертывании нового проекта – уходит; переносится только `template/`.

- `README.md` – user-facing entry point; переписан под текущую модель (Two layers, Core concepts, все 11 команд, honest session walkthrough)
- `CLAUDE.md` – инструкции для CC: роли, слэш-команды, конвенции; разделы «Components», «Artifact scope», «Skill boundaries», «ADR discipline», «Code conventions», «Markdown conventions»; в «Language» – исключение для файлов стиля (ADR-033)
- `CONTRIBUTION.md` – руководство мейнтейнера
- `SETUP.md` – инструкция по развертыванию шаблона
- `.claude/index.md` – навигатор CC
- `.claude/rules/technical-text-style.md`, `.claude/skills/writing-style/SKILL.md` – правила русского
  текста, на русском (ADR-033)
- `.claude/commands/` – 11 файлов слэш-команд:
  - `architect.md` – разделы «Branch check» (ADR-030) и «After writing plan.md» (ADR-032)
  - `dev.md` – усиленный запрет по ADR-031: report only, no auto-commit, ссылка на «Skill boundaries»
  - `record.md` – 4-пункт чек-лист ADR (ADR-026)
  - остальные: `commit`, `close`, `next`, `organize`, `polish`, `report`, `retro`, `sync`
- `.claude/skills/meta/` – 6 мета-скиллов:
  - `cc-commit.md` – 7 шагов; шаг 3 «Include untracked/modified plan.md» с дефолтом Y (ADR-032); «Why:» convention (ADR-026)
  - `cc-close-task.md` – шаг 3 «Clean plan.md» с отдельным коммитом до rebase (ADR-030)
  - `cc-architect-sync.md` – шаг Y orphan-archival ADR (ADR-026); plan.md-violation flag (ADR-030)
  - `cc-retrospective.md` – пишет в `.context/history/retros/YYYY-MM-DD.md` (ADR-029)
  - `cc-code-polish.md` – пайплайн /polish (ADR-023, ADR-024); уже реализует Skill boundaries
  - `cc-status-report.md` – git-pointer вместо file-архива (ADR-027)
- `.claude/rules/` – точка расширения `/polish` (ADR-023): `markdown-conventions.md` (с проверкой длины строки), `no-placeholder-leaks.md`,
  `dash-conventions.md` (ADR-033)
- `.context/` – рабочая документация мейнтейнера: `blueprint.md`, `status.md`, `to-do.md`, `decisions.md`
- `.context/discussions/` – `.gitkeep`-стаб для будущих human-team-обсуждений (ADR-029)
- `.context/history/decisions/2026.md` – архив 4 замещенных/отклоненных ADR (ADR-026)
- `.context/history/retros/YYYY-MM-DD.md` – archived retros; сейчас 2 файла (2026-06-21, 2026-08-31) (ADR-029)
- `.context/notes/` – личные заметки и AI-диалоги (в `.gitignore`, ADR-011, ADR-029)
- `.context/plan.md` – **отсутствует** на `main`/`dev` (ADR-030: task-local, только на `feature/*`)
- `scripts/install.sh` – curl-установка шаблона
- `scripts/uninstall.sh` – удаление ассистента из проекта через curl

### 2.2 Шаблонный слой

Живет в `template/`. Разворачивается в корень при инициализации нового проекта.

- `template/CLAUDE.md` – CLAUDE.md для нового проекта (с плейсхолдерами); разделы «Components» с `{PROJECT_LAYOUT}` (ADR-028), «Artifact scope» (ADR-030), «Skill boundaries» (ADR-031), «ADR discipline» (ADR-026), «Code conventions» (ё и тире перед `{CODE_CONVENTIONS}`), «Markdown conventions» с длиной строки (ADR-033)
- `template/WORKFLOW.md` – шпаргалка рабочего процесса; таблица плейсхолдеров, Typical workday с описанием feature-ветки перед `plan.md`
- `template/.claude/index.md` – навигатор CC
- `template/.claude/rules/technical-text-style.md`, `writing-style.md` – правила русского
  текста (ADR-033)
- `template/.claude/commands/` – 11 файлов слэш-команд:
  - `architect.md` – секции «Branch check» и «After writing plan.md»
  - `dev.md` – усиленный запрет
  - остальные – зеркало мейнтейнерских
- `template/.claude/skills/meta/` – 6 мета-скиллов (независимая копия мейнтейнерских):
  - `cc-commit.md` – 7 шагов, шаг 3 Include plan.md
  - `cc-close-task.md` – шаг 3 clean plan.md
  - остальные – синхронно
- `template/.claude/rules/` – `README.md` + пример `no-dead-code.md` +
  `dash-conventions.md`, `markdown-conventions.md` (ADR-033)
- `template/.context/` – документация для нового проекта: `blueprint.md`, `status.md`, `to-do.md`, `decisions.md` (**без `plan.md`** – ADR-030)
- `template/.context/notes/`, `discussions/`, `history/` – пустые директории с `.gitkeep`
- `template/.gitignore` – базовый gitignore для нового проекта

### 2.3 Инициализация нового проекта

`scripts/install.sh` – текущий механизм установки:

1. Проверяет зависимости (`git`, `curl`, `tar`) и наличие `.git`
2. При непустой директории показывает список перезаписываемых файлов, запрашивает подтверждение
3. Интерактивно запрашивает: название проекта, remote URL, языковой режим [one/multi] и до трех языковых настроек
4. Спрашивает: скрыть файлы ассистента (→ `.git/info/exclude`), скрыть из коммитов (→ `.claude/settings.json`)
5. Спрашивает: создать начальный коммит? (дефолт `n`), создать ветку `dev`? (дефолт `n`)
6. Скачивает `template/` из репо через GitHub tar.gz (retry 3×, delay 5 s, через `mktemp` + `trap EXIT`)
7. Заполняет плейсхолдеры во всех `.md`: `{PROJECT_NAME}`, `{COMMUNICATION_LANGUAGE}`, `{CONTEXT_LANGUAGE}`, `{CODE_COMMENTS_LANGUAGE}`. `plan.md` в шаблоне отсутствует (ADR-030) – `sed` его не трогает
8. Дополняет `.gitignore` с маркером `# workflow-template:start/end` (не перезаписывает)
9. Применяет выбранные настройки видимости
10. Привязывает remote (если указан)
11. Создает коммит и ветку `dev` (если выбрано)

Запуск: `curl -fsSL .../scripts/install.sh | bash` в пустом `git init`-репозитории.

---

## 3. Потоки использования

### 3.1 Развертывание нового проекта

```text
mkdir my-project && cd my-project
git init
curl -fsSL .../scripts/install.sh | bash
→ интерактивный ввод → готовый репозиторий (без plan.md, с пустыми discussions/, notes/, history/)
```

### 3.2 Мейнтейнинг шаблона

```text
сессия CC в workflow-template
→ /next или /architect (обсуждение; branch-check перед plan.md, ADR-030)
→ /record при необходимости (чек-лист ADR-026)
→ /commit  ← коммит plan.md на feature-ветку для reviewer'а (ADR-032)
→ /dev (реализация на feature-ветке)
→ /commit (impl)
→ /close (шаг Clean plan.md → rebase → ff-merge)
```

### 3.3 Синхронизация улучшений из рабочих проектов

```text
рабочий проект → улучшение скилла или процесса
→ открыть сессию workflow-template → перенести вручную → /commit
```

---

## 4. Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/ (слэш-команды → режимы/скиллы)
CLAUDE.md ← .claude/index.md
CLAUDE.md ← .claude/skills/meta/
CLAUDE.md → раздел «Components» → .context/status.md (физическое дерево, ADR-028)
CLAUDE.md → раздел «Artifact scope» → .claude/skills/architect/SKILL.md (branch check),
             .claude/skills/close/SKILL.md (clean plan.md),
             .claude/skills/sync/SKILL.md (plan.md violation flag)
CLAUDE.md → раздел «Skill boundaries» → .claude/skills/dev/SKILL.md (усиленный запрет),
             cc-code-polish.md (уже реализует по конвенции)
CLAUDE.md → раздел «ADR discipline» → .claude/skills/record/SKILL.md (чек-лист, X-триггер)
CLAUDE.md → разделы «Code conventions», «Markdown conventions» → .claude/rules/technical-text-style.md,
             .claude/rules/dash-conventions.md, markdown-conventions.md (ADR-033)

README.md → SETUP.md (инструкция), CONTRIBUTION.md (для контрибьюторов), CLAUDE.md (для концепций)

template/CLAUDE.md – симметрично мейнтейнерскому
template/WORKFLOW.md → template/CLAUDE.md, template/.context/*.md

scripts/install.sh → template/ (tar.gz из main; 4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude

.claude/skills/polish/SKILL.md → .claude/skills/polish/SKILL.md → .claude/rules/*.md
.claude/skills/retro/SKILL.md → .claude/skills/retro/SKILL.md → .context/history/retros/
.claude/skills/record/SKILL.md → .context/decisions.md (checklist gating + X-триггер архивации в history/decisions/)
.claude/skills/architect/SKILL.md → branch check перед созданием .context/plan.md;
                                 «After writing plan.md» напоминание про /commit (ADR-032)
.claude/skills/commit/SKILL.md → step 3 Include untracked plan.md с дефолтом Y (ADR-032)
.claude/skills/close/SKILL.md → chore: clean plan.md → удаление .context/plan.md перед rebase
.claude/skills/sync/SKILL.md → Y-триггер orphan-archival ADR; violation flag на plan.md
.claude/skills/report/SKILL.md → .context/status.md с git-pointer (ADR-027)
```

---
