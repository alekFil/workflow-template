# Plan

## Task: Сделать шаблон нейтральным к IDE для ноутбуков + добавить /brainstorm в SETUP.md

### Context

SETUP.md и template/CLAUDE.md предписывали `uv run jupyter lab` как единственный способ запуска
ноутбуков. VS Code + Jupyter extension — равнозначная и популярная альтернатива. ADR-025 фиксирует
решение: шаблон не привязан к конкретной IDE, `jupyter`-пакет нужен только для `nbconvert`.

Параллельно: в SETUP.md раздел "Getting started with CC" не включал шаг `/brainstorm` как старт
первого анализа и не объяснял параллельную работу notebook IDE + CC.

Depends on: ADR-025 (зафиксирован)

### What to implement

1. `SETUP.md` — переписать раздел "Getting started with CC":
   - Шаг 2: заменить `uv run jupyter lab` на tool-agnostic фразу об открытии ноутбуков
   - Добавить краткое объяснение параллельной работы (notebook IDE + CC)
   - Добавить шаг 4: `/brainstorm <your analytical question>`

2. `template/CLAUDE.md` — таблица "Environment and commands":
   - Убрать строку `| uv run jupyter lab | Start Jupyter Lab |`
   - Строку с `nbconvert` оставить

3. `.context/blueprint.md` — раздел 4.1:
   - Заменить `→ jupyter lab →` на `→ open notebook IDE →`

4. `.context/to-do.md` — описание Task 6:
   - Убрать `uv run jupyter lab` из next steps для install.sh

### Files

Edit:

- `SETUP.md` — Getting started with CC: шаги 2–4
- `template/CLAUDE.md` — убрать строку `uv run jupyter lab` из таблицы команд
- `.context/blueprint.md` — раздел 4.1, одна строка
- `.context/to-do.md` — Task 6 next steps, одна строка

### Constraints

- `SETUP.md` — Getting started должен остаться кратким: 4 шага, без лекции про Jupyter
- `template/CLAUDE.md` — только удалить строку с `jupyter lab`; структуру таблицы не менять
- Не трогать `scripts/install.sh` и `scripts/uninstall.sh` — это Task 6
- Не добавлять `jupyter` или `jupyterlab` в `pyproject.toml` — это Task 5 (там решение ADR-025
  учесть отдельно)

### Verification

```bash
# Нет упоминаний "jupyter lab" в инструкциях (кроме to-do как примера опционального шага)
grep -rn "jupyter lab" SETUP.md template/CLAUDE.md .context/blueprint.md

# /brainstorm присутствует в Getting started
grep "brainstorm" SETUP.md

# nbconvert строка сохранена в template/CLAUDE.md
grep "nbconvert" template/CLAUDE.md
```

### Changes along the way

- `plan.md` — добавлен `# Plan` в первую строку: markdownlint MD041 требует h1 в начале файла
