#!/bin/bash
set -e

REPO="https://github.com/alekFil/workflow-template"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Use /dev/tty for interactive input when running via curl | bash;
# fall back to stdin in non-TTY environments (CI, Docker, testing).
if ( </dev/tty ) 2>/dev/null; then
    TTY=/dev/tty
else
    TTY=/dev/stdin
fi

# Check dependencies
for cmd in git curl tar; do
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}Error:${NC} $cmd is required but not found."
        exit 1
    fi
done

# Check: current directory is the root of a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error:${NC} current directory is not the root of a git repository."
    echo "Run first: git init"
    exit 1
fi

# Check: directory is not empty
NON_GIT=$(find . -mindepth 1 -maxdepth 1 -not -name ".git" | wc -l)
if [ "$NON_GIT" -gt 0 ]; then
    echo -e "${YELLOW}Warning:${NC} directory is not empty."
    echo "  Will be overwritten: CLAUDE.md, WORKFLOW.md, .claude/, .context/"
    echo "  .gitignore will be appended (not overwritten)."
    echo ""
    read -p "Continue? [y/N]: " OVERWRITE_CONFIRM <"$TTY"
    if [[ "$OVERWRITE_CONFIRM" != "y" && "$OVERWRITE_CONFIRM" != "Y" ]]; then
        echo "Cancelled."
        exit 0
    fi
    echo ""
fi

echo -e "${BLUE}workflow-template — initializing new project${NC}"
echo ""

# Collect data
read -p "Project name: " PROJECT_NAME <"$TTY"
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error:${NC} project name cannot be empty."
    exit 1
fi

read -p "Remote URL (Enter — configure later): " REMOTE_URL <"$TTY"

echo ""
read -p "Hide assistant files from repository? (CLAUDE.md, WORKFLOW.md, .claude/, .context/ → .git/info/exclude) [y/N]: " HIDE_FILES <"$TTY"
read -p "Hide assistant from commit messages? [y/N]: " HIDE_COMMITS <"$TTY"

echo ""
DO_COMMIT="n"
read -p "Create initial commit? [y/N]: " DO_COMMIT <"$TTY"

DO_DEV="n"
DEV_QUESTION_ASKED=false
if [[ "$DO_COMMIT" == "y" || "$DO_COMMIT" == "Y" ]] || git rev-parse HEAD &>/dev/null 2>&1; then
    read -p "Create dev branch? [y/N]: " DO_DEV <"$TTY"
    DEV_QUESTION_ASKED=true
fi

echo ""
echo "  Project:   $PROJECT_NAME"
[ -n "$REMOTE_URL" ] && echo "  Remote:    $REMOTE_URL"
if [[ "$HIDE_FILES" == "y" || "$HIDE_FILES" == "Y" ]]; then
    echo "  Assistant: hidden (exclude)"
else
    echo "  Assistant: visible in repo"
fi
if [[ "$HIDE_COMMITS" == "y" || "$HIDE_COMMITS" == "Y" ]]; then
    echo "  Commits:   no attribution"
else
    echo "  Commits:   with attribution"
fi
if [[ "$DO_COMMIT" == "y" || "$DO_COMMIT" == "Y" ]]; then
    echo "  Commit:    create"
else
    echo "  Commit:    skip"
fi
if [ "$DEV_QUESTION_ASKED" = true ]; then
    if [[ "$DO_DEV" == "y" || "$DO_DEV" == "Y" ]]; then
        echo "  Dev branch: create"
    else
        echo "  Dev branch: skip"
    fi
fi
echo ""
read -p "Continue? [y/N]: " CONFIRM <"$TTY"
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

# Save existing .gitignore
EXISTING_GITIGNORE=""
[ -f ".gitignore" ] && EXISTING_GITIGNORE=$(cat .gitignore)

# Download template/ from repo
echo "Downloading template..."
curl -fsSL "${REPO}/archive/refs/heads/oss.tar.gz" \
    | tar xz --strip-components=2 "workflow-template-oss/template"

# Process .gitignore: append, do not overwrite
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

# Fill {PROJECT_NAME} in all .md files
echo "Filling placeholders..."
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{PROJECT_NAME}|$PROJECT_NAME|g" {} +

# Hide assistant files via .git/info/exclude
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

# Disable attribution in commits
if [[ "$HIDE_COMMITS" == "y" || "$HIDE_COMMITS" == "Y" ]]; then
    mkdir -p .claude
    echo '{
  "attribution": { "commit": "", "pr": "" }
}' > .claude/settings.json
fi

# Set remote
if [ -n "$REMOTE_URL" ]; then
    if git remote get-url origin &>/dev/null 2>&1; then
        git remote set-url origin "$REMOTE_URL"
    else
        git remote add origin "$REMOTE_URL"
    fi
fi

# Initial commit
if [[ "$DO_COMMIT" == "y" || "$DO_COMMIT" == "Y" ]]; then
    echo "Creating initial commit..."
    git add .
    git commit -m "chore: init from workflow-template"
fi

# Create dev branch
if [[ "$DO_DEV" == "y" || "$DO_DEV" == "Y" ]]; then
    git checkout -b dev
fi

echo ""
echo -e "${GREEN}Done!${NC} Project \"$PROJECT_NAME\" initialized."
echo ""
echo "Next steps:"
echo "  1. Launch CC and say: 'Read CLAUDE.md and help me fill in the remaining placeholders'"
[ -z "$REMOTE_URL" ] && echo "  2. Add remote: git remote add origin <url>"
