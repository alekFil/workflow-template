---
title: "Учебный режим contribution: один remote вместо двух"
status: next
priority: 9
created: 2026-11-27
---

# Учебный режим contribution: один remote вместо двух

Если `UPSTREAM_REPO` равен форку, `workflow.sh bootstrap` добавляет remote `upstream`
с тем же репозиторием, что и `origin`. После `git pull upstream main` ссылка
`origin/main` устаревает, и `git status` показывает `ahead 2` без реального
расхождения.

Варианты: `bootstrap` не добавляет `upstream`, если URL совпадает с `CODE_REPO`
(с учетом ssh и https); или учебный режим получает явный флаг и описание в
`.claude/rules/profiles.md` и `SETUP.md`. Выбор – в `/architect`.
