# Dev-env dotfiles bootstrap. Source from ~/.zshrc:
#   [ -f "$HOME/Documents/dev-env/dotfiles/install.sh" ] && source "$HOME/Documents/dev-env/dotfiles/install.sh"

export DEV_ENV="${DEV_ENV:-$HOME/Documents/dev-env}"
DOTFILES="$DEV_ENV/dotfiles"

[ -f "$DOTFILES/aliases" ] && source "$DOTFILES/aliases"
[ -f "$DOTFILES/prompt.sh" ] && source "$DOTFILES/prompt.sh"

# Ensure semantic-branch script is executable (e.g. after fresh clone)
[ -f "$DOTFILES/semantic-branch.sh" ] && chmod +x "$DOTFILES/semantic-branch.sh"

# Global gitignore
[ -f "$DOTFILES/gitignore_global" ] && git config --global core.excludesfile "$DOTFILES/gitignore_global"
