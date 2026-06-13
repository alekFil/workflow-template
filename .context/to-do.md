# To-Do: workflow-template

> Обновляется командой "синхронизируем" после каждой реализации.
> Цель: зрелый шаблон рабочего процесса с CC, готовый к развёртыванию за 5 минут.

---

## В работе

(нет активных задач)

## Следующее

### Приоритет 1: Cookiecutter-инициализация (ADR-003)

- [ ] Переструктурировать `template/` → `{{cookiecutter.project_slug}}/`
- [ ] Создать `cookiecutter.json` (project_name, project_slug, stack, package_name)
- [ ] Добавить стек python-uv: `pyproject.toml`, `src/`, `tests/`, `.python-version`
- [ ] Написать `hooks/post_gen_project.py` (git init, uv sync, удаление лишних файлов)
- [ ] Мигрировать плейсхолдеры `{PROJECT_NAME}` → `{{cookiecutter.project_name}}` во всех шаблонных файлах
- [ ] Обновить `SETUP.md` под новый процесс (`uvx cookiecutter ...`)

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
- [x] `.context/notes/` исключена из git в обоих слоях, описана в WORKFLOW.md (ADR-011)

---

## После MVP (технический долг)

- [ ] Тест: проверить что развёртывание через install.sh работает end-to-end
- [ ] Changelog для отслеживания версий шаблона
