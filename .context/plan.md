# Plan

## Task: Добавить документацию /caveman в CONTRIBUTION.md

### Context

ADR-024 добавил скилл `/caveman` в оба слоя. В мейнтейнерском слое строка `/caveman` уже
есть в таблице slash commands в `CLAUDE.md`, но `CONTRIBUTION.md` — мейнтейнерский аналог
`template/WORKFLOW.md` — не содержит ни строки в типичном рабочем цикле, ни раздела
с инструкцией по применению. Аналогично тому, что было добавлено в `template/WORKFLOW.md`.

Depends on: ADR-024 (реализован)

### What to implement

1. `CONTRIBUTION.md` — добавить раздел «Caveman mode» в конец файла (без analytics-note)

### Files

Edit:

- `CONTRIBUTION.md` — добавить раздел «Caveman mode» после раздела «Versioning»

### Constraints

- Без analytics-note (findings.md / methodology.md) — в мейнтейнерском слое нет аналитики
- Не добавлять отдельную строку в «Typical work cycle» — caveman не шаг рабочего цикла,
  а опциональный режим; раздел достаточен
- Содержание раздела идентично `template/WORKFLOW.md`, за вычетом analytics-note

### Verification

```bash
# Раздел присутствует
grep "Caveman" CONTRIBUTION.md

# Levels присутствуют
grep "caveman lite\|caveman full\|caveman ultra" CONTRIBUTION.md

# Analytics-note отсутствует
grep "findings.md" CONTRIBUTION.md && echo "BAD" || echo "correctly absent"
```

### Changes along the way

(пока пусто)
