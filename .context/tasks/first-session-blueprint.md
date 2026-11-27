---
title: "Первая сессия заполняет и blueprint"
status: next
priority: 8
created: 2026-11-27
---

# Первая сессия заполняет и blueprint

Установщик советует первую просьбу: «Read CLAUDE.md and help me fill in the remaining
placeholders». В прогоне на `humanize` агент заполнил только `CLAUDE.md`. В
`.context/blueprint.md` остались `{COMPONENT_1}`, `{COMPONENT_2}`, `{MAIN_FLOW}`.
`CLAUDE.md` велит читать blueprint в начале каждой сессии, а там пустой каркас.

Нужно: подсказка установщика и раздел «Initial setup» в `template/WORKFLOW.md`
называют оба файла. Для devmeta-профилей blueprint описывает код в `code/`.
