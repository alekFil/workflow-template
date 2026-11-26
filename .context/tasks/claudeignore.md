---
title: "Добавить .claudeignore в шаблон"
status: rejected
priority: 9
created: 2026-11-26
---

# Добавить .claudeignore в шаблон

Исключить `.context/history/` из контекста агента.

## Reason

Отпало: файловый архив `status.md` удален, а архив ADR больше не нужен – замененные
ADR лежат в `docs/decisions/` со статусом. Читать историю агенту не мешает.
