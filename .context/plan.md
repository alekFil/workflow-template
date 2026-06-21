## Task: Добавить явную настройку языка в установщик и CLAUDE.md

### Context

Сейчас `template/CLAUDE.md` содержит расплывчатую инструкцию "respond in the user's language",
которая заставляет Claude угадывать язык. Нужно сделать язык явной конфигурацией:
задавать вопросы при установке и вписывать конкретные значения в CLAUDE.md.

Воркфлоу-документы (`.claude/`, skills, команды) — всегда English (invariant, без плейсхолдера).
Три настраиваемые оси: общение, контекст, комментарии в коде.

Depends on: —

### Что реализовать

1. Добавить в `template/CLAUDE.md` секцию Language с тремя плейсхолдерами, убрать упоминание языка из `{CODE_CONVENTIONS}`
2. Обновить `CLAUDE.md` (root) — ту же секцию с реальными значениями (ru / ru / English)
3. Добавить в `scripts/install.sh` блок вопросов о языке и подстановку трёх плейсхолдеров

### Files

Редактировать:
- `template/CLAUDE.md` — строка 6: заменить на явную Language-секцию с 3 плейсхолдерами; строка 193: убрать `{- Comment language: English}` из `{CODE_CONVENTIONS}`
- `CLAUDE.md` — строка 3: заменить на ту же Language-секцию с реальными значениями
- `scripts/install.sh` — добавить блок языковых вопросов после вопроса о PROJECT_NAME (≈ строка 57), добавить 3 `sed`-подстановки в блок "Fill placeholders" (≈ строка 134)

### Целевой вид Language-секции в template/CLAUDE.md

```markdown
**Language:**
- Communication: {COMMUNICATION_LANGUAGE}
- `.context/` files: {CONTEXT_LANGUAGE}
- Code comments: {CODE_COMMENTS_LANGUAGE}
- Workflow docs (`.claude/`, skills, commands): English
```

### Целевой вид Language-секции в CLAUDE.md (root)

```markdown
**Language:**
- Communication: Russian
- `.context/` files: Russian
- Code comments: English
- Workflow docs (`.claude/`, skills, commands): English
```

### Целевой флоу install.sh

```bash
# --- Language ---
echo ""
read -p "One language for everything (English), or configure per area? [one/multi]: " LANG_MODE <"$TTY"

if [[ "$LANG_MODE" == "multi" ]]; then
    echo "  (Workflow docs are always in English)"
    read -p "  Communication language (ru/en/...): " COMM_LANG <"$TTY"
    read -p "  .context/ files language (ru/en/...): " CONTEXT_LANG <"$TTY"
    read -p "  Code comments language (ru/en/...): " CODE_LANG <"$TTY"
else
    COMM_LANG="English"
    CONTEXT_LANG="English"
    CODE_LANG="English"
fi
```

В summary перед подтверждением добавить:
```bash
echo "  Communication: $COMM_LANG"
echo "  Context files: $CONTEXT_LANG"
echo "  Code comments: $CODE_LANG"
echo "  Workflow docs: English"
```

В блок подстановок:
```bash
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{COMMUNICATION_LANGUAGE}|$COMM_LANG|g" {} +
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{CONTEXT_LANGUAGE}|$CONTEXT_LANG|g" {} +
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{CODE_COMMENTS_LANGUAGE}|$CODE_LANG|g" {} +
```

### Constraints

- `CLAUDE.md` (root) — реальные значения, не плейсхолдеры
- Воркфлоу-язык не является плейсхолдером — он хардкодится как "English" в обоих файлах
- `{CODE_CONVENTIONS}` в template/CLAUDE.md: убрать только строку `{- Comment language: English}`, остальные примеры не трогать
- Не менять порядок существующих вопросов в install.sh — языковой блок вставляется сразу после PROJECT_NAME, до вопросов о hide/commit
- Переменные `COMM_LANG`, `CONTEXT_LANG`, `CODE_LANG` должны иметь значение по умолчанию до summary, даже если пользователь не ввёл ничего (обработать пустой ввод так же как `one`)

### Verification

```bash
# Плейсхолдеры присутствуют в template
grep "COMMUNICATION_LANGUAGE\|CONTEXT_LANGUAGE\|CODE_COMMENTS_LANGUAGE" template/CLAUDE.md

# Старая расплывчатая строка удалена из обоих файлов
grep "user's language" template/CLAUDE.md CLAUDE.md
# ожидаемый вывод: пусто

# Реальные значения в root CLAUDE.md
grep "Russian\|English" CLAUDE.md | head -5

# Comment language убрана из CODE_CONVENTIONS
grep "Comment language" template/CLAUDE.md
# ожидаемый вывод: пусто

# Подстановки добавлены в install.sh
grep "COMMUNICATION_LANGUAGE\|CONTEXT_LANGUAGE\|CODE_COMMENTS_LANGUAGE" scripts/install.sh

# Языковой блок вопросов есть в install.sh
grep "one/multi\|LANG_MODE\|COMM_LANG" scripts/install.sh
```

### Changes along the way

(нет)
