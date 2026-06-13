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

# Проверка: директория пустая (кроме .git)
NON_GIT=$(find . -mindepth 1 -maxdepth 1 -not -name ".git" | wc -l)
if [ "$NON_GIT" -gt 0 ]; then
    echo -e "${YELLOW}Предупреждение:${NC} директория не пустая — файлы могут быть перезаписаны."
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
echo "  Проект: $PROJECT_NAME"
[ -n "$REMOTE_URL" ] && echo "  Remote:  $REMOTE_URL"
echo ""
read -p "Продолжить? [y/N]: " CONFIRM </dev/tty
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Отменено."
    exit 0
fi

echo ""

# Скачать template/ из репо
echo "Скачиваем шаблон..."
curl -fsSL "${REPO}/archive/refs/heads/main.tar.gz" \
    | tar xz --strip-components=2 "workflow-template-main/template"

# Заполнить {PROJECT_NAME} во всех .md
echo "Заполняем плейсхолдеры..."
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{PROJECT_NAME}|$PROJECT_NAME|g" {} +

# Привязать remote
if [ -n "$REMOTE_URL" ]; then
    if git remote get-url origin &>/dev/null 2>&1; then
        git remote set-url origin "$REMOTE_URL"
    else
        git remote add origin "$REMOTE_URL"
    fi
fi

# Начальный коммит
echo "Создаём начальный коммит..."
git add .
git commit -m "chore: init from workflow-template"

# Создать ветку dev
git checkout -b dev

echo ""
echo -e "${GREEN}Готово!${NC} Проект «$PROJECT_NAME» инициализирован."
echo ""
echo "Следующие шаги:"
echo "  1. Запусти CC и скажи: 'Прочитай CLAUDE.md и помоги заполнить оставшиеся плейсхолдеры'"
[ -z "$REMOTE_URL" ] && echo "  2. Добавь remote: git remote add origin <url>"
