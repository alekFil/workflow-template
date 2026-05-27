# Скилл: Экспорт истории чата

Реагирует на фразы: "экспорт истории", "выгрузи историю чата" и вариации.

---

## Алгоритм

### 1. Запустить скрипт

```bash
{RUNTIME_COMMAND} .claude/scripts/export_chat_history.py
```

Пример для uv: `uv run python .claude/scripts/export_chat_history.py`
Пример для обычного Python: `python .claude/scripts/export_chat_history.py`

### 2. Сообщить результат

```text
Экспортировано N сессий в .claude/chat_history/:
  2026-05-14_2a4c678e.md — 247 сообщений, 45 KB
  ...
```

---

## Что делает скрипт

- Читает все `.jsonl`-файлы из `~/.claude/projects/{PROJECT_SLUG}/`
  - `PROJECT_SLUG` = путь к проекту с заменой `/` на `-` и без ведущего `-`
  - Пример: `/home/dev/projects/my-project` → `-home-dev-projects-my-project`
- Извлекает сообщения пользователя и Claude (вызовы инструментов обозначает как `[tool: название]`)
- Сохраняет каждую сессию в `.claude/chat_history/<дата>_<session_id[:8]>.md`
- Пустые сессии (0 сообщений) пропускает

---

## Настройка

При первом использовании: убедись что скрипт `export_chat_history.py` находится
в `.claude/scripts/` и путь `PROJECT_SLUG` в нём указан корректно для твоего проекта.

---

## Ограничения

- Файлы в `.claude/chat_history/` не коммитятся (добавь в `.gitignore`)
- Скрипт перезаписывает файлы при повторном запуске — это нормально
