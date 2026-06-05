#!/bin/bash
set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Проверка: запущен из корня репо
if [ ! -d "template" ]; then
    echo -e "${RED}Ошибка:${NC} запусти скрипт из корня репо workflow-template."
    exit 1
fi

echo -e "${BLUE}workflow-template — инициализация нового проекта${NC}"
echo ""

# Собрать данные
read -p "Название проекта: " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Ошибка:${NC} название не может быть пустым."
    exit 1
fi

read -p "Remote URL (Enter — настроить позже): " REMOTE_URL

echo ""
echo "  Проект: $PROJECT_NAME"
[ -n "$REMOTE_URL" ] && echo "  Remote:  $REMOTE_URL"
echo ""
read -p "Продолжить? [y/N]: " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Отменено."
    exit 0
fi

echo ""

# Заполнить {PROJECT_NAME} в шаблонных файлах
echo "Заполняем плейсхолдеры..."
find template/ -name "*.md" -type f -exec sed -i "s|{PROJECT_NAME}|$PROJECT_NAME|g" {} +

# Переместить шаблонный слой в корень
echo "Перемещаем шаблон..."
rm -rf docs/ .claude/
mv template/docs     ./docs
mv template/.claude  ./.claude
mv template/CLAUDE.md   ./CLAUDE.md
mv template/WORKFLOW.md ./WORKFLOW.md
rm -rf template/

# Удалить мейнтейнерские файлы (включая этот скрипт)
rm -f CONTRIBUTION.md SETUP.md README.md LICENSE
rm -rf scripts/

# Переинициализировать git
echo "Инициализируем git..."
rm -rf .git
git init -q
[ -n "$REMOTE_URL" ] && git remote add origin "$REMOTE_URL"

# Начальный коммит
git add .
git commit -m "chore: init from workflow-template"

echo ""
echo -e "${GREEN}Готово!${NC} Проект «$PROJECT_NAME» инициализирован."
echo ""
echo "Следующие шаги:"
echo "  1. Открой CLAUDE.md — заполни оставшиеся плейсхолдеры"
echo "  2. Скажи CC: 'Прочитай CLAUDE.md и помоги заполнить оставшиеся плейсхолдеры'"
[ -z "$REMOTE_URL" ] && echo "  3. Добавь remote: git remote add origin <url>"
