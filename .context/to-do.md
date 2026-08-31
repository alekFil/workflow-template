# To-Do: workflow-template

> Обновляется командой "синхронизируем" после каждой реализации.
> Цель: зрелый шаблон рабочего процесса с CC, готовый к развёртыванию за 5 минут.

---

## В работе

(нет активных задач)

## Следующее

### Приоритет 1: OSS-публикация (ADR-014, ADR-015, ADR-016)

- [x] Удалить `template/.markdownlint.json`
- [x] Убрать `.markdownlint.json` из предупреждения в `scripts/install.sh`
- [x] Убрать вопрос про `.markdownlint.json` из `scripts/uninstall.sh`
- [x] Убрать упоминание markdownlint из `README.md`
- [x] Перевести `template/CLAUDE.md` на английский
- [x] Перевести `template/WORKFLOW.md` на английский
- [x] Перевести `template/.claude/index.md` и все 4 мета-скилла на английский
- [x] Перевести `template/.context/*.md` (blueprint, plan, to-do, status, decisions) на английский
- [x] Перевести `README.md`, `SETUP.md` на английский
- [x] Перевести `scripts/install.sh` и `scripts/uninstall.sh` (вывод, подсказки) на английский
- [x] Заменить ключевые фразы на слэш-команды в `template/CLAUDE.md`
- [x] Обновить `CLAUDE.md` (мейнтейнерский) — слэш-команды, перевод на английский (ADR-018)
- [x] Обновить `.claude/index.md` (мейнтейнерский) — триггеры слэш-команд, английский (ADR-018)
- [x] Обновить `.claude/skills/meta/*.md` — английский (ADR-018)
- [x] Обновить `CONTRIBUTION.md` — слэш-команды, английский (ADR-018)
- [ ] Снять демо: одна сессия от `/architect` до `/commit`
- [ ] Переписать `README.md`: объяснить двухслойную структуру, добавить демо

### Приоритет 2: Управление decisions.md

- [x] Расширить `cc-architect-sync.md`: добавить шаг проверки ADR со статусом "Заменено" и предложения архивировать в `.context/history/decisions/` (ADR-026, реализовано в рамках дисциплины ADR)
- [x] То же для `template/.claude/skills/meta/cc-architect-sync.md` (ADR-026)
- [x] Создать `.context/history/decisions/` — теперь директория с реальным содержимым (ADR-026)
- [ ] Тест: проверить что развёртывание через install.sh работает end-to-end

### Приоритет 3: Полнота шаблона

- [x] Добавить `.claudeignore` в `template/` (исключить `.context/history/` из контекста CC) — отпало (ADR-027: status-архив удалён; в `history/` остаётся только `decisions/`, его CC должен читать)
- [x] Добавить `template/.claude/skills/project/` — каталог для проектных скиллов (ADR-023: `rules/` с README и примером)
- [ ] Проверить что `template/.gitignore` корректно разворачивается через `install.sh`

---

## Готово

- [x] Репозиторий создан
- [x] Рабочий процесс с Claude Code настроен
- [x] Разделение мейнтейнерского и шаблонного слоёв (ADR-001)
- [x] Перенос `index.md` из `docs/` в `.claude/` (ADR-002)
- [x] Создана структура `template/` со всеми шаблонными файлами
- [x] Мейнтейнерская документация заполнена реальным содержимым
- [x] Реализован `scripts/init-project.sh` (минимальная версия)
- [x] Добавлен `scripts/install.sh` — curl-установка для пользователей (ADR-005)
- [x] Добавлен `.markdownlint.json` (мейнтейнерский и шаблонный слои)
- [x] Упрощены ключевые фразы активации Архитектора (`обсудим задачу` → `обсудим`)
- [x] Удалён `scripts/init-project.sh`, SETUP.md обновлён (ADR-007)
- [x] Переименована `docs/` → `.context/` в обоих слоях, ссылки обновлены (ADR-006)
- [x] Предпубликационный аудит: `cc-export-chat` удалён, `.gitignore` дополнен, `install.sh` создаёт `dev`-ветку (ADR-009)
- [x] `template-mini` отклонён — поддерживать два параллельных шаблона нецелесообразно (ADR-010)
- [x] Cookiecutter отклонён — продукт workflow-слой, не project starter (ADR-003 → ADR-014)
- [x] `.context/notes/` исключена из git в обоих слоях, описана в WORKFLOW.md (ADR-011)
- [x] Явная языковая настройка: 3 плейсхолдера в `template/CLAUDE.md`, вопрос [one/multi] в `install.sh`, Language-секция в обоих `CLAUDE.md` (ADR-020)
- [x] Команда `/polish` — пайплайн вычистки сгенерированного кода в обоих слоях (ADR-023)
- [x] Режим `/polish --all` — полный прогон по проекту, project-rules only, `.polishignore` опционально; наполнены мейнтейнерские правила `markdown-conventions` и `no-placeholder-leaks` (ADR-024)
- [x] Дисциплина ADR — двухуровневая модель, чек-лист, архивация; переклассификация 25 существующих ADR; синхронизировано в шаблонный слой (ADR-026)
- [x] Убрать file-архив status.md — перезапись + git-указатель; удалены 14 архивных файлов; `/report` упрощён в обоих слоях (ADR-027)
- [x] Разделить логическую карту (CLAUDE.md → «Components») и физическое дерево (status.md); плейсхолдер `{PROJECT_STRUCTURE}` → `{PROJECT_LAYOUT}` (ADR-028)
- [x] Three-way split артефактов: notes (private, AI-user) / discussions (team) / history/retros (archived retros); 4 AI-файла перенесены в notes/, retro — в history/retros/2026-06-21.md; `/retro` обновлён (ADR-029)
- [x] `plan.md` как task-local: жизненный цикл (создаётся `/architect`, удаляется `/close`), классификация артефактов по scope (project-wide / task-local / private) в CLAUDE.md обоих слоёв (ADR-030)

---

## После MVP (технический долг)

- [ ] Тест: проверить curl-команду для uninstall.sh в SETUP.md
- [ ] Changelog для отслеживания версий шаблона
