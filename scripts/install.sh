#!/bin/bash
set -e

REPO="https://github.com/alekFil/workflow-template"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Проверка зависимостей
for cmd in git curl tar; do
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}Ошибка:${NC} требуется $cmd, но не найден."
        exit 1
    fi
done

# Проверка: текущая директория — корень git-репозитория
if [ ! -d ".git" ]; then
    echo -e "${RED}Ошибка:${NC} текущая директория не является корнем git-репозитория."
    echo "Сначала выполни: git init"
    exit 1
fi

# Проверка: директория не пустая
NON_GIT=$(find . -mindepth 1 -maxdepth 1 -not -name ".git" | wc -l)
if [ "$NON_GIT" -gt 0 ]; then
    echo -e "${YELLOW}Предупреждение:${NC} директория не пустая."
    echo "  Будут перезаписаны: CLAUDE.md, WORKFLOW.md, .markdownlint.json, .claude/, .context/"
    echo "  .gitignore будет дополнен (не перезаписан)."
    echo ""
    read -p "Продолжить? [y/N]: " OVERWRITE_CONFIRM </dev/tty
    if [[ "$OVERWRITE_CONFIRM" != "y" && "$OVERWRITE_CONFIRM" != "Y" ]]; then
        echo "Отменено."
        exit 0
    fi
    echo ""
fi

echo -e "${BLUE}workflow-template — инициализация нового проекта${NC}"
echo ""

# Собрать данные
read -p "Название проекта: " PROJECT_NAME </dev/tty
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Ошибка:${NC} название не может быть пустым."
    exit 1
fi

read -p "Remote URL (Enter — настроить позже): " REMOTE_URL </dev/tty

echo ""
read -p "Скрыть файлы ассистента из репозитория? (CLAUDE.md, WORKFLOW.md, .claude/, .context/ → .git/info/exclude) [y/N]: " HIDE_FILES </dev/tty
read -p "Скрыть ассистента из сообщений коммитов? [y/N]: " HIDE_COMMITS </dev/tty

echo ""
DO_COMMIT="n"
read -p "Создать начальный коммит? [y/N]: " DO_COMMIT </dev/tty

DO_DEV="n"
DEV_QUESTION_ASKED=false
if [[ "$DO_COMMIT" == "y" || "$DO_COMMIT" == "Y" ]] || git rev-parse HEAD &>/dev/null 2>&1; then
    read -p "Создать ветку dev? [y/N]: " DO_DEV </dev/tty
    DEV_QUESTION_ASKED=true
fi

echo ""
echo "  Проект:    $PROJECT_NAME"
[ -n "$REMOTE_URL" ] && echo "  Remote:    $REMOTE_URL"
if [[ "$HIDE_FILES" == "y" || "$HIDE_FILES" == "Y" ]]; then
    echo "  Ассистент: скрыт (exclude)"
else
    echo "  Ассистент: виден в репо"
fi
if [[ "$HIDE_COMMITS" == "y" || "$HIDE_COMMITS" == "Y" ]]; then
    echo "  Коммиты:   без атрибуции"
else
    echo "  Коммиты:   со атрибуцией"
fi
if [[ "$DO_COMMIT" == "y" || "$DO_COMMIT" == "Y" ]]; then
    echo "  Коммит:    создать"
else
    echo "  Коммит:    пропустить"
fi
if [ "$DEV_QUESTION_ASKED" = true ]; then
    if [[ "$DO_DEV" == "y" || "$DO_DEV" == "Y" ]]; then
        echo "  Ветка dev: создать"
    else
        echo "  Ветка dev: пропустить"
    fi
fi
echo ""
read -p "Продолжить? [y/N]: " CONFIRM </dev/tty
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Отменено."
    exit 0
fi

echo ""

# Сохранить существующий .gitignore
EXISTING_GITIGNORE=""
[ -f ".gitignore" ] && EXISTING_GITIGNORE=$(cat .gitignore)

# Скачать template/ из репо
echo "Скачиваем шаблон..."
curl -fsSL "${REPO}/archive/refs/heads/main.tar.gz" \
    | tar xz --strip-components=2 "workflow-template-main/template"

# Обработать .gitignore: дополнить, не перезаписать
TEMPLATE_GITIGNORE=$(cat .gitignore)
if [ -n "$EXISTING_GITIGNORE" ]; then
    echo "$EXISTING_GITIGNORE" > .gitignore
    echo "" >> .gitignore
    echo "# workflow-template:start" >> .gitignore
    while IFS= read -r line; do
        if [ -n "$line" ] && [[ "$line" != \#* ]] && ! grep -qxF "$line" .gitignore; then
            echo "$line" >> .gitignore
        fi
    done <<< "$TEMPLATE_GITIGNORE"
    echo "# workflow-template:end" >> .gitignore
fi

# Заполнить {PROJECT_NAME} во всех .md
echo "Заполняем плейсхолдеры..."
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{PROJECT_NAME}|$PROJECT_NAME|g" {} +

# Скрыть файлы ассистента через .git/info/exclude
if [[ "$HIDE_FILES" == "y" || "$HIDE_FILES" == "Y" ]]; then
    mkdir -p .git/info
    {
        echo ""
        echo "# workflow-template:start"
        echo "CLAUDE.md"
        echo "WORKFLOW.md"
        echo ".claude/"
        echo ".context/"
        echo "# workflow-template:end"
    } >> .git/info/exclude
fi

# Отключить атрибуцию в коммитах
if [[ "$HIDE_COMMITS" == "y" || "$HIDE_COMMITS" == "Y" ]]; then
    mkdir -p .claude
    echo '{
  "attribution": { "commit": "", "pr": "" }
}' > .claude/settings.json
fi

# Привязать remote
if [ -n "$REMOTE_URL" ]; then
    if git remote get-url origin &>/dev/null 2>&1; then
        git remote set-url origin "$REMOTE_URL"
    else
        git remote add origin "$REMOTE_URL"
    fi
fi

# Начальный коммит
if [[ "$DO_COMMIT" == "y" || "$DO_COMMIT" == "Y" ]]; then
    echo "Создаём начальный коммит..."
    git add .
    git commit -m "chore: init from workflow-template"
fi

# Создать ветку dev
if [[ "$DO_DEV" == "y" || "$DO_DEV" == "Y" ]]; then
    git checkout -b dev
fi

echo ""
echo -e "${GREEN}Готово!${NC} Проект «$PROJECT_NAME» инициализирован."
echo ""
echo "Следующие шаги:"
echo "  1. Запусти CC и скажи: 'Прочитай CLAUDE.md и помоги заполнить оставшиеся плейсхолдеры'"
[ -z "$REMOTE_URL" ] && echo "  2. Добавь remote: git remote add origin <url>"
