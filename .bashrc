# shellcheck shell=bash

# Bash completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  # shellcheck source=/dev/null
  source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  # shellcheck source=/dev/null
  source /etc/bash_completion
fi

# Homebrew completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
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

# Prompt settings
PS1="[\u@\h \W]\\$ "

# History control
HISTCONTROL=ignoreboth

# Local bash settings
if [[ -e "$HOME/.bashrc.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc.local"
fi
