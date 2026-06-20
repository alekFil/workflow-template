# To-Do: workflow-template

> Обновляется командой "синхронизируем" после каждой реализации.
> Цель: зрелый шаблон рабочего процесса с CC, готовый к развёртыванию за 5 минут.

---

## В работе

(нет активных задач)

## Следующее

### Приоритет 1: OSS-публикация (ADR-014)

- [ ] Перевести `template/CLAUDE.md` на английский
- [ ] Перевести `template/WORKFLOW.md` на английский
- [ ] Перевести `template/.claude/index.md` и все 4 мета-скилла на английский
- [ ] Перевести `template/.context/*.md` (blueprint, plan, to-do, status, decisions) на английский
- [ ] Перевести `README.md`, `SETUP.md` на английский
- [ ] Перевести `scripts/install.sh` и `scripts/uninstall.sh` (вывод, подсказки) на английский
- [ ] Заменить ключевые фразы на слэш-команды в `template/CLAUDE.md`
- [ ] Снять демо: одна сессия от `/architect` до `/commit`
- [ ] Переписать `README.md`: объяснить двухслойную структуру, добавить демо

### Приоритет 2: Управление decisions.md (ADR-004)

- [ ] Расширить `cc-architect-sync.md`: добавить шаг проверки ADR со статусом "Заменено" и предложения архивировать в `.context/history/decisions/`
- [ ] То же для `template/.claude/skills/meta/cc-architect-sync.md`
- [ ] Создать `.context/history/decisions/` (`.gitkeep`)

### Приоритет 3: Полнота шаблона

- [ ] Добавить `.claudeignore` в `template/` (исключить `.context/history/` из контекста CC)
- [ ] Добавить `template/.claude/skills/project/` — каталог для проектных скиллов (пустой, с README)
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

---

## После MVP (технический долг)

- [ ] Тест: проверить что развёртывание через install.sh работает end-to-end
- [ ] Тест: проверить curl-команду для uninstall.sh в SETUP.md
- [ ] Changelog для отслеживания версий шаблона
