# Задача: OSS-публикация (ADR-014, ADR-015, ADR-016)

## Контекст

Ветка: `oss` (создать от `main` перед началом реализации)
Цель: перевести шаблонный слой на английский, заменить ключевые фразы на слэш-команды, убрать markdownlint.
Мейнтейнерский слой (корень, `.context/`, `.claude/`) — не трогать, остаётся на русском.

## Фаза А: Markdownlint (ADR-015)

Технические правки, без переводов.

1. `template/.markdownlint.json` — удалить файл
2. `scripts/install.sh` — убрать `.markdownlint.json` из предупреждения о перезаписи
3. `scripts/uninstall.sh` — убрать отдельный вопрос про `.markdownlint.json`; убрать из списка файлов
4. `README.md` — убрать упоминание markdownlint

## Фаза Б: Перевод и слэш-команды (ADR-014, ADR-016)

### template/CLAUDE.md

- Полный перевод на английский
- Заменить ключевые фразы на слэш-команды (конкретные имена — решить при реализации, зафиксировать в decisions.md)
- Добавить инструкцию: «Respond in the user's language»
- `{ПЛЕЙСХОЛДЕРЫ}` не трогать

### template/WORKFLOW.md

- Полный перевод на английский
- `{ПЛЕЙСХОЛДЕРЫ}` не трогать

### template/.claude/index.md

- Полный перевод на английский

### template/.claude/skills/meta/ (4 файла)

- `cc-commit.md`
- `cc-close-task.md`
- `cc-status-report.md`
- `cc-architect-sync.md`
- Полный перевод на английский

### template/.context/ (5 файлов)

- `blueprint.md`, `plan.md`, `to-do.md`, `status.md`, `decisions.md`
- Перевести заголовки, инструкции и пояснения; `{ПЛЕЙСХОЛДЕРЫ}` не трогать

### README.md

- Базовый перевод на английский (глубокая переработка — в фазе В)

### SETUP.md

- Полный перевод на английский
- В curl-командах: `main` → `oss` (пока ветка не слита в main)

### scripts/install.sh, scripts/uninstall.sh

- Перевести весь пользовательский вывод: сообщения, вопросы, подсказки

## Фаза В: README и демо (ADR-014)

(после завершения фазы Б)

1. Переписать `README.md`: объяснить двухслойную структуру, показать что устанавливается через `template/`
2. Снять демо: одна сессия от `/architect` до `/commit`

## Файлы

### Фаза А

- `template/.markdownlint.json` — удалить
- `scripts/install.sh` — правка
- `scripts/uninstall.sh` — правка
- `README.md` — правка

### Фаза Б

- `template/CLAUDE.md`
- `template/WORKFLOW.md`
- `template/.claude/index.md`
- `template/.claude/skills/meta/cc-commit.md`
- `template/.claude/skills/meta/cc-close-task.md`
- `template/.claude/skills/meta/cc-status-report.md`
- `template/.claude/skills/meta/cc-architect-sync.md`
- `template/.context/blueprint.md`
- `template/.context/plan.md`
- `template/.context/to-do.md`
- `template/.context/status.md`
- `template/.context/decisions.md`
- `README.md`
- `SETUP.md`
- `scripts/install.sh`
- `scripts/uninstall.sh`

### Фаза В

- `README.md` — полная переработка

## Ограничения

- `{ПЛЕЙСХОЛДЕРЫ}` в `template/` — не заполнять и не переименовывать
- Мейнтейнерский слой (корень, `.context/`, `.claude/`) — не переводить
- Имена слэш-команд — зафиксировать в decisions.md при реализации фазы Б

## Изменения по ходу

(пусто)
