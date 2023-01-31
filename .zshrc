# shellcheck disable=SC2148

# Homebrew completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions${FPATH:+:$FPATH}"
fi

# oh-my-zsh settings
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
# shellcheck disable=SC2034
plugins=(
  # oh-my-zsh plugins
  docker
  git
  pip
  # custom plugins
  conda-zsh-completion
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# zsh-completions
# https://github.com/zsh-users/zsh-completions/issues/603
FPATH="$ZSH_CUSTOM/plugins/zsh-completions/src${FPATH:+:$FPATH}"
# shellcheck source=/dev/null
source "$ZSH/oh-my-zsh.sh"

# Prompt settings
PS1="[%n@%m %1~]%(!.#.$) "

# History control
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Local zsh settings
if [[ -e "$HOME/.zshrc.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.zshrc.local"
fi
