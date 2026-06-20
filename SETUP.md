# Инструкция по развёртыванию workflow-template

Этот шаблон переносит организацию работы с Claude Code в новый проект.

---

## Предварительные требования

### Claude Code

Если Claude Code ещё не установлен:

1. Установить [Node.js](https://nodejs.org) (LTS)
2. Установить Claude Code:

   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

3. Авторизоваться — запустить `claude` и следовать инструкциям
4. Проверить: `claude --version`

### markdownlint (рекомендуется)

Проект содержит `.markdownlint.json`. Установи расширение для VS Code:
[davidanson.vscode-markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)

Или CLI для проверки из терминала:

```bash
npm install -g markdownlint-cli
```

---

## Установка через curl

```bash
mkdir my-project && cd my-project
git init
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/install.sh | bash
```

Скрипт интерактивно запросит название проекта и remote URL, скачает шаблон и сделает начальный коммит.

---

## Удаление

Чтобы удалить ассистента из проекта:

```bash
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/uninstall.sh | bash
```

Скрипт удалит файлы ассистента и вычистит связанные записи из `.gitignore` и `.git/info/exclude`. Коммит не создаётся — зафиксируй изменения вручную.

---

## Начать работу с CC

После развёртывания любым способом:

```text
Прочитай CLAUDE.md и подготовь проект к работе. Помоги заполнить оставшиеся плейсхолдеры.
```

---

## Что входит в шаблон

После развёртывания в новом проекте окажется:

```text
CLAUDE.md                          ← инструкции для CC (с плейсхолдерами → заполняются скриптом)
WORKFLOW.md                        ← шпаргалка по рабочему процессу
.claude/
  index.md                         ← навигатор CC
  skills/
    meta/
      cc-commit.md                 ← скилл "фиксируем"
      cc-close-task.md             ← скилл "закрываем задачу"
      cc-status-report.md          ← скилл "текущий статус"
      cc-architect-sync.md         ← скилл "синхронизируем"

.context/
  blueprint.md                     ← архитектура проекта
  plan.md                          ← текущая задача
  to-do.md                         ← очередь задач
  status.md                        ← состояние реализации
  decisions.md                     ← ADR
  history/                         ← архив status.md (заполняется автоматически)
  discussions/                     ← обсуждения и исследования
```

---

## Если хочешь улучшить шаблон

Работай прямо в этом репо — здесь свой `CLAUDE.md` с инструкциями мейнтейнера.
Подробнее — в `CONTRIBUTION.md`.
