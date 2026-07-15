## Task: Добавить режим `/polish --all` и написать мейнтейнерские project rules

### Context

`/polish` (ADR-023) поддерживает только diff-based scope: `merge-base HEAD dev..HEAD`,
конкретный `<path>` или `--staged`. Для случая «работаю прямо на `dev`, хочу пройтись
по всему коду разом» нет режима. ADR-024 добавляет `--all` — прогон по всем tracked-файлам
через `git ls-files` с опциональным исключением через `.polishignore`. В этом режиме
встроенный `simplify` не вызывается (рассчитан на diff, шум + риск превышения контекста),
работают только project-rules.

Одновременно наполняем `.claude/skills/project/rules/` в мейнтейнерском слое двумя
правилами — впервые задействуем точку расширения из ADR-023 п. 5.

Depends on: ADR-023 (базовый `/polish`), ADR-024 (это решение).

### What to implement

1. **Алгоритм `--all` в `.claude/skills/meta/cc-code-polish.md`:**
   - Раздел «Determine diff scope» → таблица аргументов: добавить строку `--all` со scope
     `git ls-files` минус `.polishignore` (если файл присутствует).
   - Явно указать: в `--all` встроенный `simplify` **не вызывается**, работают только
     project-rules (тот же путь, что уже описан для fallback «simplify unavailable»).
   - Перед сканированием — confirm: «Scope: N files. Continue? y/n». Отказ = выход.
   - Раздел «Constraints» — добавить строку про `--all` и отсутствие `simplify`.
2. **То же в `template/.claude/skills/meta/cc-code-polish.md`** — идентичные правки.
3. **Обновить `.claude/commands/polish.md` и `template/.claude/commands/polish.md`,**
   если добавляем описание аргументов (сейчас файлы — однострочная обёртка через
   `$ARGUMENTS`; правка не обязательна, `--all` пробросится автоматически).
4. **Правила мейнтейнерского слоя** — создать два prose-файла в
   `.claude/skills/project/rules/`:
   - `markdown-conventions.md` — H1-имя + описание: дефис-маркеры списков, язык у code
     fences, пустые строки вокруг заголовков и списков, никаких **bold**-as-heading,
     дивайдеры `---` только между крупными секциями. Источник — секция «Markdown
     conventions» в CLAUDE.md.
   - `no-placeholder-leaks.md` — H1-имя + описание: в файлах внутри `template/` токены
     вида `{PROJECT_NAME}`, `{COMMUNICATION_LANGUAGE}` и др. должны оставаться
     плейсхолдерами. Реальные значения (имя репо, конкретный язык) — признак утечки
     мейнтейнерского контента в шаблонный слой.
5. **`.context/to-do.md`** — актуализация: отложенный п. 7 ADR-023 закрыт ADR-024;
   упомянуть, что `.claude/skills/project/rules/` в мейнтейнере теперь наполнен
   двумя правилами.

### Files

Create:

- `.claude/skills/project/rules/markdown-conventions.md`
- `.claude/skills/project/rules/no-placeholder-leaks.md`

Edit:

- `.claude/skills/meta/cc-code-polish.md` — таблица scope-аргументов + новый case
  в алгоритме + правка «Constraints»
- `template/.claude/skills/meta/cc-code-polish.md` — идентично
- `.claude/commands/polish.md` — только если решим упомянуть `--all` в описании
- `template/.claude/commands/polish.md` — идентично
- `.context/to-do.md` — актуализация после закрытия отложенного пункта

### Constraints

- **Не создавать `.polishignore`** по умолчанию — файл опциональный, контракт совпадает
  с `.gitignore`, отдельная документация не нужна.
- **`--all` только добавляется** — не меняет поведение diff-режимов (без аргументов,
  `<path>`, `--staged`).
- **Не звать `simplify` в `--all`** — даже если он доступен. Это ключевая часть ADR-024,
  а не оптимизация.
- **Confirm обязателен** — `--all` без подтверждения запускаться не должен, даже если
  scope маленький. Единообразие важнее микро-удобства.
- **Правила — только prose** по контракту ADR-023: H1 + свободное описание, без
  frontmatter, без секций, без severity, без auto-fix.
- **Обвязку в `/close` не трогать** — Прочтение 2 из обсуждения отклонено, `/polish`
  остаётся в руках пользователя.
- **Никаких «на всякий случай» абстракций**: не вводим severity, glob-фильтры,
  версионирование правил, per-file overrides — как и в ADR-023.

### Verification

Automatable:

```bash
# Files created
test -f .claude/skills/project/rules/markdown-conventions.md
test -f .claude/skills/project/rules/no-placeholder-leaks.md

# Skill files mention --all in both layers
grep -q -- '--all' .claude/skills/meta/cc-code-polish.md
grep -q -- '--all' template/.claude/skills/meta/cc-code-polish.md

# --all path explicitly disables simplify
grep -qi 'simplify.*not.*call\|no.*simplify\|skip.*simplify' \
  .claude/skills/meta/cc-code-polish.md

# Confirm step present in --all case
grep -qi 'confirm\|continue' .claude/skills/meta/cc-code-polish.md

# ADR-024 recorded
grep -q 'ADR-024' .context/decisions.md
```

Manual smoke:

- `/polish --all` в мейнтейнерском репо → выводит количество tracked-файлов и confirm.
- Посев: bold-as-heading в тестовом `.md` внутри `template/` → правило
  `markdown-conventions` его ловит; отказ posit — правило не срабатывает.
- Посев: заменить `{PROJECT_NAME}` на реальное имя в `template/CLAUDE.md` →
  `no-placeholder-leaks` его ловит. Возврат — правило молчит.
- Дефолтный `/polish` (без аргументов) на `feature/*` → поведение по ADR-023 не изменилось.

### Changes along the way

- Файлы `.claude/commands/polish.md` и `template/.claude/commands/polish.md`
  оставлены без изменений: они однострочные обёртки через `$ARGUMENTS`, `--all`
  пробрасывается автоматически. Правка не потребовалась.
- Правки `CLAUDE.md` и `template/CLAUDE.md` (таблицы команд) не понадобились:
  строка `/polish` уже описывает команду в общем виде, а не по режимам —
  добавлять `/polish --all` отдельным пунктом было бы избыточной детализацией.

### Notes

Feature-ветка: `feature/polish-all-mode`.

Задача умещается в одну ветку — три компонента (скилл × 2 слоя + 2 правила), меньше
порога «три компонента» из /architect. При реализации: сначала правила (изолированные,
проще протестировать по отдельности), затем алгоритм скилла в мейнтейнерском слое,
затем идентичный перенос в шаблон.
