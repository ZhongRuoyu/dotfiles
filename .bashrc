# shellcheck shell=bash

# Bash completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  # shellcheck source=/dev/null
  source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  # shellcheck source=/dev/null
  source /etc/bash_completion
fi

# Prompt settings
PS1="[\u@\h \W]\\$ "

# History control
HISTCONTROL=ignoreboth

# Homebrew completions
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
    # shellcheck source=/dev/null
    source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "$HOMEBREW_PREFIX/etc/bash_completion.d/"*; do
      # shellcheck source=/dev/null
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# Local bash settings
if [[ -e "$HOME/.bashrc.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc.local"
fi
