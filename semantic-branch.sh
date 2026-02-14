#!/usr/bin/env bash
#
# Semantic branch creator
# Creates git branches with conventional prefixes: feature/, fix/, chore/, etc.
#
# Usage:
#   ./semantic-branch.sh                    # interactive
#   ./semantic-branch.sh feature add-login   # type + slug
#   ./semantic-branch.sh -n                 # print name only, don't create
#

set -e

# Conventional branch types (extend as needed)
TYPES=(feature fix chore refactor docs test release hotfix)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_usage() {
  echo "Usage: $0 [OPTIONS] [TYPE] [DESCRIPTION]"
  echo ""
  echo "Create a semantic branch name and optionally create/checkout the branch."
  echo ""
  echo "Types: ${TYPES[*]}"
  echo ""
  echo "Options:"
  echo "  -n, --dry-run    Print branch name only, do not create or checkout"
  echo "  -h, --help       Show this help"
  echo ""
  echo "Examples:"
  echo "  $0                          # Interactive: prompts for type and description"
  echo "  $0 feature add-user-login   # feature/add-user-login"
  echo "  $0 fix login redirect       # fix/login-redirect"
  echo "  $0 -n chore update deps     # Prints chore/update-deps"
}

# Convert description to branch slug: lowercase, spaces/special chars -> hyphens
slugify() {
  local input="$*"
  echo "$input" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g'
}

# Validate branch type
is_valid_type() {
  local t="$1"
  for type in "${TYPES[@]}"; do
    [[ "$type" == "$t" ]] && return 0
  done
  return 1
}

# Parse flags
DRY_RUN=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=true; shift ;;
    -h|--help)    print_usage; exit 0 ;;
    *)            break ;;
  esac
done

# Collect type and description from args or interactively
if [[ $# -ge 2 ]]; then
  TYPE="$1"
  shift
  DESCRIPTION="$*"
elif [[ $# -eq 1 ]]; then
  if is_valid_type "$1"; then
    TYPE="$1"
    read -rp "Description (e.g. add login form): " DESCRIPTION
  else
    echo -e "${RED}Unknown type: $1. Use one of: ${TYPES[*]}${NC}" >&2
    exit 1
  fi
else
  echo -e "${CYAN}Semantic branch creator${NC}"
  echo ""
  echo "Type: ${TYPES[*]}"
  read -rp "Type: " TYPE
  read -rp "Description (e.g. add login form): " DESCRIPTION
fi

TYPE=$(echo "$TYPE" | tr '[:upper:]' '[:lower:]')
if ! is_valid_type "$TYPE"; then
  echo -e "${RED}Invalid type: $TYPE. Use one of: ${TYPES[*]}${NC}" >&2
  exit 1
fi

[[ -z "$DESCRIPTION" ]] && echo -e "${RED}Description is required.${NC}" >&2 && exit 1

SLUG=$(slugify "$DESCRIPTION")
BRANCH_NAME="${TYPE}/${SLUG}"

if [[ "$DRY_RUN" == true ]]; then
  echo "$BRANCH_NAME"
  exit 0
fi

# Ensure we're in a git repo
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo -e "${RED}Not a git repository.${NC}" >&2
  exit 1
fi

# Default branch to base from (current or main/master)
CURRENT=$(git branch --show-current 2>/dev/null || true)
if [[ -z "$CURRENT" ]]; then
  echo -e "${YELLOW}No current branch (detached HEAD). Creating from default branch.${NC}"
  CURRENT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
fi

if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  echo -e "${YELLOW}Branch $BRANCH_NAME already exists. Checking out.${NC}"
  git checkout "$BRANCH_NAME"
else
  echo -e "${GREEN}Creating and checking out branch: $BRANCH_NAME${NC}"
  git checkout -b "$BRANCH_NAME"
fi
