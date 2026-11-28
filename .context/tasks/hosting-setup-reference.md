---
title: "SETUP.md: настройка веток на GitHub и GitLab"
status: next
priority: 16
created: 2026-11-28
---

# SETUP.md: настройка веток на GitHub и GitLab

Шаблон не настраивает хостинг, но режимы слияния зависят от его настроек.
Нужна справка: какие настройки совместимы с `BRANCH_MODEL` и `MERGE_MODE`.

Содержание:

| GitLab | GitHub |
| --- | --- |
| Push: No one | Ruleset: Require a pull request, запрет force push и удаления |
| Merge: ff-only | Require linear history и только Rebase and merge |
| Squash запрещен | Снять Allow squash merging |
| Pipelines не требовать | Не включать Require status checks |

- Приватный репозиторий на GitHub Free не поддерживает rulesets и branch
  protection: API возвращает HTTP 403.
- В GitHub нет слияния ff-only. «Rebase and merge» создает коммиты с новыми
  SHA, поэтому `git branch -d` не удаляет локальную ветку задачи. Подсказка в
  `/close` для режима `pr`: `git branch -D` после проверки, что pull request
  слит.
- Squash merge сохраняет трейлер `Closes-Task:` последней строкой, иначе
  `workflow.sh done` пропустит задачу (уже в `branching.md`, сослаться).

Связано: `protected-main-merge-mode`, `pr-tool`.
