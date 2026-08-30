## Task: Ввести дисциплину ADR — двухуровневая модель, чек-лист, архивация, переклассификация

### Context

`.context/decisions.md` эродировал: из 25 записей около трети — тактические фиксы, переименования и punch-list; ещё 4 — развороты и отклонения, которые не архивированы. Плотность разворотов в активном срезе создаёт впечатление «автор часто передумывает», а мусорные ADR размывают планку. Настоящая проблема — не «где хранить контекст», а *дисциплина курирования*: сейчас нет барьера между архитектурным решением и коммит-сообщением.

Обсуждение (сессия 2026-08-30) зафиксировало модель: 2 уровня (ADR + commit messages, без промежуточных файлов), чек-лист из 4 пунктов как gatekeeper `/record`, архивация разворотов в `.context/history/decisions/<year>.md` (триггеры X реактивно в `/record` и Y периодически в `/sync`), bulk-переклассификация текущих 25 (13 active, 4 archive, 8 remove). Дисциплина применяется единообразно в мейнтейнерском и шаблонном слоях.

Depends on: —

### What to implement

1. **Записать ADR-026** в `.context/decisions.md`: «Дисциплина ADR — двухуровневая модель, чек-лист, архивация». Включает: 4-пункт чек-лист, определение уровней, механику архивации (X+Y триггеры), маркер шапки для архива, конвенцию ссылок `ADR-NNN (archived, see history/decisions/YYYY.md)`. ADR-026 явно замещает ADR-004.

2. **Создать структуру архива** `.context/history/decisions/` (директория) и файлы `2025.md`, `2026.md` с шапкой (описание назначения архива).

3. **Bulk-переклассификация 25 ADR:**
   - **Архивировать (4)**: ADR-003, ADR-004 → `history/decisions/2025.md`; ADR-016, ADR-021 → `history/decisions/2026.md`. В шапку каждого добавить маркер вида `> Заменено ADR-N (YYYY-MM-DD) — см. .context/decisions.md` или `> Отклонено (YYYY-MM-DD)`.
   - **Удалить из активного (8)**: ADR-002, ADR-006, ADR-008, ADR-009, ADR-011, ADR-015, ADR-017, ADR-022. Содержимое не переносится никуда — остаётся только в git-истории.
   - **Отредактировать ADR-024**: убрать п.5 (правило bold-as-heading), добавить в «Последствия» строку «п.5 отменён ADR-025». Основная часть (режим `--all`) остаётся.
   - **Обновить ссылки** в оставшихся активных ADR (14 = 13 старых + ADR-026): вхождения ADR-003, ADR-004, ADR-016, ADR-021 → формат `ADR-NNN (archived, see history/decisions/YYYY.md)`.

4. **Обновить `/record`** (`.claude/commands/record.md` + `template/.claude/commands/record.md`): встроить чек-лист как первый шаг команды. Если хоть один пункт «нет» — вывести сообщение о непрохождении и предложить commit-message с секцией «Why». ADR не пишется.

5. **Обновить `cc-architect-sync.md`** (оба слоя): добавить шаг Y — проверка активных ADR на статус «Отклонено» / «Заменено» без явной замены, предложение архивировать. Учесть, что явная замена уже обработана `/record` через X.

6. **Обновить `cc-commit.md`** (оба слоя): добавить конвенцию — для нетривиальных фиксов сообщение содержит секцию «Why» (короткое обоснование выбора). Не менять базовый формат; секция необязательна для косметики/refactor без содержательного «почему».

7. **Обновить корневой `CLAUDE.md`**: добавить раздел «ADR discipline» (после «Markdown conventions» или в соседней позиции). Кратко: 4-пункт чек-лист, ссылка на архив, конвенция ссылок. Формулировки по-английски (мейнтейнерский `CLAUDE.md` на английском — ADR-018).

8. **Синхронизировать в шаблонный слой `template/CLAUDE.md`**: та же секция «ADR discipline». Формулировки идентичны мейнтейнерскому в содержательной части (шаблонный `CLAUDE.md` тоже на английском).

9. **Обновить `.context/to-do.md`**: перенести пункт «Приоритет 2 → Расширить cc-architect-sync.md: добавить шаг проверки ADR со статусом "Заменено"…» в «Готово» с пометкой «замещено ADR-026, реализовано в рамках дисциплины ADR». То же для пункта «Создать `.context/history/decisions/` (.gitkeep)» — теперь директория создаётся с реальным содержимым.

### Files

Create:

- `.context/history/decisions/2025.md` — архив ADR-003, ADR-004
- `.context/history/decisions/2026.md` — архив ADR-016, ADR-021

Edit:

- `.context/decisions.md` — добавить ADR-026; удалить 8 ADR (002, 006, 008, 009, 011, 015, 017, 022); удалить 4 архивируемых ADR (003, 004, 016, 021); отредактировать ADR-024; обновить ссылки на архивированные во всех оставшихся
- `.claude/commands/record.md` — встроить 4-пункт чек-лист как gating-шаг
- `.claude/skills/meta/cc-architect-sync.md` — добавить шаг Y (orphan-отклонения)
- `.claude/skills/meta/cc-commit.md` — конвенция «Why» для нетривиальных фиксов
- `CLAUDE.md` — новая секция «ADR discipline»
- `template/.claude/commands/record.md` — та же правка что и в мейнтейнерском
- `template/.claude/skills/meta/cc-architect-sync.md` — та же
- `template/.claude/skills/meta/cc-commit.md` — та же
- `template/CLAUDE.md` — новая секция «ADR discipline»
- `.context/to-do.md` — снять два пункта из «Приоритет 2», перенести в «Готово» с пометкой о замещении

### Constraints

- **Порядок исполнения важен.** ADR-026 записывается **до** архивации ADR-004 (потому что ADR-004 архивируется как «замещено ADR-026»). Bulk-переклассификация — после записи ADR-026.
- **Ретроактив git-истории не переписываем.** 8 удаляемых ADR остаются в git log; переписывать историю не нужно и вредно. Информация о них восстанавливаема через `git log -- .context/decisions.md`.
- **Плейсхолдеры в `template/` не трогать.** `template/CLAUDE.md` содержит `{PLACEHOLDERS}` — новую секцию «ADR discipline» вставить в существующую разметку, не заполняя плейсхолдеры реальными значениями.
- **Формулировки в CLAUDE.md обоих слоёв идентичны в содержательной части.** Расхождения допустимы только там, где обусловлены различием слоёв (например, ссылка на examples).
- **Не создавать промежуточных operational-файлов.** Вариант A финализирован: `.context/operational.md`, `CHANGELOG.md` не создаются в рамках этой задачи. Если понадобятся позже — отдельное решение.
- **Обсуждение сессии в `.context/discussions/`.** Оформить как discussion-файл до/во время реализации: `2026-08-30-adr-discipline.md`. Содержит короткий summary развилок и выборов, ссылку на ADR-026.
- **Коммиты.** Разбить на два: (1) design — новый ADR-026, обновление скиллов и CLAUDE.md; (2) cleanup — bulk-переклассификация (архивация + удаление + правки ссылок). Не смешивать design и cleanup в одном коммите.
- **Обычные правила репо:** ff-only merge, feature-ветка → dev.

### Verification

Automatable:

```bash
cd /home/dev/projects/workflow-template

# 1. ADR-026 записан, ADR-004 из активного удалён
grep -q "^## ADR-026" .context/decisions.md
! grep -q "^## ADR-004" .context/decisions.md

# 2. Активные ADR: 14 записей (13 старых + ADR-026)
[ "$(grep -c '^## ADR-' .context/decisions.md)" = "14" ]

# 3. Удалённые 8 ADR отсутствуют в активном
for n in 002 006 008 009 011 015 017 022; do
  ! grep -q "^## ADR-$n" .context/decisions.md || { echo "ADR-$n leaked into active"; exit 1; }
done

# 4. Архив создан и содержит правильные ADR
grep -q "^## ADR-003" .context/history/decisions/2025.md
grep -q "^## ADR-004" .context/history/decisions/2025.md
grep -q "^## ADR-016" .context/history/decisions/2026.md
grep -q "^## ADR-021" .context/history/decisions/2026.md

# 5. Маркер в шапке архивированных
grep -q "^> Отклонено\|^> Заменено" .context/history/decisions/2025.md
grep -q "^> Отклонено\|^> Заменено" .context/history/decisions/2026.md

# 6. Ссылки на архивированные обновлены (формат "(archived,")
! grep -E "ADR-(003|004|016|021)([^0-9]|$)" .context/decisions.md | grep -v "archived,"

# 7. Скиллы содержат новые элементы
grep -qi "checklist\|чек-лист" .claude/commands/record.md
grep -qi "checklist\|чек-лист" template/.claude/commands/record.md
grep -qi "orphan\|заменено\|отклонено" .claude/skills/meta/cc-architect-sync.md
grep -qi "orphan\|заменено\|отклонено" template/.claude/skills/meta/cc-architect-sync.md
grep -qi "why\|почему" .claude/skills/meta/cc-commit.md
grep -qi "why\|почему" template/.claude/skills/meta/cc-commit.md

# 8. Секция ADR discipline в обоих CLAUDE.md
grep -qi "ADR discipline\|ADR-дисциплина" CLAUDE.md
grep -qi "ADR discipline\|ADR-дисциплина" template/CLAUDE.md

# 9. to-do.md обновлён
! grep -q "Расширить \`cc-architect-sync.md\`.*Заменено" .context/to-do.md

# 10. Discussion-файл создан
test -f .context/discussions/2026-08-30-adr-discipline.md
```

Manual smoke:

- Запустить `/record` в текущей сессии — команда первым шагом показывает 4-пункт чек-лист и требует ответов «да» по каждому.
- Прочитать активный `decisions.md` целиком — 14 записей, все проходят чек-лист, ни одной тактической/тривиальной.
- Прочитать `history/decisions/2025.md` и `2026.md` — маркер в шапке каждой записи виден сразу.

### Changes along the way

- **`.context/history/decisions/2025.md` не создан** — по git-истории все 4 архивируемых ADR (003, 004, 016, 021) написаны в 2026 году. Создан только `2026.md`.
- **ADR-024 отредактирован мягче, чем формулировал план.** План говорил «убрать п.5 (правило bold-as-heading)». Фактически п.5 в исходном ADR-024 вводил *два* правила (`markdown-conventions.md` и `no-placeholder-leaks.md`), а не только bold-as-heading; полное удаление стёрло бы историю введения `no-placeholder-leaks.md`. Итог: п.5 удалён из «Решение» целиком (bold-as-heading содержится в его тексте), но соответствующие consequences отредактированы, чтобы сохранить факт введения двух файлов правил и явно указать «п.5 отменён ADR-025».
- **Обновление verification** (см. ниже) под факт единственного архивного файла `2026.md`.
