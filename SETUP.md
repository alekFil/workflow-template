# workflow-template – Setup guide

This template brings Claude Code workflow structure to your new project.

---

## Prerequisites

### Claude Code

If Claude Code is not yet installed:

1. Install [Node.js](https://nodejs.org) (LTS)
2. Install Claude Code:

   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

3. Authorize – run `claude` and follow the instructions
4. Verify: `claude --version`

---

## Install via curl

```bash
mkdir my-project && cd my-project
git init
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/install.sh | bash
```

The script asks for the profile, the project name, the remote URL, the languages,
the branch model and the merge mode, downloads the template and optionally creates
an initial commit.

### Install another version

By default the template comes from `main`. `WT_REF` selects another branch or tag,
`WT_SOURCE` installs from a local clone without downloading:

```bash
# development version from dev (take install.sh from the same branch)
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/dev/scripts/install.sh | WT_REF=dev bash

# the workflow before the 2026-11 redesign
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/install.sh | WT_REF=v1 bash

# from a local clone, e.g. to test changes before push
WT_SOURCE=~/projects/workflow-template bash ~/projects/workflow-template/scripts/install.sh
```

---

## Uninstall

To remove the assistant from a project:

```bash
curl -fsSL https://raw.githubusercontent.com/alekFil/workflow-template/main/scripts/uninstall.sh | bash
```

The script removes the assistant files and cleans up related entries from `.gitignore` and `.git/info/exclude`. No commit is created – stage and commit the changes manually.

---

## Getting started with CC

After setup:

```text
Read CLAUDE.md and help me fill in the remaining placeholders.
```

---

## What the template includes

The file tree and the commands – [README.md](README.md#what-you-get) and
`WORKFLOW.md`, installed into your project.

### Profiles

| Profile | Run the installer in | Result |
| --- | --- | --- |
| `project` | your project repository | code and workflow context in one repository |
| `own-oss` | a new private repository (`my-project-devmeta`) | context here, your public repository cloned into `code/` |
| `contribution` | a new private repository (`lib-devmeta`) | context here, your fork cloned into `code/`, pull requests go upstream |

On a new machine, clone the devmeta repository and run:

```bash
.claude/scripts/workflow.sh bootstrap
```

---

## Want to improve the template?

Work directly in this repo – it has its own `CLAUDE.md` with maintainer instructions.
See `CONTRIBUTION.md` for details.
