#!/bin/bash
set -e

REPO="https://github.com/alekFil/workflow-template"
# Template source: a branch or tag of $REPO (WT_REF), or a local clone (WT_SOURCE).
# Examples:
#   curl -fsSL .../dev/scripts/install.sh | WT_REF=dev bash
#   WT_SOURCE=~/projects/workflow-template bash ~/projects/workflow-template/scripts/install.sh
WT_REF="${WT_REF:-main}"
WT_SOURCE="${WT_SOURCE:-}"
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
DEPS="git"
[ -z "$WT_SOURCE" ] && DEPS="git curl tar"
for cmd in $DEPS; do
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

echo -e "${BLUE}workflow-template – initializing new project${NC}"
echo ""

# Collect data
read -p "Project name: " PROJECT_NAME <"$TTY"
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error:${NC} project name cannot be empty."
    exit 1
fi

read -p "Remote URL (Enter – configure later): " REMOTE_URL <"$TTY"

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

echo ""
read -p "Hide assistant files from repository? (CLAUDE.md, WORKFLOW.md, .claude/, .context/ → .git/info/exclude) [y/N]: " HIDE_FILES <"$TTY"
read -p "Hide assistant from commit messages? [y/N]: " HIDE_COMMITS <"$TTY"

echo ""
DO_COMMIT="n"
read -p "Create initial commit? [y/N]: " DO_COMMIT <"$TTY"

# --- Branches ---
echo ""
echo "Branch model:"
echo "  trunk – main + feature/* (simplest; good for working alone with the agent)"
echo "  dev   – main + dev + feature/* + hotfix/* (releases: dev → main manually)"
read -p "Branch model [trunk/dev] (default: trunk): " BRANCH_MODEL <"$TTY"
BRANCH_MODEL=${BRANCH_MODEL:-trunk}
if [[ "$BRANCH_MODEL" != "trunk" && "$BRANCH_MODEL" != "dev" ]]; then
    echo -e "${RED}Error:${NC} branch model must be trunk or dev."
    exit 1
fi
echo "Merge mode:"
echo "  local – /close merges the task branch on this machine (ff-only, no push)"
echo "  pr    – /close pushes the task branch and opens a pull request (team work)"
read -p "Merge mode [local/pr] (default: local): " MERGE_MODE <"$TTY"
MERGE_MODE=${MERGE_MODE:-local}
if [[ "$MERGE_MODE" != "local" && "$MERGE_MODE" != "pr" ]]; then
    echo -e "${RED}Error:${NC} merge mode must be local or pr."
    exit 1
fi

echo ""
echo "  Project:        $PROJECT_NAME"
[ -n "$REMOTE_URL" ] && echo "  Remote:         $REMOTE_URL"
echo "  Communication:  $COMM_LANG"
echo "  Context files:  $CONTEXT_LANG"
echo "  Code comments:  $CODE_LANG"
echo "  Workflow docs:  English"
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
echo "  Branches:  $BRANCH_MODEL model, $MERGE_MODE merge"
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

# Copy template/ into the project: from a local clone or from a downloaded archive
TMPDIR_WT=$(mktemp -d /tmp/workflow-template-XXXXXX)
trap 'rm -rf "$TMPDIR_WT"' EXIT

if [ -n "$WT_SOURCE" ]; then
    if [ ! -d "$WT_SOURCE/template" ]; then
        echo -e "${RED}Error:${NC} $WT_SOURCE/template not found."
        exit 1
    fi
    echo "Copying template from $WT_SOURCE..."
    TEMPLATE_DIR="$WT_SOURCE/template"
else
    echo "Downloading template ($WT_REF)..."
    MAX_ATTEMPTS=3
    RETRY_DELAY=5
    DOWNLOAD_OK=false
    for attempt in $(seq 1 $MAX_ATTEMPTS); do
        # archive/<ref> resolves both branches and tags
        if curl -fsSL "${REPO}/archive/${WT_REF}.tar.gz" -o "$TMPDIR_WT/src.tar.gz"; then
            DOWNLOAD_OK=true
            break
        fi
        if [ "$attempt" -lt "$MAX_ATTEMPTS" ]; then
            echo -e "${YELLOW}Warning:${NC} download failed, retrying in ${RETRY_DELAY}s... (${attempt}/${MAX_ATTEMPTS})"
            sleep "$RETRY_DELAY"
        fi
    done

    if [ "$DOWNLOAD_OK" = false ]; then
        echo -e "${RED}Error:${NC} failed to download template ($WT_REF) after ${MAX_ATTEMPTS} attempts."
        exit 1
    fi

    # The top-level folder name depends on the ref (GitHub strips "v" from tags),
    # so extract everything and locate template/ instead of guessing the name.
    tar xzf "$TMPDIR_WT/src.tar.gz" -C "$TMPDIR_WT"
    TEMPLATE_DIR=$(find "$TMPDIR_WT" -mindepth 2 -maxdepth 2 -type d -name template | head -1)
    if [ -z "$TEMPLATE_DIR" ]; then
        echo -e "${RED}Error:${NC} template/ not found in the archive."
        exit 1
    fi
fi

cp -a "$TEMPLATE_DIR/." .

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

# Fill placeholders in all .md files
echo "Filling placeholders..."
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{PROJECT_NAME}|$PROJECT_NAME|g" {} +
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{COMMUNICATION_LANGUAGE}|$COMM_LANG|g" {} +
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{CONTEXT_LANGUAGE}|$CONTEXT_LANG|g" {} +
find . -name "*.md" -not -path "./.git/*" \
    -exec sed -i "s|{CODE_COMMENTS_LANGUAGE}|$CODE_LANG|g" {} +
sed -i -e "s|{BRANCH_MODEL}|$BRANCH_MODEL|" -e "s|{MERGE_MODE}|$MERGE_MODE|" \
    .claude/workflow.conf

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

# Dev model: create dev from the current branch once a commit exists
if [ "$BRANCH_MODEL" = "dev" ]; then
    if git show-ref --verify --quiet refs/heads/dev; then
        echo "Branch dev already exists – kept as is."
    elif git rev-parse HEAD &>/dev/null; then
        git checkout -b dev
    else
        echo -e "${YELLOW}Note:${NC} no commits yet – create dev after the first commit:"
        echo "  git checkout -b dev"
    fi
fi

echo ""
echo -e "${GREEN}Done!${NC} Project \"$PROJECT_NAME\" initialized."
echo ""
echo "Next steps:"
echo "  1. Launch CC and say: 'Read CLAUDE.md and help me fill in the remaining placeholders'"
[ -z "$REMOTE_URL" ] && echo "  2. Add remote: git remote add origin <url>"
