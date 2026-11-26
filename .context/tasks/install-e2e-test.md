---
title: "Проверить install.sh и uninstall.sh end-to-end"
status: next
priority: 2
created: 2026-11-26
---

# Проверить install.sh и uninstall.sh end-to-end

Пройти установку в пустом репо для каждого профиля и режима ветвления, затем удаление.
Проверить:

- `template/.gitignore` дописывается к существующему, а не заменяет его;
- curl-команды из `SETUP.md` для install и uninstall работают с `main` и `dev`;
- `uninstall.sh` убирает новые файлы: `docs/product.md`, `docs/decisions/`,
  `.claude/workflow.conf`, `.claude/scripts/`.
