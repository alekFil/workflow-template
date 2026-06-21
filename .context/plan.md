## Task: Initialize `analytics` branch and adapt root-layer identity

### Context

`analytics` — постоянная параллельная ветка репозитория (не feature). `main` остаётся шаблоном для
разработки ПО, `analytics` становится шаблоном для аналитических проектов. Ветки никогда не сливаются
обратно — оба продукта живут в одном репо и разрабатываются независимо.

Эта задача (1 из 6) создаёт ветку и трансформирует **только корневой (мейнтейнерский) слой** — `CLAUDE.md`,
`.context/`, `.claude/index.md`. Template-слой (`template/`) не трогается — это задачи 2–6.

Depends on: —

### What to implement

1. Создать ветку `analytics` от текущего HEAD `main`
2. Переписать `CLAUDE.md` — идентифицировать репо как analytics-variant: описание, сравнительная таблица
   с `workflow-template`, структура (добавить `data/`, `notebooks/`, `src/`, `outputs/` в template-слое),
   обновить список скиллов (в root — без `cc-record-finding`/`cc-finding-sync`, они только в `template/`)
3. Адаптировать `CONTRIBUTION.md` — описание двух слоёв, правила синхронизации аналитических скиллов
4. Адаптировать `SETUP.md` — упомянуть Python/uv, аналитику-специфичные next steps при развёртывании
5. Переписать `.context/blueprint.md` — мета-репо контекст: что это, два слоя, связь с `main` веткой
6. Переписать `.context/status.md` — начальное состояние analytics-ветки (что унаследовано, что ещё не сделано)
7. Добавить ADR-021/022/023 в `.context/decisions.md` — уже записаны в ходе обсуждения; проверить
   полноту и добавить недостающее
8. Переписать `.context/to-do.md` — список из 6 задач для analytics-ветки (уже обновлён)
9. Адаптировать `.claude/index.md` — обновить навигацию под analytics meta-repo контекст

### Files

Edit:
- `CLAUDE.md` — сменить описание репо; добавить сравнительную таблицу dev vs analytics; обновить
  `Repo structure` (добавить `data/`, `notebooks/`, `src/`, `outputs/` в template-слой); обновить
  `Maintaining this template` (правило про analytics-скиллы); оставить слэш-команды и язык (English)
- `CONTRIBUTION.md` — обновить описание template-слоя; добавить правило: analytics-скиллы
  (`cc-record-finding`, `cc-finding-sync`) — только в `template/`, не в корне
- `SETUP.md` — обновить описание шаблона; добавить Python/uv в next steps; поправить первую фразу в
  "First session" (cc читает analytics-specific файлы)
- `.context/blueprint.md` — переписать: что такое analytics-workflow-template, два слоя, что добавилось
  относительно workflow-template (findings, methodology, data provenance), связь с main веткой
- `.context/status.md` — переписать: дата/ветка = analytics; что унаследовано от main; что ещё не
  реализовано из аналитических задач (tasks 2–6)
- `.context/decisions.md` — добавить ADR-021 в начало файла
- `.context/to-do.md` — переписать под analytics: 6 задач, текущая = Task 1 (В работе)
- `.claude/index.md` — обновить описание репо; убрать cc-architect-sync из analytics-context
  (он остаётся в `.claude/skills/meta/` но не упоминается в навигаторе как основной инструмент)

### Constraints

- НЕ трогать `template/` — это задачи 2–5
- НЕ трогать `scripts/` — задача 6
- НЕ трогать `.claude/skills/meta/` и `.claude/commands/` — корневые скиллы остаются без изменений
- НЕ использовать `/close` для закрытия этой задачи — analytics не мержится в dev/main
- После завершения: коммит прямо на ветке `analytics`, ветка живёт параллельно
- Language-конвенция корневого CLAUDE.md не меняется: English workflow docs, Russian .context/

### Verification

```bash
# analytics-ветка создана
git branch | grep analytics

# Идентификация репо верна
grep "analytics-workflow-template\|analytics workflow" CLAUDE.md

# Сравнительная таблица присутствует
grep "workflow-template.*analytics\|analytics.*workflow-template" CLAUDE.md

# ADR-021 добавлен
grep "ADR-021" .context/decisions.md

# to-do.md содержит 6 аналитических задач
grep "Task [1-6]" .context/to-do.md | wc -l
# ожидаемый вывод: 6
```

### Changes along the way

(нет)
