#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Source shell configs
for file in aliases prompt.sh; do
    [ -f "$DOTFILES/$file" ] && source "$DOTFILES/$file"
done

# One-time setup (only runs if script is executed, not just sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    chmod +x "$DOTFILES/semantic-branch.sh"
    git config --global core.excludesfile "$DOTFILES/gitignore_global"
    echo "Dotfiles setup complete."
fi
