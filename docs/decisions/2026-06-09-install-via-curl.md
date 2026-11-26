---
title: "Добавить install.sh для установки через curl"
status: accepted
date: 2026-06-09
legacy-id: ADR-005
---

# Добавить install.sh для установки через curl

**Связь с ADR-003 (archived, see history/decisions/2026.md):** ADR-003 планировал заменить `init-project.sh` на cookiecutter для поддержки стек-специфичных шаблонов. `install.sh` покрывает основной сценарий (публичное репо, без стек-специфики) без дополнительных зависимостей. ADR-003 откладывается до появления реального стек-специфичного кейса.

**Проблема:** Текущий процесс развертывания требует клонировать workflow-template целиком, что загрязняет git-историю нового проекта клоном шаблона.

**Решение:** Добавить `scripts/install.sh` – скрипт, который скачивается через curl и устанавливает шаблон в свежий `git init`-репозиторий.

Механизм скачивания – tar.gz архив через GitHub:

```bash
curl -fsSL "${REPO}/archive/refs/heads/main.tar.gz" \
  | tar xz --strip-components=2 "workflow-template-main/template"
```

`--strip-components=2` убирает `workflow-template-main/template/` – файлы шаблона ложатся прямо в текущую директорию.

Сценарий для пользователя:

```bash
mkdir my-project && cd my-project
git init
curl -fsSL https://raw.githubusercontent.com/<GITHUB_USER>/workflow-template/main/scripts/install.sh | bash
```

**Разграничение скриптов:**

- `init-project.sh` – для мейнтейнера: запускается из клона репо, предполагает наличие `template/` рядом
- `install.sh` – для пользователей: скачивается через curl, работает в пустом `git init`

**Ограничения:** только публичное репо, всегда берет `main`.

**Последствия:**

- `scripts/install.sh` добавляется в репо
- `SETUP.md` обновляется: оба способа установки документируются рядом
- GitHub username захардкожен в `install.sh` (читается из самого URL скрипта при `curl | bash` – можно не дублировать)
