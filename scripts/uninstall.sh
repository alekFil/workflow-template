#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Проверка зависимостей
if ! command -v git &>/dev/null; then
    echo -e "${RED}Ошибка:${NC} требуется git, но не найден."
    exit 1
fi

# Проверка: текущая директория — корень git-репозитория
if [ ! -d ".git" ]; then
    echo -e "${RED}Ошибка:${NC} текущая директория не является корнем git-репозитория."
    exit 1
fi

# Определить какие файлы ассистента существуют
TO_DELETE=()
[ -d ".claude" ]     && TO_DELETE+=(".claude/")
[ -d ".context" ]    && TO_DELETE+=(".context/")
[ -f "CLAUDE.md" ]   && TO_DELETE+=("CLAUDE.md")
[ -f "WORKFLOW.md" ] && TO_DELETE+=("WORKFLOW.md")

if [ ${#TO_DELETE[@]} -eq 0 ] && [ ! -f ".markdownlint.json" ]; then
    echo "Файлы ассистента не найдены — нечего удалять."
    exit 0
fi

echo -e "${YELLOW}workflow-template — удаление ассистента${NC}"
echo ""

# Спросить про .markdownlint.json отдельно
DELETE_MARKDOWNLINT="n"
if [ -f ".markdownlint.json" ]; then
    read -p "Удалить .markdownlint.json? [y/N]: " DELETE_MARKDOWNLINT </dev/tty
fi

# Показать полный список перед подтверждением
echo ""
echo "Будут удалены:"
for item in "${TO_DELETE[@]}"; do
    echo "  $item"
done
[[ "$DELETE_MARKDOWNLINT" == "y" || "$DELETE_MARKDOWNLINT" == "Y" ]] && echo "  .markdownlint.json"
[ -f ".gitignore" ] && echo ""
[ -f ".gitignore" ] && echo "Из .gitignore будет вычищен блок # workflow-template."
[ -f ".git/info/exclude" ] && echo "Из .git/info/exclude будет вычищен блок # workflow-template."

echo ""
read -p "Продолжить? [y/N]: " CONFIRM </dev/tty
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Отменено."
    exit 0
fi

echo ""

# Удалить файлы и директории
for item in "${TO_DELETE[@]}"; do
    rm -rf "$item"
done
[[ "$DELETE_MARKDOWNLINT" == "y" || "$DELETE_MARKDOWNLINT" == "Y" ]] && rm -f .markdownlint.json

# Вычистить блок workflow-template из .gitignore
if [ -f ".gitignore" ]; then
    sed -i '/^# workflow-template:start$/,/^# workflow-template:end$/d' .gitignore
fi

# Вычистить блок workflow-template из .git/info/exclude
if [ -f ".git/info/exclude" ]; then
    sed -i '/^# workflow-template:start$/,/^# workflow-template:end$/d' .git/info/exclude
fi

echo -e "${GREEN}Готово.${NC} Файлы ассистента удалены."
echo "Изменения не закоммичены — зафиксируй вручную если нужно."
