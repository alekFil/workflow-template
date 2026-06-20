#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check dependencies
if ! command -v git &>/dev/null; then
    echo -e "${RED}Error:${NC} git is required but not found."
    exit 1
fi

# Check: current directory is the root of a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error:${NC} current directory is not the root of a git repository."
    exit 1
fi

# Determine which assistant files exist
TO_DELETE=()
[ -d ".claude" ]     && TO_DELETE+=(".claude/")
[ -d ".context" ]    && TO_DELETE+=(".context/")
[ -f "CLAUDE.md" ]   && TO_DELETE+=("CLAUDE.md")
[ -f "WORKFLOW.md" ] && TO_DELETE+=("WORKFLOW.md")

if [ ${#TO_DELETE[@]} -eq 0 ]; then
    echo "No assistant files found — nothing to remove."
    exit 0
fi

echo -e "${YELLOW}workflow-template — removing assistant${NC}"
echo ""

# Show full list before confirmation
echo "Will be removed:"
for item in "${TO_DELETE[@]}"; do
    echo "  $item"
done
[ -f ".gitignore" ] && echo ""
[ -f ".gitignore" ] && echo "The # workflow-template block will be removed from .gitignore."
[ -f ".git/info/exclude" ] && echo "The # workflow-template block will be removed from .git/info/exclude."

echo ""
read -p "Continue? [y/N]: " CONFIRM </dev/tty
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

# Remove files and directories
for item in "${TO_DELETE[@]}"; do
    rm -rf "$item"
done

# Clean workflow-template block from .gitignore
if [ -f ".gitignore" ]; then
    sed -i '/^# workflow-template:start$/,/^# workflow-template:end$/d' .gitignore
fi

# Clean workflow-template block from .git/info/exclude
if [ -f ".git/info/exclude" ]; then
    sed -i '/^# workflow-template:start$/,/^# workflow-template:end$/d' .git/info/exclude
fi

echo -e "${GREEN}Done.${NC} Assistant files removed."
echo "Changes are not committed — stage and commit manually if needed."
