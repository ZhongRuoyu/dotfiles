# shellcheck shell=bash

# Prompt settings
PS1="[\u@\h \W]\\$ "

# History control
HISTCONTROL=ignoreboth

# Local bash settings
if [[ -e "$HOME/.bashrc.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc.local"
fi
