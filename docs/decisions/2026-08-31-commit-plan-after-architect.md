---
title: "Commit `plan.md` after `/architect` – reviewability guarantee"
status: superseded
date: 2026-08-31
superseded-by: 2026-11-26-shared-text-without-conflicts
legacy-id: ADR-032
---

# Commit `plan.md` after `/architect` – reviewability guarantee

**Контекст:** ADR-030 определил `plan.md` как task-local артефакт: живет на `feature/*`, удаляется `/close`-ом перед merge. Но текущий workflow `/architect` → `/dev` → `/commit` → `/close` не гарантирует, что `plan.md` вообще попадет в git-историю ветки. Сегодняшний фейл-кейс на `feature/skill-boundaries`: `/architect` написал `plan.md` (untracked), `/dev` внес impl-правки, `/commit` спросил про включение `plan.md` – я неверно исключил, `/close` был готов удалить untracked `plan.md` через простой `rm` (без git-trail). Reviewer PR-ветки не увидел бы плана рядом с реализацией.

Причина двусторонняя: (a) `/architect` не подсказывает «закоммитить plan.md перед /dev», (b) `/commit` не ловит untracked `plan.md` как специальный случай. Пропуск одного места не критичен, если другое поймает – нужен belt-and-suspenders.

**Решение:**

1. **`/architect` дает текстовую подсказку в конце режима.** Когда `plan.md` только что записан – вывести: «Plan written. Run `/commit` before `/dev` to include `plan.md` in the feature branch – reviewers need it alongside the implementation.» Только текст, не автоматическое исполнение (в границах ADR-031).

2. **`/commit` ловит untracked `plan.md` как специальный случай.** В `cc-commit.md` – новый шаг между «git status» и «git diff --stat»: если `.context/plan.md` untracked (или modified) – спросить «Include `plan.md`? [Y/n]» с дефолтом **Yes**. Вопрос с дефолтом – не автоматическое исполнение соседнего скилла, а стандартная git-семантика «add file to commit».

3. **`/dev` не проверяет наличие `plan.md` в git.** Если (1)+(2) не сработали, ситуация редкая; дополнительная проверка добавит шум в стандартный flow. Best-effort через два первых места достаточно.

4. **Место фиксации правила:** в скиллах напрямую (`.claude/commands/architect.md`, `.claude/skills/meta/cc-commit.md` в обоих слоях). В `CLAUDE.md` – отдельного раздела не создаем (частный случай, не архитектурный уровень).

5. **Обе правки – в границах ADR-031.** `/architect` текст-подсказывает, не исполняет; `/commit` расширяет свой собственный алгоритм (git-add – часть его scope), не сползает в соседний.

**Отвергнутые альтернативы:**

- **Только `/architect` (без `/commit`-safety net):** пропуск в одном месте → фейл проходит незамеченным. Единственная точка отказа – недостаточно надежно для рутинного flow.
- **Только `/commit` (без `/architect`-подсказки):** пользователь запускает `/dev` без промежуточного `/commit`, `plan.md` уходит в impl-фазу untracked. Правда `/commit` его поймает позже, но подсказка от `/architect` дает правильный next-step-cue сразу – снижает вероятность цикла с ошибкой.
- **`/architect` автокоммитит `plan.md` сам:** нарушение ADR-031 (сползание в `/commit`). Даже если трактовать как «часть собственного алгоритма» – теряет контроль пользователя (может нужно правки перед коммитом).
- **`/dev` проверяет и требует коммит:** добавляет шум в стандартный flow ради редкого edge-case. Two-point defense (a)+(b) закрывает большинство сценариев.
- **Не фиксить, положиться на дисциплину:** повторяющаяся ошибка (уже случилась сегодня), не разовая – требует системного фикса.

**Последствия:**

- `.claude/commands/architect.md` в обоих слоях получает финальную подсказку про `/commit` перед `/dev`.
- `.claude/skills/meta/cc-commit.md` в обоих слоях – новый шаг (untracked `plan.md` check) между step 2 и step 3.
- Reviewer feature-веток получает `plan.md` в git-истории по умолчанию.
- Нестандартный случай (пользователь явно хочет `plan.md` вне git) – по-прежнему возможен через ответ «n» на вопрос `/commit`.
