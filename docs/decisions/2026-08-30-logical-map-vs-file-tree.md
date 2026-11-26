---
title: "Разделение логической карты (CLAUDE.md) и физического дерева (status.md)"
status: accepted
date: 2026-08-30
legacy-id: ADR-028
---

# Разделение логической карты (CLAUDE.md) и физического дерева (status.md)

**Контекст:** `CLAUDE.md` (root) содержал блок «Repo structure» – файловое дерево с папками и файлами и пояснениями. `.context/status.md` содержит «Структура проекта» – то же файловое дерево, auto-generated при `/report`. Симметрично в шаблонном слое: `template/CLAUDE.md` держал плейсхолдерное дерево `{PROJECT_STRUCTURE}`, `template/.context/status.md` – плейсхолдер физического дерева. Три проблемы:

- **Дублирование.** Одна и та же информация в двух местах – тратится место в контексте CC и внимание мейнтейнера.
- **Дрейф.** Ручной блок в `CLAUDE.md` уже отстал: не упоминает `cc-code-polish.md` и `cc-retrospective.md`, хотя оба существуют. Ручные деревья устаревают без ошибок в CI – тихо и незаметно.
- **Смешение уровней.** Файловое дерево (что реально лежит) и логическая карта (какой компонент за что отвечает) – разные артефакты с разным жизненным циклом.

**Решение:** Разделить по abstraction level.

1. **`CLAUDE.md` – логическая карта компонентов.** Блок «Repo structure» с деревом заменяется на «Components»: одна строка на компонент, без файлов, без ASCII-веток. Пример для мейнтейнерского слоя:

   ```markdown
   ## Components

   - `.claude/` – CC tooling (index, commands, meta-skills, project rules)
   - `.context/` – workflow artifacts (blueprint, plan, to-do, status, decisions, discussions, history/decisions)
   - `scripts/` – user-facing installers (install/uninstall via curl)
   - `template/` – payload deployed into new projects
   - Top-level: CLAUDE.md, CONTRIBUTION.md, SETUP.md, README.md, LICENSE
   ```

2. **`.context/status.md` – физическое дерево.** Как есть, auto-generated при `/report`. Не трогаем.

3. **Шаблонный слой симметрично.** `template/CLAUDE.md` получает «Components», полностью схематичный: `.claude/` и `.context/` фиксированы, остальное – один плейсхолдер `{PROJECT_LAYOUT}` для проекто-специфичных областей. Пользователь заполняет `{PROJECT_LAYOUT}` при первичной настройке одной-двумя строками верхнего уровня. `template/.context/status.md` – не трогаем.

4. **Плейсхолдер `{PROJECT_STRUCTURE}` (существовавший в `template/CLAUDE.md`) отпадает.** Если он документирован в `template/WORKFLOW.md` как placeholder для пользователя – заменяется на `{PROJECT_LAYOUT}` или снимается.

**Отвергнутые альтернативы:**

- **Только в `CLAUDE.md` (дерево + карта в одном).** Решает дублирование, но дрейф остается (даже усугубляется – все в одном месте, никто не сверяется с реальностью). Провалено уже на практике.
- **Только в `status.md` (без представления в `CLAUDE.md`).** CC загружает `CLAUDE.md` каждой сессии; без даже общего «что здесь есть» CC вынужден дочитывать `status.md` для базового ориентирования. Дороже.
- **Ничего, использовать `tree`/`ls` по запросу.** Ноль дрейфа, но CC получает шум (нерелевантные файлы, отсутствие пояснений), а человек-читатель `CLAUDE.md` вообще ничего не видит.

**Последствия:**

- `CLAUDE.md` (root) и `template/CLAUDE.md` теряют блоки с деревьями, получают компактные «Components». Файлы становятся легче (~20 строк экономии в каждом).
- `.context/status.md` и `template/.context/status.md` – без изменений.
- Плейсхолдер `{PROJECT_STRUCTURE}` в шаблонном слое отпадает; при наличии в `template/WORKFLOW.md` – обновляется/снимается.
- Дрейф исключен by construction: физическое дерево auto-generated, логическая карта редко-меняющаяся и человеко-читаемая; расхождения ловятся глазом при `/report`.
- Внешние ссылки «см. блок Repo structure» (если есть в других файлах) – обновляются в рамках задачи.
