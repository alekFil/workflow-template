---
title: "install.sh: убрать cp -n"
status: next
priority: 10
created: 2026-11-27
---

# install.sh: убрать cp -n

`scripts/install.sh` копирует `docs/` командой `cp -Rn`. Новый GNU coreutils печатает
`cp: warning: behavior of -n is non-portable and may change in future`. Будущая
версия может изменить поведение `-n`, и установщик перезапишет `docs/` владельца.

Нужно: копировать `docs/` без `-n` с явной проверкой существования файла. Поведение
на GNU и BSD одинаковое.
