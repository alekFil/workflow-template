---
title: "Защищенный main и режим слияния"
status: next
priority: 15
created: 2026-11-28
---

# Защищенный main и режим слияния

`BRANCH_MODEL=trunk` с `MERGE_MODE=local` несовместим с защитой `main` от push.
`/close` сливает ветку в `main` локально, а push владельца отклоняет защита:
GitLab «Allowed to push: No one», ruleset GitHub «Require a pull request».

В dev-модели проблемы нет, если `dev` не защищен: задачи сливаются в `dev`
локально, `dev` → `main` идет через pull request.

Что сделать:

- `.claude/rules/branching.md`: если `main` защищен от push, выбери
  `BRANCH_MODEL=dev` или `MERGE_MODE=pr`.
- Подсказка установщика при выборе режима слияния: агент не знает о защите
  без API хостинга, выбор делает владелец.
- Оба слоя.
