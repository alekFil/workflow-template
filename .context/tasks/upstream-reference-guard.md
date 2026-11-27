---
title: "Ссылки на чужие репозитории в pull request и коммитах"
status: next
priority: 6
created: 2026-11-27
---

# Ссылки на чужие репозитории в pull request и коммитах

Прогон профиля `contribution` на форке `humanize` в учебном режиме: `UPSTREAM_REPO`
указывает на форк. Карточка содержала ссылку на задачу оригинала. `/close` вставил в
описание pull request строку `Fixes python-humanize/humanize#524`. GitHub сразу
добавил в задачу оригинала запись `cross-referenced`. Правка описания запись не
убирает.

Нужно правило в `/close` и `.claude/rules/profiles.md`: ссылки вида `owner/repo#N` и
URL задач идут только в репозиторий `UPSTREAM_REPO` (или `CODE_REPO`). Ссылку на
другой репозиторий агент показывает владельцу до отправки. Текст pull request,
комментарий и push – публикация, ее проверяют до отправки.

Изменение идет в оба слоя.
