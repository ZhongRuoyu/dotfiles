# shellcheck shell=bash

# shellcheck source=/dev/null
source "$HOME/.bash/env"
BASH_ENV=""

# shellcheck source=/dev/null
source "$HOME/.bash/login"

if [[ $- == *i* ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.bash/interactive"
fi
