---
title: "Отказаться от init-project.sh в пользу install.sh"
status: accepted
date: 2026-06-12
legacy-id: ADR-007
---

# Отказаться от init-project.sh в пользу install.sh

**Проблема:** Два способа установки создают путаницу. `init-project.sh` требует клонировать весь шаблон – это загрязняет git-историю нового проекта. `install.sh` (curl) решает ту же задачу чище и без лишних зависимостей.

**Решение:** `scripts/install.sh` – единственный поддерживаемый способ установки шаблона. `scripts/init-project.sh` удаляется.

**Связь с ADR-003 (archived, see history/decisions/2026.md):** задача "Удалить scripts/init-project.sh" из плана cookiecutter выполняется досрочно и независимо.

**Последствия:**

- Удалить `scripts/init-project.sh`
- Обновить `SETUP.md`: убрать «Способ 2: через клон», оставить только curl
- Проверить `CONTRIBUTION.md` на упоминания `init-project.sh`
