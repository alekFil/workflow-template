---
title: "Миграция развернутых проектов на новую структуру"
status: next
priority: 1
created: 2026-11-26
---

# Миграция развернутых проектов на новую структуру

Перед слиянием `dev → main` дать путь перехода для проектов, развернутых из `v1`:
`commands/` и `skills/meta/` → `skills/<name>/SKILL.md`, `decisions.md` → файлы в
`docs/decisions/`, `to-do.md` → карточки задач, `status.md` → вне git,
`blueprint.md` → `docs/product.md` и урезанный blueprint, `workflow.conf`.

Варианты: инструкция в `SETUP.md` или `scripts/migrate.sh`. Разбор ADR повторяет
скрипт, которым мигрировал мейнтейнерский слой (заметка владельца от 2026-11-26).
