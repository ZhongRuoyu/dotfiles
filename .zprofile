# shellcheck disable=SC2148

# shellcheck source=/dev/null
source "$HOME/.profile"

# Local zsh profile
if [[ -e "$HOME/.zprofile.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.zprofile.local"
fi
