#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Source shell configs
if [ -n "$ZSH_VERSION" ]; then
    # Zsh specific settings
    [ -f "$DOTFILES/prompt.sh" ] && source "$DOTFILES/prompt.sh"
else
    # Fallback logic for Bash/Sh
    [ -f "$DOTFILES/aliases" ] && source "$DOTFILES/aliases"
fi

# One-time setup (only runs if script is executed, not just sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    chmod +x "$DOTFILES/semantic-branch.sh"
    git config --global core.excludesfile "$DOTFILES/gitignore_global"
    echo "Dotfiles setup complete."
fi
