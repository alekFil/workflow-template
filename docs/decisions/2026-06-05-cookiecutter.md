---
title: "Замена init-project.sh на cookiecutter"
status: rejected
date: 2026-06-05
legacy-id: ADR-003
superseded-by: 2026-06-20-oss-publication
---

# Замена init-project.sh на cookiecutter

**Проблема:** `scripts/init-project.sh` – bash-скрипт с ручным заполнением плейсхолдеров и деструктивными операциями (`rm -rf .git`). Не поддерживает stack-специфичную структуру проекта (pyproject.toml, src layout и т.д.).

**Решение:** Заменить скрипт на cookiecutter-шаблон. `template/` переструктурируется в директорию `{{cookiecutter.project_slug}}/`. Переменные – в `cookiecutter.json` (project_name, project_slug, stack, package_name). Логика инициализации – в `hooks/post_gen_project.py` (git init, uv sync, удаление файлов не того стека).

Первый поддерживаемый стек: **python-uv** (src layout, pyproject.toml, .python-version, uv.lock).

Запуск: `uvx cookiecutter path/to/workflow-template` – не требует предустановки cookiecutter.

**Отложено:** поддержка `generic` стека (только workflow-слой, без кода) – до появления второго реального стека.

**Последствия:**

- Плейсхолдеры `{PROJECT_NAME}` в `template/*.md` мигрируют в `{{cookiecutter.project_name}}`.
- `scripts/init-project.sh` и `scripts/` удаляются.
- `SETUP.md` обновляется под новый процесс.
