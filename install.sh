#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# 1. Source Shared Configs (Works in Bash and Zsh)
[ -f "$DOTFILES/aliases" ] && source "$DOTFILES/aliases"

# 2. Source Shell-Specific Configs
if [ -n "$ZSH_VERSION" ]; then
    [ -f "$DOTFILES/prompt.sh" ] && source "$DOTFILES/prompt.sh"
fi

# 3. One-time setup
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    chmod +x "$DOTFILES/semantic-branch.sh"
    git config --global core.excludesfile "$DOTFILES/gitignore_global"
fi

echo "Dotfiles have been setup!"
