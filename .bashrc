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

# Local bash settings
if [[ -e "$HOME/.bashrc.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc.local"
fi
