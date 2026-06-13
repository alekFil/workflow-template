# workflow-template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet)](https://claude.ai/code)

Шаблон рабочего процесса для проектов на [Claude Code](https://claude.ai/code).

---

## Зачем

Без шаблона:

- Каждую сессию объясняешь CC заново: что за проект, какой стек, что уже сделано
- Написал "реализуй X" → CC пишет код, хотя нужно было сначала обсудить архитектуру

С шаблоном:

- CC читает `CLAUDE.md` при старте — знает проект, стек, конвенции
- `обсудим X` → CC задаёт вопросы и пишет план, не трогает код
- `начинаем реализацию` → CC читает план и работает строго по нему
- Решения фиксируются в `decisions.md` — сохраняются между сессиями

---

## Быстрый старт

```bash
# 1. Установить Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Авторизоваться (откроется браузер)
claude

# 3. Создать репозиторий проекта
mkdir my-project && cd my-project
git init

# 4. Установить шаблон
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/install.sh | bash

# 5. Запустить Claude Code
claude
```

Первая команда после запуска:

```text
Прочитай CLAUDE.md и подготовь проект к работе. Помоги заполнить оставшиеся плейсхолдеры.
```

Подробнее — в [SETUP.md](SETUP.md).

---

## Рекомендуется

Расширение VS Code [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) — проект уже содержит `.markdownlint.json` с настроенными правилами.

---

## Что входит

- `CLAUDE.md` — инструкции для CC: роли, ключевые фразы, конвенции
- `WORKFLOW.md` — шпаргалка по рабочему процессу
- `.claude/skills/meta/` — мета-скиллы: фиксируем, закрываем задачу, текущий статус, синхронизируем
- `.context/` — структура документации: blueprint, plan, to-do, status, decisions
