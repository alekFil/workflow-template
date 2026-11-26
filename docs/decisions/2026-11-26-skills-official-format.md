---
title: "Скиллы в официальном формате Claude Code, правила в `.claude/rules/`"
status: accepted
date: 2026-11-26
legacy-id: ADR-036
---

# Скиллы в официальном формате Claude Code, правила в `.claude/rules/`

**Контекст:** Команды лежали в `.claude/commands/*.md`, алгоритмы – в
`.claude/skills/meta/cc-*.md` без frontmatter. Claude Code не считал алгоритмы
скиллами, описание в списке скиллов было «Read … and execute the algorithm», и модель
не понимала, когда скилл вызывать. Правила проекта лежали в папке скиллов, правила
workflow – в `CLAUDE.md` (около 230 строк при рекомендации до 200). Документация Claude
Code называет `commands/` старым форматом и предлагает `skills/<name>/SKILL.md` и
`.claude/rules/`.

**Решение:**

1. Каждая команда – папка `.claude/skills/<name>/SKILL.md` с `name` и `description`.
   Алгоритм из `meta/` перенесен внутрь. Папки `commands/` и `skills/meta/` удалены.
2. `disable-model-invocation: true` у скиллов, которые меняют git или решения, и у
   переключателей режимов: `commit`, `close`, `dev`, `go`, `summary`, `record`,
   `organize`, `architect`, `next`. Их запускает только владелец.
3. Правила – в `.claude/rules/`: `artifacts`, `adr-discipline`, `branching`,
   `skill-boundaries`, `text-conventions` (ё и тире), `markdown-conventions` (с
   `paths: **/*.md`), `technical-text-style`. `/polish` проверяет diff по тем же
   правилам. Формат правила – `skills/polish/rules-format.md`.
4. `writing-style` – скилл, который применяется только по просьбе владельца.
5. `.claude/index.md` удален: навигацию дают `CLAUDE.md`, список скиллов и правил.
6. `CLAUDE.md` обоих слоев сокращен до контекста проекта и ссылок.
7. Скиллы совпадают со стандартом Agent Skills по ядру (`name` из `a-z0-9-` равен
   имени папки). Поддержка других агентов не делается: цель шаблона – Claude Code.

**Отвергнутые альтернативы:**

- Оставить `commands/` с перенаправлением на `meta/`: старый формат, нет описаний
  для модели, нет `disable-model-invocation`.
- Универсальный формат для Codex и OpenCode (`AGENTS.md`, `.agents/skills/`): скиллы
  пришлось бы писать без субагентов, `$ARGUMENTS` и хуков Claude Code, а проверить
  совместимость некому. Дешевый путь записан в заметке владельца.

**Последствия:**

- В этом репо Claude Code видит и `template/.claude/skills/` как вложенные скиллы
  `template:<name>`, когда работает с файлами шаблона.
- Уже развернутые проекты остаются на старой структуре до миграции.
- Тег `v1` фиксирует workflow до этого решения.
