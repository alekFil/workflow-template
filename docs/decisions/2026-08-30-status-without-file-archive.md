---
title: "Убрать file-архив status.md – перезапись без снапшотов + git-указатель"
status: superseded
date: 2026-08-30
superseded-by: 2026-11-26-shared-text-without-conflicts
legacy-id: ADR-027
---

# Убрать file-архив status.md – перезапись без снапшотов + git-указатель

**Контекст:** `.context/history/{N}-status-*.md` накопил 14 файлов snapshots (001–014, ~150 KB). Никто их не читает: rediscovery-запросы отсутствуют, ретроспектива использует `/retro` (git log + decisions.md), долгосрочная эволюция описана в decisions.md. При этом `.claudeignore` для их скрытия из контекста CC не создан (Приоритет 3 to-do) – файлы утекают в auto-load. Заявленная цель (`archive → excluded via .claudeignore, read on request`) не реализована и по существу не нужна: git-история `status.md` уже содержит эволюцию через `git log -p -- .context/status.md`.

**Решение:**

1. **Отказаться от file-архива `status.md`.** `/report` больше не создает `.context/history/{N}-status-*.md`. Прошлые снапшоты доступны через git-историю: `git show <commit>:.context/status.md`.
2. **Удалить существующие 14 архивных файлов** и `.context/history/.gitkeep` (директория теперь непустая – содержит `decisions/`).
3. **Git-указатель в новом `status.md`.** При каждом `/report` – первая строка после заголовка и даты имеет вид:

   ```markdown
   > Previous state: commit <shortsha> (<YYYY-MM-DD>)
   ```

   `<shortsha>` – 7-символьный хэш, `<date>` – дата коммита. Источник – `git log -1 --format='%h %ai' -- .context/status.md`, взятый *до* overwrite'а. Ретрофит текущего `status.md`: pointer добавляется в рамках этой задачи, указывает на актуальный на момент реализации commit.
4. **Затрагивается только status-архив.** `.context/history/decisions/<year>.md` не трогаем – активные ADR ссылаются на него по конвенции `(archived, see history/decisions/YYYY.md)` из ADR-026. Иной вид истории.
5. **Скилл `cc-status-report.md` упрощается в обоих слоях:** убираются step 1 (архивация с нумерацией) и секция «Working with the history archive» – становятся неактуальными; добавляется шаг захвата предыдущего commit'а и вставки pointer-строки.

**Отвергнутые альтернативы:**

- **Rolling window (последние N снапшотов):** не отвечает на «зачем вообще?». Если 0 читателей – 3 файла или 14 равнозначно бесполезны.
- **Оставить как есть + добавить `.claudeignore`:** маскирует симптом (утечку), не решает проблему (мусор в репо, накладные расходы на архивацию в `/report`).
- **Не писать `status.md` вообще, собирать «на лету»:** пропадает snapshot-документ, на который ссылаются `cc-architect-sync.md` и другие скиллы. Слишком радикально.

**Последствия:**

- `cc-status-report.md` в обоих слоях упрощается: минус шаг архивации, минус секция «Working with the history archive», плюс шаг захвата предыдущего commit'а и вставки pointer-строки.
- Удаляются 14 файлов `.context/history/{N}-status-*.md` и `.context/history/.gitkeep`.
- Задача Приоритета 3 to-do про `.claudeignore` для `.context/history/` становится неактуальной: после удаления status-архива в `history/` остается только `decisions/`, и его CC должен читать (не скрывать). Задача снимается.
- `template/.context/history/.gitkeep` сохраняется – шаблонный слой начинает с пустой структуры для нового проекта.
- Единый формат `status.md`: каждый файл содержит pointer на предыдущую версию, включая текущий (ретрофит).
