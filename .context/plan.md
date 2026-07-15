## Task: Убрать правило «bold не должен использоваться как заголовок» из всех точек

### Context

Правило (ADR-024 п. 5, продублировано в CLAUDE.md обоих слоёв) даёт 91 нарушение
из 109 при `/polish --all` — паттерн `**Метка:**` де-факто прижился в ADR,
снапшотах статуса, блюпринте и скиллах. Ужесточать шаблоны или переписывать
историю — churn без пользы; правило создавало шум, а не ловило ошибки.
ADR-025 фиксирует отмену и требует убрать правило синхронно из трёх файлов.

Depends on: ADR-025.

### What to implement

1. **`.claude/skills/project/rules/markdown-conventions.md`** — переписать секцию
   правил целиком. Убрать:
   - пункт списка «Never use `**bold**` as a heading substitute…»
   - антипаттерн «`**Section title**` on its own line used as if it were `## Section title`»
   - «good pattern» строку «`**bold**` used only mid-sentence for emphasis»

   Остальные четыре правила (дефис-маркеры, языки у code fences, пустые строки
   вокруг заголовков и списков, `---` только между major-секциями) сохранить
   один в один. Секцию «Judgment notes» не трогать.

2. **`CLAUDE.md` (корень)** — в разделе «Markdown conventions» удалить строку
   «Do not use **bold** as a heading substitute — use `##`, `###`, etc.»
   Остальные пункты списка не менять, порядок сохранить.

3. **`template/CLAUDE.md`** — та же правка в той же секции.

### Files

Edit:

- `.claude/skills/project/rules/markdown-conventions.md` — три вырезания
  (правила, antipattern, good pattern)
- `CLAUDE.md` — одна строка из «Markdown conventions»
- `template/CLAUDE.md` — одна строка из «Markdown conventions»

Create: —

### Constraints

- **Не создавать `template/.claude/skills/project/rules/markdown-conventions.md`** —
  сохраняем текущую асимметрию (правила `/polish` живут только в мейнтейнерском
  слое; шаблон получает их через install при копировании CLAUDE.md).
- **Не переписывать существующие 91 нарушение** в `.context/decisions.md`,
  `.context/history/*.md`, `.context/blueprint.md`, `.claude/skills/meta/cc-*.md`.
  По ADR-025 п. 3 история остаётся как есть.
- **Не менять формулировку остальных пунктов** «Markdown conventions» — только
  вырезаем один. Никаких «пока правим, заодно поправим».
- **Не добавлять пометку про отмену в `markdown-conventions.md`** — файл читается
  CC как правило; исторический контекст живёт в ADR-025, дублировать не нужно.

### Verification

Automatable:

```bash
# Правило удалено из трёх точек
! grep -in "bold" /home/dev/projects/workflow-template/.claude/skills/project/rules/markdown-conventions.md
! grep -in "bold.*heading\|heading.*bold" /home/dev/projects/workflow-template/CLAUDE.md
! grep -in "bold.*heading\|heading.*bold" /home/dev/projects/workflow-template/template/CLAUDE.md

# Остальные четыре пункта markdown-conventions остались на месте
grep -q "dash\|`-` " /home/dev/projects/workflow-template/.claude/skills/project/rules/markdown-conventions.md
grep -q "language tag\|```bash" /home/dev/projects/workflow-template/.claude/skills/project/rules/markdown-conventions.md
grep -q "empty line" /home/dev/projects/workflow-template/.claude/skills/project/rules/markdown-conventions.md
grep -q "Horizontal rules\|`---`" /home/dev/projects/workflow-template/.claude/skills/project/rules/markdown-conventions.md

# ADR-025 записан
grep -q "ADR-025" /home/dev/projects/workflow-template/.context/decisions.md
```

Manual smoke:

- `/polish --all` после правок → правило `markdown-conventions` не флагает
  `**Метка:**` ни в одном из 20 файлов, где нашлись прежние 91 нарушения по этому
  пункту. Прочие правила (rule 1, 2, 3, 4, 6) работают как раньше.
- Контроль-посев: `- item` заменить на `* item` в тестовом .md → правило по-прежнему
  ловит.

### Changes along the way

—

### Notes

Feature-ветка: `feature/drop-bold-heading-rule`.

Задача умещается в одну ветку — три файла, одна логическая правка (снятие правила).
