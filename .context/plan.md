## Task: `plan.md` как branch-local — реализовать ADR-030

### Context

Реализация ADR-030: `plan.md` перестаёт жить на `main`/`dev` и становится строго task-local — создаётся `/architect`-ом после feature-ветки, удаляется `/close`-ом перед merge. Ретроактив: текущий `plan.md` на `dev` (этот файл) удаляется естественным образом — как последний шаг `/close` этой самой задачи. Скилл `/close` обновляется первым, чтобы применить новую механику ко всей задаче.

Depends on: ADR-030, ADR-029 (артефакты .context/).

### What to implement

1. **Обновить `.claude/skills/meta/cc-close-task.md`** (мейнтейнерский слой):
   - Добавить новый шаг между «Rebase» и «Merge»: удалить `.context/plan.md`, сделать отдельный commit `chore: clean plan.md` (единственный файл в коммите — `plan.md`).
   - Уточнить в описании: `plan.md` — task-local артефакт, живёт только на feature-ветке; ff-merge доставляет чистое состояние на `dev`.

2. **Обновить `template/.claude/skills/meta/cc-close-task.md`** — те же правки.

3. **Обновить `.claude/skills/meta/cc-architect-sync.md`** (оба слоя): убрать проверку «наличие `plan.md`» как обязательное (её нет прямо, но проверить формулировки шага 1 «Read the current context» — `plan.md` там числится; поменять на условное чтение, «если существует»). Добавить проверку fail-loud: если `plan.md` обнаружен на `main`/`dev` — это нарушение правила ADR-030, предложить удалить через `/close`.

4. **Обновить `.claude/commands/architect.md`** и `.claude/commands/next.md` в обоих слоях:
   - Уточнить в тексте команды, что перед записью `plan.md` следует проверить текущую ветку. Если не `feature/*` или `hotfix/*` — задать вопрос «на feature-ветке? если нет, создать?». Ветка не создаётся автоматически.
   - Обсуждение без записи `plan.md` — валидно на любой ветке.

5. **Обновить `CLAUDE.md` (root):** добавить раздел «Artifact scope» с явной классификацией (project-wide / task-local / private). Разместить после «Components» или «ADR discipline», где логичнее.

6. **Обновить `template/CLAUDE.md`:** та же секция «Artifact scope», формулировки идентичны в содержательной части.

7. **Удалить `template/.context/plan.md`.** Новый проект стартует без активной задачи. Плейсхолдеры, которые в нём были, уходят вместе с файлом (проверить в `template/WORKFLOW.md` таблице плейсхолдеров: если упомянуто что-то про `plan.md`, снять).

8. **Обновить `.context/to-do.md`:**
   - Приоритет 4 (branch-local `plan.md`) — все подпункты в «Готово».
   - Пункт про `.context/history/decisions/` — уже закрыт ADR-026, если ещё не отмечен.

9. **Естественный ретроактив:** этот `plan.md` живёт на feature-ветке весь цикл реализации; удаляется обновлённым `/close` перед ff-merge; `dev` заканчивает задачу без `plan.md`.

### Files

Edit:

- `.claude/skills/meta/cc-close-task.md` — новый шаг удаления `plan.md`
- `template/.claude/skills/meta/cc-close-task.md` — то же
- `.claude/skills/meta/cc-architect-sync.md` — чтение `plan.md` условно; fail-loud на защищённой ветке
- `template/.claude/skills/meta/cc-architect-sync.md` — то же
- `.claude/commands/architect.md` — branch-check перед записью
- `template/.claude/commands/architect.md` — то же
- `.claude/commands/next.md` — то же
- `template/.claude/commands/next.md` — то же
- `CLAUDE.md` — новая секция «Artifact scope»
- `template/CLAUDE.md` — то же
- `template/WORKFLOW.md` — сверить плейсхолдеры на упоминания `plan.md` (снять при наличии)
- `.context/to-do.md` — Приоритет 4 → Готово

Delete:

- `template/.context/plan.md` — новый проект стартует без задач

### Constraints

- **`.claude/commands/architect.md` не должен создавать ветку автоматически.** Только вопрос пользователю. Автоматика — риск случайных веток при абстрактных обсуждениях.
- **`/close` удаляет `plan.md` отдельным коммитом**, не смешивая с другими правками. Читаемость истории.
- **Не заменять `template/.context/plan.md` на заглушку.** Отсутствие лучше пустого файла (ADR-030 п.1 (a)).
- **`template/.context/plan.md` при `install.sh`** — скрипт не должен пытаться заполнить плейсхолдеры в несуществующем файле. Если install делает `sed` по `.context/*.md`, проверить: работает через find (пропускает несуществующее), не завалится.
- **Не создавать `.context/plan.md` где-либо шаблонной заглушкой.** Артефакт возникает только через `/architect` на feature-ветке.
- **Feature-ветка:** `feature/branch-local-plan`.
- **Один атомарный commit** для правок (skills + CLAUDE.md + delete + to-do). Плюс отдельный `chore: clean plan.md` в самом конце как часть новой механики `/close`.

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. cc-close-task.md содержит шаг удаления plan.md
grep -qi "clean plan\.md\|delete .context/plan.md\|remove plan.md" .claude/skills/meta/cc-close-task.md && echo "OK root close"
grep -qi "clean plan\.md\|delete .context/plan.md\|remove plan.md" template/.claude/skills/meta/cc-close-task.md && echo "OK template close"

# 2. cc-architect-sync.md — plan.md не обязателен
grep -qi "plan.md.*if.*exist\|optional.*plan\|only.*feature.*plan" .claude/skills/meta/cc-architect-sync.md && echo "OK root sync"
grep -qi "plan.md.*if.*exist\|optional.*plan\|only.*feature.*plan" template/.claude/skills/meta/cc-architect-sync.md && echo "OK template sync"

# 3. architect.md и next.md — branch-check
grep -qi "feature.*branch\|branch.*check" .claude/commands/architect.md && echo "OK root architect"
grep -qi "feature.*branch\|branch.*check" template/.claude/commands/architect.md && echo "OK template architect"

# 4. CLAUDE.md обоих слоёв содержит «Artifact scope»
grep -q "Artifact scope\|## Artifact" CLAUDE.md && echo "OK root scope"
grep -q "Artifact scope\|## Artifact" template/CLAUDE.md && echo "OK template scope"

# 5. template/.context/plan.md удалён
! test -f template/.context/plan.md && echo "OK: template plan.md removed"

# 6. install.sh не ссылается на несуществующий plan.md напрямую
if grep -q "\.context/plan\.md" scripts/install.sh; then echo "REVIEW: install.sh mentions plan.md"; else echo "OK: install.sh clean of plan.md refs"; fi

# 7. Финальное состояние после /close: plan.md отсутствует на dev
# (Проверяется в момент /close, не в этой verification-фазе.)

# 8. to-do.md: Приоритет 4 закрыт
! grep -qE "^- \[ \].*Приоритет 4|^- \[ \].*Обновить команду `/architect`.*ветка|^- \[ \].*plan.md.*branch-local" .context/to-do.md && echo "OK: Priority 4 items closed"
```

Manual smoke:

- Открыть обновлённый `cc-close-task.md` — шаг про `chore: clean plan.md` явно и до merge.
- Открыть обновлённый `cc-architect-sync.md` — чтение `plan.md` условное; отсутствие на `dev` — норма; наличие на защищённой ветке — предупреждение.
- Обновлённая `CLAUDE.md` — раздел «Artifact scope» покрывает три класса.
- Проверить, что при следующем `/close` этой самой задачи механика срабатывает: `plan.md` удаляется отдельным коммитом, ff-merge оставляет `dev` без него.

### Changes along the way

—
