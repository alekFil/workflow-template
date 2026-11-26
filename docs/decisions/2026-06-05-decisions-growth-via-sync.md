---
title: "Управление ростом decisions.md через cc-architect-sync"
status: superseded
date: 2026-06-05
legacy-id: ADR-004
superseded-by: 2026-08-30-adr-discipline
---

# Управление ростом decisions.md через cc-architect-sync

**Проблема:** `decisions.md` накапливается без ограничений. Замещенные и устаревшие ADR занимают контекст CC и затрудняют навигацию.

**Решение:** Расширить скилл `cc-architect-sync` шагом аудита `decisions.md`. При синхронизации скилл проверяет ADR со статусом "Заменено" и предлагает перенести их в `docs/history/decisions/`. Отдельный скилл не создается.

**Отложено:** понятие "стабильный ADR" (настолько встроен в практику, что не требует обсуждения) – до появления реального кейса.

**Последствия:**

- В `cc-architect-sync.md` добавляется шаг: проверить ADR со статусом "Заменено", предложить архивирование.
- `docs/history/decisions/` используется как архив (файлы вида `decisions-YYYY.md` или по теме).
- Изменение вносится в оба слоя: `.claude/skills/meta/` и `template/.claude/skills/meta/`.
