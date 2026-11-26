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

Живет в корне репо. В новый проект не попадает.

- `CLAUDE.md` – контекст для Claude Code: два слоя, навигация, правила, мейнтейнинг.
- `CONTRIBUTION.md`, `SETUP.md`, `README.md` – документация для людей.
- `docs/product.md` – назначение шаблона, принципы, non-goals.
- `docs/decisions/` – ADR по файлу на решение и сгенерированный `README.md`.
  Решения до 2026-11-26 несут `legacy-id: ADR-NNN`.
- `.claude/workflow.conf` – `PROFILE=project`, `BRANCH_MODEL=dev`,
  `MERGE_MODE=local`.
- `.claude/rules/` – правила workflow и текста; плюс `no-placeholder-leaks.md`.
- `.claude/skills/<name>/SKILL.md` – 15 скиллов, копии шаблонных, кроме `organize`.
- `.claude/scripts/workflow.sh` – копия шаблонного скрипта.
- `.context/blueprint.md` – этот файл; `.context/tasks/` – карточки задач;
  `.context/status.md` – генерируется `/report`, не в git.
- `.context/history/retros/` – ретроспективы; `.context/notes/` – приватные заметки.
- `scripts/install.sh`, `scripts/uninstall.sh` – установка и удаление.

### 2.2 Шаблонный слой

`template/` – то, что `install.sh` копирует в новый проект.

- `CLAUDE.md` с плейсхолдерами, `WORKFLOW.md` – справочник владельца.
- `docs/product.md` – заготовка; `docs/decisions/README.md` – пустой индекс.
- `.claude/workflow.conf` – плейсхолдеры `{BRANCH_MODEL}`, `{MERGE_MODE}`; остальные
  ключи установщик переписывает по профилю.
- `.claude/rules/`: `artifacts`, `adr-discipline`, `branching`, `profiles`,
  `skill-boundaries`, `text-conventions`, `markdown-conventions` (`paths:
  **/*.md`), `technical-text-style`, пример `no-dead-code`.
- `.claude/skills/`: `architect`, `next`, `task`, `record`, `dev`, `go`, `polish`
  (с `rules-format.md`), `commit`, `close`, `report`, `sync`, `summary`, `retro`,
  `organize`, `writing-style`. У скиллов, меняющих git или решения, и у
  переключателей режимов – `disable-model-invocation: true`.
- `.claude/scripts/workflow.sh` – `tasks`, `done`, `adr-index`, `bootstrap`.
- `.context/blueprint.md` – заготовка устройства; `tasks/`, `discussions/`,
  `history/`, `notes/` – пустые.
- `.gitignore` – `notes/`, `status.md`, локальные настройки.

### 2.3 Установка

`scripts/install.sh`:

1. Источник шаблона: `WT_SOURCE` (локальный клон) или архив GitHub по `WT_REF`
   (ветка или тег, по умолчанию `main`).
2. Вопросы: профиль, имя, remote, для devmeta – URL кода и upstream, языки, скрытие
   файлов (только `project`), атрибуция, первый коммит, модель ветвления и режим
   слияния (в `contribution` – всегда `trunk` и `pr`).
3. Копирует `template/`, дописывает `.gitignore`, подставляет плейсхолдеры в `.md` и
   `workflow.conf`, переписывает ключи профиля.
4. Devmeta: `code/` в `.gitignore`, `workflow.sh bootstrap` клонирует код, добавляет
   `upstream`, ставит хук против утечки.
5. Модель `dev` в профиле `project`: создает ветку `dev` после первого коммита.

`scripts/uninstall.sh` удаляет `.claude/`, `.context/`, `CLAUDE.md`, `WORKFLOW.md`
и блоки шаблона в `.gitignore` и `.git/info/exclude`. `docs/` сохраняет.

## 3. Потоки использования

### 3.1 Задача

```text
/next или /task → /architect (план в карточке на feature/<slug>) → /commit
→ /dev → /commit → /close (Closes-Task, merge или pull request)
короткий путь: /go
```

### 3.2 Мейнтейнинг шаблона

Изменение затрагивает оба слоя в одной задаче. Ветка `dev` – канал разработки,
`main` – стабильная версия для установки. Тег `v1` – workflow до редизайна 2026-11.

### 3.3 Синхронизация улучшений из рабочих проектов

```text
рабочий проект → улучшение скилла или правила
→ сессия в workflow-template → перенос в оба слоя → /commit
```

## 4. Зависимости между компонентами

```text
.claude/workflow.conf → все скиллы и workflow.sh (пути, профиль, ветки)
.claude/rules/artifacts.md → architect, dev, commit, close, report, sync, summary, task
.claude/rules/adr-discipline.md → record, sync, retro, go, summary
.claude/rules/branching.md → architect, dev, polish, close, go, summary
.claude/rules/profiles.md → commit, close, dev, record
workflow.sh adr-index → docs/decisions/README.md
workflow.sh tasks / done → next, task, report, retro
scripts/install.sh → template/, workflow.sh bootstrap
```
