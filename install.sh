#!/bin/bash
# We start with bash because it's the Ubuntu default for the initial run

# --- LOGGING START ---
echo "--- Dotfiles Debug Log ---"
echo "Current Shell: $(ps -p $$ -o comm=)"
echo "ZSH_VERSION: ${ZSH_VERSION:-'Not Set'}"
echo "BASH_VERSION: ${BASH_VERSION:-'Not Set'}"

# Robust path detection
if [ -n "$ZSH_VERSION" ]; then
    DOTFILES_DIR="${(%):-%x}"
elif [ -n "$BASH_VERSION" ]; then
    DOTFILES_DIR="${BASH_SOURCE[0]}"
else
    DOTFILES_DIR="$0"
fi

DOTFILES="$(cd "$(dirname "$DOTFILES_DIR")" && pwd)"
echo "Detected DOTFILES Directory: $DOTFILES"
# --- LOGGING END ---

# 1. Source Shared Configs
if [ -f "$DOTFILES/aliases" ]; then
    echo "Sourcing aliases..."
    source "$DOTFILES/aliases"
else
    echo "Warning: $DOTFILES/aliases not found."
fi

# 2. Source Zsh-Specific Configs
if [ -n "$ZSH_VERSION" ]; then
    if [ -f "$DOTFILES/prompt.sh" ]; then
        echo "Sourcing prompt.sh..."
        source "$DOTFILES/prompt.sh"
    else
        echo "Warning: $DOTFILES/prompt.sh not found."
    fi
else
    echo "Skipping Zsh-specific prompt (Current shell is not Zsh)."
fi

# 3. One-time setup
echo "Running one-time setup..."
chmod +x "$DOTFILES/semantic-branch.sh" 2>/dev/null || echo "Could not chmod semantic-branch.sh"
git config --global core.excludesfile "$DOTFILES/gitignore_global"

echo "Dotfiles setup check complete!"
