# shellcheck shell=bash

# shellcheck source=/dev/null
source "$HOME/.profile"
# shellcheck source=/dev/null
source "$HOME/.bashrc"

# Local bash profile
if [[ -e "$HOME/.bash_profile.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.bash_profile.local"
fi
