# Dynamic shell prompt with git branch
# Source after aliases (so DEV_ENV is set) or set DEV_ENV before sourcing.

setopt PROMPT_SUBST

git_branch_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " (${ref#refs/heads/})"
}

# %F{cyan}   -> Start Cyan color
# %1~        -> The current folder
# %f         -> Reset color
# %F{yellow} -> Start Yellow color
PROMPT='%F{cyan}%1~%f%F{yellow}$(git_branch_info)%f %# '
