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
- [ ] Удалить `scripts/init-project.sh` и `scripts/`
- [ ] Обновить `SETUP.md` под новый процесс (`uvx cookiecutter ...`)

### Приоритет 2: Управление decisions.md (ADR-004)

- [ ] Расширить `cc-architect-sync.md`: добавить шаг проверки ADR со статусом "Заменено" и предложения архивировать в `docs/history/decisions/`
- [ ] То же для `template/.claude/skills/meta/cc-architect-sync.md`
- [ ] Создать `docs/history/decisions/` (`.gitkeep`)

### Приоритет 4: Полнота шаблона

- [ ] Добавить `.claudeignore` в `template/` (исключить `docs/history/` из контекста CC)
- [ ] Добавить `template/.claude/skills/project/` — каталог для проектных скиллов (пустой, с README)

### Приоритет 5: Улучшения рабочего процесса

- [ ] Разобрать `cc-export-chat.md` — нужен ли скрипт в шаблоне или инструкция по настройке

---

## Готово

- [x] Репозиторий создан
- [x] Рабочий процесс с Claude Code настроен
- [x] Разделение мейнтейнерского и шаблонного слоёв (ADR-001)
- [x] Перенос `index.md` из `docs/` в `.claude/` (ADR-002)
- [x] Создана структура `template/` со всеми шаблонными файлами
- [x] Мейнтейнерская документация заполнена реальным содержимым
- [x] Реализован `scripts/init-project.sh` (минимальная версия)

---

## После MVP (технический долг)

- [ ] Тест: проверить что развёртывание через cookiecutter работает end-to-end
- [ ] Changelog для отслеживания версий шаблона
