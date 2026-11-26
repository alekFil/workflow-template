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
echo "Profile:"
echo "  project      – code and workflow context in this repository"
echo "  own-oss      – this is a private devmeta repository; your public code repository"
echo "                 is cloned into code/ and receives no workflow files"
echo "  contribution – private devmeta repository for a contribution to someone else's"
echo "                 project; your fork is cloned into code/"
read -p "Profile [project/own-oss/contribution] (default: project): " PROFILE <"$TTY"
PROFILE=${PROFILE:-project}
case "$PROFILE" in
    project|own-oss|contribution) ;;
    *) echo -e "${RED}Error:${NC} unknown profile: $PROFILE"; exit 1 ;;
esac

read -p "Project name: " PROJECT_NAME <"$TTY"
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error:${NC} project name cannot be empty."
    exit 1
fi

if [ "$PROFILE" = "project" ]; then
    read -p "Remote URL (Enter – configure later): " REMOTE_URL <"$TTY"
else
    read -p "Remote URL of this private devmeta repository (Enter – configure later): " REMOTE_URL <"$TTY"
    if [ "$PROFILE" = "own-oss" ]; then
        read -p "Clone URL of your public code repository (Enter – clone into code/ later): " CODE_REPO <"$TTY"
    else
        read -p "Clone URL of your fork (Enter – clone into code/ later): " CODE_REPO <"$TTY"
        read -p "URL of the original (upstream) repository: " UPSTREAM_REPO <"$TTY"
        if [ -z "$UPSTREAM_REPO" ]; then
            echo -e "${RED}Error:${NC} the contribution profile needs the upstream repository."
            exit 1
        fi
        read -p "Upstream default branch (default: main): " UPSTREAM_BRANCH <"$TTY"
        UPSTREAM_BRANCH=${UPSTREAM_BRANCH:-main}
    fi
fi

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
if [ "$PROFILE" = "project" ]; then
    read -p "Hide assistant files from repository? (CLAUDE.md, WORKFLOW.md, .claude/, .context/ → .git/info/exclude) [y/N]: " HIDE_FILES <"$TTY"
fi
read -p "Hide assistant from commit messages? [y/N]: " HIDE_COMMITS <"$TTY"

echo ""
DO_COMMIT="n"
read -p "Create initial commit? [y/N]: " DO_COMMIT <"$TTY"

# --- Branches ---
if [ "$PROFILE" = "contribution" ]; then
    # Someone else's project: task branches from upstream, every task ends in a PR.
    BRANCH_MODEL=trunk
    MERGE_MODE=pr
else
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
fi

echo ""
echo "  Profile:        $PROFILE"
echo "  Project:        $PROJECT_NAME"
[ -n "${CODE_REPO:-}" ] && echo "  Code repo:      $CODE_REPO → code/"
[ -n "${UPSTREAM_REPO:-}" ] && echo "  Upstream:       $UPSTREAM_REPO ($UPSTREAM_BRANCH)"
[ -n "$REMOTE_URL" ] && echo "  Remote:         $REMOTE_URL"
echo "  Communication:  $COMM_LANG"
echo "  Context files:  $CONTEXT_LANG"
echo "  Code comments:  $CODE_LANG"
echo "  Workflow docs:  English"
if [ "$PROFILE" != "project" ]; then
    echo "  Assistant: in this private devmeta repository"
elif [[ "$HIDE_FILES" == "y" || "$HIDE_FILES" == "Y" ]]; then
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

# Profile settings
set_conf() { sed -i "s|^$1=.*|$1=$2|" .claude/workflow.conf; }
set_conf PROFILE "$PROFILE"
if [ "$PROFILE" != "project" ]; then
    set_conf CODE_DIR code
    set_conf CODE_REPO "${CODE_REPO:-}"
    grep -qxF "code/" .gitignore || printf 'code/\n' >> .gitignore
fi
if [ "$PROFILE" = "own-oss" ]; then
    # Public ADRs live in the code repository; the product file stays private here.
    set_conf DECISIONS_DIR code/docs/decisions
    rm -rf docs/decisions
fi
if [ "$PROFILE" = "contribution" ]; then
    set_conf UPSTREAM_REPO "$UPSTREAM_REPO"
    set_conf UPSTREAM_BRANCH "$UPSTREAM_BRANCH"
    set_conf DECISIONS_DIR none
    set_conf PRODUCT_FILE none
    rm -rf docs
fi

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

# Devmeta profiles: clone the code repository and install the leak guard
if [ "$PROFILE" != "project" ]; then
    if [ -n "${CODE_REPO:-}" ]; then
        bash .claude/scripts/workflow.sh bootstrap || \
            echo -e "${YELLOW}Note:${NC} bootstrap failed – fix the URL in .claude/workflow.conf and run .claude/scripts/workflow.sh bootstrap"
    else
        echo -e "${YELLOW}Note:${NC} set CODE_REPO in .claude/workflow.conf, then run .claude/scripts/workflow.sh bootstrap"
    fi
fi

# Dev model: create dev from the current branch once a commit exists.
# Devmeta repositories keep a single main branch; dev belongs to the code repository.
if [ "$BRANCH_MODEL" = "dev" ] && [ "$PROFILE" = "project" ]; then
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
