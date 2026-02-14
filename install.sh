#!/bin/zsh

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"

# 1. Source Shared Configs (Works in both)
[ -f "$DOTFILES/aliases" ] && source "$DOTFILES/aliases"

# 2. Source Zsh-Specific Configs (Gated for safety)
if [ -n "$ZSH_VERSION" ]; then
    [ -f "$DOTFILES/prompt.sh" ] && source "$DOTFILES/prompt.sh"
fi

# 3. One-time setup
if [[ "${BASH_SOURCE[0]:-${(%):-%x}}" == "${0}" ]]; then
    chmod +x "$DOTFILES/semantic-branch.sh"
    git config --global core.excludesfile "$DOTFILES/gitignore_global"
fi

echo "Dotfiles have been setup!"
