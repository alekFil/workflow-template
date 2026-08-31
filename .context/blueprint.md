# workflow-template — Blueprint

> Живой технический референс. Отражает фактическую реализацию.
> Обновляется командой `/sync`.

---

## 1. Обзор системы

`workflow-template` — шаблонный репозиторий рабочего процесса для Claude Code.
Содержит структуру документации, мета-скиллы и скрипт установки.
Устанавливается через curl в новый git-репозиторий.

**Ключевые принципы:**

- Два независимых слоя в одном репо: мейнтейнерский и шаблонный (ADR-001)
- Навигатор CC (`index.md`) живёт в `.claude/`, не в `.context/`
- Скиллы двух слоёв независимы — расходятся по мере развития
- Артефакты `.context/` разделены по scope: project-wide / task-local / private (ADR-030)
- ADR — курируемая категория, проходящая 4-пункт чек-лист (ADR-026); тактика — в commit-сообщениях

---

## 2. Ключевые архитектурные решения

Активный корпус — 18 ADR. Архив — `.context/history/decisions/2026.md`.

| ADR | Суть |
| --- | --- |
| ADR-001 | Два слоя в одном репо: мейнтейнерский (корень) и шаблонный (`template/`) |
| ADR-005 | `install.sh` для curl-установки; `init-project.sh` удалён |
| ADR-007 | `scripts/init-project.sh` удалён; `install.sh` — единственный способ установки |
| ADR-010 | Отказ от `template-mini` — поддерживать два параллельных шаблона нецелесообразно |
| ADR-012 | `install.sh`: безопасный `.gitignore` (дополнение с маркером), управление видимостью ассистента |
| ADR-013 | `install.sh`: опциональные коммит и dev-ветка; `uninstall.sh` — полное удаление ассистента |
| ADR-014 | OSS-публикация: перевод, слэш-команды, демо; отказ от Cookiecutter |
| ADR-018 | Мейнтейнерский слой переведён на английский; слэш-команды добавлены в `.claude/commands/` |
| ADR-019 | `/retro` добавлен как регулярный инструмент рабочего процесса |
| ADR-020 | Явная языковая настройка в установщике: 3 плейсхолдера, вопрос [one/multi] |
| ADR-023 | Команда `/polish` — пайплайн вычистки; свой skill-обёртка над встроенным `simplify`; точка расширения `.claude/skills/project/rules/` |
| ADR-024 | Режим `/polish --all` — полный прогон по проекту, только project-rules |
| ADR-025 | Отмена правила «bold как заголовок» (частично заменяет ADR-024 п.5) |
| ADR-026 | Дисциплина ADR: 2 уровня (ADR + commit-messages), 4-пункт чек-лист, архивация через триггеры X (в `/record`) и Y (в `/sync`) |
| ADR-027 | Убрать file-архив `status.md`, использовать git-указатель на предыдущую версию |
| ADR-028 | Разделение логической карты (`CLAUDE.md` → «Components») и физического дерева (`status.md`, auto-generated) |
| ADR-029 | Three-way split артефактов: `notes/` (AI-user private) / `discussions/` (team) / `history/retros/` (archived retros) |
| ADR-030 | `plan.md` как task-local — жизненный цикл (`/architect` создаёт, `/close` удаляет); классификация по scope в CLAUDE.md обоих слоёв |

**Архивированные ADR** (`.context/history/decisions/2026.md`):

- ADR-003 (Cookiecutter, отклонено → ADR-014)
- ADR-004 (управление ростом decisions.md, заменено ADR-026)
- ADR-016 (двуязычие шаблона, частично заменено ADR-018)
- ADR-021 (отклонено: dev-only branch для файлов ассистента)

---

## 3. Компоненты

### 3.1 Мейнтейнерский слой

Живёт в корне репо. При развёртывании нового проекта — уходит; переносится только `template/`.

- `CLAUDE.md` — инструкции для CC: роли, слэш-команды, конвенции; разделы «Components», «Artifact scope», «ADR discipline», «Markdown conventions»
- `CONTRIBUTION.md` — руководство мейнтейнера
- `SETUP.md` — инструкция по развёртыванию шаблона
- `.claude/index.md` — навигатор CC
- `.claude/commands/` — 11 файлов слэш-команд
- `.claude/skills/meta/` — 6 мета-скиллов: `cc-architect-sync`, `cc-close-task`, `cc-code-polish`, `cc-commit`, `cc-retrospective`, `cc-status-report`
- `.claude/skills/project/rules/` — точка расширения `/polish` (ADR-023): `markdown-conventions.md`, `no-placeholder-leaks.md`
- `.context/` — рабочая документация мейнтейнера: `blueprint.md`, `status.md`, `to-do.md`, `decisions.md`
- `.context/discussions/` — `.gitkeep`-стаб для будущих human-team-обсуждений (ADR-029)
- `.context/history/decisions/2026.md` — архив 4 замещённых/отклонённых ADR (ADR-026)
- `.context/history/retros/YYYY-MM-DD.md` — archived retros (ADR-029)
- `.context/notes/` — личные заметки и AI-диалоги (в `.gitignore`, ADR-011, ADR-029)
- `.context/plan.md` — **отсутствует** на `main`/`dev` (ADR-030: task-local, только на `feature/*`)
- `scripts/install.sh` — curl-установка шаблона
- `scripts/uninstall.sh` — удаление ассистента из проекта через curl

### 3.2 Шаблонный слой

Живёт в `template/`. Разворачивается в корень при инициализации нового проекта.

- `template/CLAUDE.md` — CLAUDE.md для нового проекта (с плейсхолдерами); разделы «Components» с `{PROJECT_LAYOUT}` (ADR-028), «Artifact scope» (ADR-030), «ADR discipline» (ADR-026)
- `template/WORKFLOW.md` — шпаргалка рабочего процесса; таблица плейсхолдеров, Typical workday с описанием feature-ветки перед `plan.md`
- `template/.claude/index.md` — навигатор CC
- `template/.claude/commands/` — 11 файлов слэш-команд (зеркало мейнтейнерского)
- `template/.claude/skills/meta/` — 6 мета-скиллов (независимая копия мейнтейнерских)
- `template/.claude/skills/project/rules/` — `README.md` + пример `no-dead-code.md`
- `template/.context/` — документация для нового проекта: `blueprint.md`, `status.md`, `to-do.md`, `decisions.md` (**без `plan.md`** — ADR-030)
- `template/.context/notes/`, `discussions/`, `history/` — пустые директории с `.gitkeep`
- `template/.gitignore` — базовый gitignore для нового проекта

### 3.3 Инициализация нового проекта

`scripts/install.sh` — текущий механизм установки:

1. Проверяет зависимости (`git`, `curl`, `tar`) и наличие `.git`
2. При непустой директории показывает список перезаписываемых файлов, запрашивает подтверждение
3. Интерактивно запрашивает: название проекта, remote URL, языковой режим [one/multi] и до трёх языковых настроек
4. Спрашивает: скрыть файлы ассистента (→ `.git/info/exclude`), скрыть из коммитов (→ `.claude/settings.json`)
5. Спрашивает: создать начальный коммит? (дефолт `n`), создать ветку `dev`? (дефолт `n`)
6. Скачивает `template/` из репо через GitHub tar.gz (retry 3×, delay 5 s, через `mktemp` + `trap EXIT`)
7. Заполняет плейсхолдеры во всех `.md`: `{PROJECT_NAME}`, `{COMMUNICATION_LANGUAGE}`, `{CONTEXT_LANGUAGE}`, `{CODE_COMMENTS_LANGUAGE}`. `plan.md` в шаблоне отсутствует (ADR-030) — `sed` его не трогает
8. Дополняет `.gitignore` с маркером `# workflow-template:start/end` (не перезаписывает)
9. Применяет выбранные настройки видимости
10. Привязывает remote (если указан)
11. Создаёт коммит и ветку `dev` (если выбрано)

Запуск: `curl -fsSL .../scripts/install.sh | bash` в пустом `git init`-репозитории.

---

## 4. Потоки использования

### 4.1 Развёртывание нового проекта

```text
mkdir my-project && cd my-project
git init
curl -fsSL .../scripts/install.sh | bash
→ интерактивный ввод → готовый репозиторий (без plan.md, с пустыми discussions/, notes/, history/)
```

### 4.2 Мейнтейнинг шаблона

```text
сессия CC в workflow-template
→ /next или /architect (обсуждение; branch-check перед plan.md, ADR-030)
→ /record при необходимости (чек-лист ADR-026)
→ /dev (реализация на feature-ветке)
→ /commit
→ /close (шаг Clean plan.md → rebase → ff-merge)
```

### 4.3 Синхронизация улучшений из рабочих проектов

```text
рабочий проект → улучшение скилла или процесса
→ открыть сессию workflow-template → перенести вручную → /commit
```

---

## 5. Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/ (слэш-команды → режимы/скиллы)
CLAUDE.md ← .claude/index.md
CLAUDE.md ← .claude/skills/meta/
CLAUDE.md → раздел «Components» → .context/status.md (физическое дерево, ADR-028)
CLAUDE.md → раздел «Artifact scope» → .claude/commands/architect.md (branch check),
             .claude/skills/meta/cc-close-task.md (clean plan.md),
             .claude/skills/meta/cc-architect-sync.md (plan.md violation flag)
CLAUDE.md → раздел «ADR discipline» → .claude/commands/record.md (чек-лист, X-триггер)

template/CLAUDE.md — симметрично мейнтейнерскому
template/WORKFLOW.md → template/CLAUDE.md, template/.context/*.md

scripts/install.sh → template/ (tar.gz из main; 4 плейсхолдера; retry x3)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude

.claude/commands/polish.md → .claude/skills/meta/cc-code-polish.md → .claude/skills/project/rules/*.md
.claude/commands/retro.md → .claude/skills/meta/cc-retrospective.md → .context/history/retros/
.claude/commands/record.md → .context/decisions.md (checklist gating + X-триггер архивации в history/decisions/)
.claude/commands/architect.md → branch check перед созданием .context/plan.md
.claude/skills/meta/cc-close-task.md → chore: clean plan.md → удаление .context/plan.md перед rebase
.claude/skills/meta/cc-architect-sync.md → Y-триггер orphan-archival ADR; violation flag на plan.md
.claude/skills/meta/cc-status-report.md → .context/status.md с git-pointer (ADR-027)
```

---

## 6. Реализованные сценарии

- Мейнтейнинг шаблона через CC: роли, слэш-команды, скиллы
- Полная структура шаблонного слоя для нового проекта
- curl-установка через `scripts/install.sh` (ADR-005, ADR-007, ADR-012, ADR-013)
- Рабочая документация в `.context/` (ADR-006)
- Предпубликационный аудит выполнен: шаблон готов к публикации (ADR-014)
- `install.sh` безопасен для существующих проектов: `.gitignore` дополняется, видимость ассистента настраивается (ADR-012, ADR-013)
- Полный перевод на английский, слэш-команды в `.claude/commands/` (ADR-018)
- `/retro` реализован в обоих слоях (ADR-019)
- Явная языковая настройка при установке (ADR-020)
- Retry-логика скачивания в `install.sh` — устойчивость к транзиентным сбоям GitHub
- **`/polish` — пайплайн вычистки сгенерированного кода** (ADR-023): `cc-code-polish` skill-обёртка над встроенным `simplify`; точка расширения `.claude/skills/project/rules/`
- **Режим `/polish --all`** (ADR-024): полный прогон по всем tracked-файлам; project-rules only; наполнены первые правила `markdown-conventions.md` и `no-placeholder-leaks.md`
- **Дисциплина ADR** (ADR-026): 4-пункт чек-лист в `/record`, механика архивации, переклассификация 25 → 14 активных + 4 архивных; синхронизирована в оба слоя
- **File-архив `status.md` убран** (ADR-027): 14 архивных файлов удалены; `/report` пишет git-указатель на предыдущую версию
- **Разделение логической карты и физического дерева** (ADR-028): CLAUDE.md — «Components», status.md — auto-generated tree
- **Three-way split артефактов** (ADR-029): `notes/` AI-private / `discussions/` team / `history/retros/` archived retros
- **`plan.md` как task-local** (ADR-030): жизненный цикл через `/architect` и `/close`; классификация артефактов «Artifact scope» в CLAUDE.md обоих слоёв
