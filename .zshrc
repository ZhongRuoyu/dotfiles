# shellcheck disable=SC2148

# oh-my-zsh settings
export ZSH="$HOME/.oh-my-zsh"
# shellcheck disable=SC2034
plugins=(
  brew
  conda-zsh-completion
  docker
  docker-compose
  git
  golang
  httpie
  macos
  npm
  nvm
  pip
  python
  rust
  ubuntu
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# shellcheck source=/dev/null
source "$ZSH/oh-my-zsh.sh"

# Prompt settings
PS1="[%n@%m %1~]%(!.#.$) "

# History control
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Homebrew completions
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions${FPATH:+:$FPATH}"
  autoload -Uz compinit
  compinit
fi

# Local zsh settings
if [[ -e "$HOME/.zshrc.local" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.zshrc.local"
fi
