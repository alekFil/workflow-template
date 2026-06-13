# Задача: Предпубликационный аудит — исправить 6 проблем (ADR-009)

## Контекст

Аудит перед публикацией на GitHub выявил блокеры и нестыковки.
Все изменения — в рамках существующих файлов, новые файлы не создаются.
Зависит от: —

## Что реализовать

1. `install.sh` — добавить `git checkout -b dev` после строки `git commit`
2. Удалить `.claude/skills/meta/cc-export-chat.md`
3. Удалить `template/.claude/skills/meta/cc-export-chat.md`
4. Убрать упоминания «экспорт истории» из:
   - `template/CLAUDE.md` (таблица ключевых фраз)
   - `template/WORKFLOW.md` (таблица команд рабочего процесса)
   - `template/.claude/index.md` (таблица мета-скиллов)
   - `.claude/index.md` (таблица мета-скиллов)
5. `.gitignore` — добавить `.claude/settings.local.json`, `.claude/chat_history/`, `.env`
6. `CONTRIBUTION.md` — заменить `"обсудим задачу"` на `"обсудим"` (шаг 2 типичного цикла)
7. `template/WORKFLOW.md` — добавить `text` к code block раздела «Ветки»

## Файлы

Изменить:

- `scripts/install.sh` — добавить `git checkout -b dev`
- `.gitignore` — дополнить тремя строками
- `CONTRIBUTION.md` — исправить фразу
- `template/CLAUDE.md` — убрать строку «экспорт истории»
- `template/WORKFLOW.md` — убрать строку «экспорт истории» + исправить code block
- `template/.claude/index.md` — убрать строку «экспорт истории»
- `.claude/index.md` — убрать строку «экспорт истории»

Удалить:

- `.claude/skills/meta/cc-export-chat.md`
- `template/.claude/skills/meta/cc-export-chat.md`

## Ограничения

- `dev`-ветку в install.sh создавать только после init commit — не до
- Не трогать мейнтейнерский `CLAUDE.md` (в нём нет упоминаний экспорта)
- Не добавлять ничего взамен удалённого скилла

## Проверка

- `grep -r "экспорт истории\|cc-export-chat\|export.chat" . --include="*.md" --include="*.sh" --exclude-dir=.git` — возвращает пусто
- `grep "chat_history\|settings.local\|\.env" .gitignore` — показывает все три строки
- `grep "обсудим задачу" CONTRIBUTION.md` — возвращает пусто
- `tail -5 scripts/install.sh` — содержит `git checkout -b dev`

## Изменения по ходу

(пусто)
