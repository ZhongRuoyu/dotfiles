# shellcheck disable=SC2148

# Locale
set_locale() {
  local locale_candidates=(
    "en_US.UTF-8" "en_US.utf8" "en_US"
    "C.UTF-8" "C.utf8" "C"
  )
  local all_locales
  all_locales="$(locale -a)"
  local locale_candidate
  for locale_candidate in "${locale_candidates[@]}"; do
    if echo "$all_locales" | grep -Fqx "$locale_candidate"; then
      export LC_ALL="$locale_candidate"
      break
    fi
  done
}
set_locale

# Default programs
export EDITOR=vim
export PAGER=less
export VISUAL=vim

# Enable colorized output
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# Allow alias substitution after sudo
alias sudo="sudo "

# Let tar ignore .DS_Store and ._ files
tar() {
  if [ "$#" -ge 1 ] && [ "${1:0:1}" != "-" ]; then
    set -- "-$1" "${@:2}"
  fi
  COPYFILE_DISABLE=1 command tar --exclude=".DS_Store" "$@"
}

# Homebrew
if [ -e "$HOME/opt/homebrew/bin/brew" ]; then
  eval "$("$HOME/opt/homebrew/bin/brew" shellenv)"
  export CPATH="$HOME/opt/homebrew/include${CPATH:+:$CPATH}"
  export LIBRARY_PATH="$HOME/opt/homebrew/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
  export HOMEBREW_NO_INSTALL_FROM_API=1
fi

# Local settings
export PATH="$HOME/local/bin${PATH:+:$PATH}"
export MANPATH="$HOME/local/share/man${MANPATH:+:$MANPATH}:"
export INFOPATH="$HOME/local/share/info${INFOPATH:+:$INFOPATH}:"
export CPATH="$HOME/local/include${CPATH:+:$CPATH}"
export LIBRARY_PATH="$HOME/local/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"

# GPG
if [ -t 1 ]; then
  GPG_TTY="$(tty)"
  export GPG_TTY
fi

# Keychain
if [ -e "$HOME/opt/keychain/keychain" ]; then
  export PATH="$HOME/opt/keychain${PATH:+:$PATH}"
  eval "$(keychain --eval --noask --quiet)"
fi

# rustup
if [ -e "$HOME/.cargo/env" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi

# Conda
conda_aliases=(
  conda
  2to3
  idle3
  pip pip3
  pydoc pydoc3
  python python3
  python3-config
  wheel wheel3
)
install_conda_aliases() {
  local conda_alias
  for conda_alias in "${conda_aliases[@]}"; do
    # shellcheck disable=SC2139
    alias "$conda_alias"="[ -n \"\$VIRTUAL_ENV\" ] || load_conda && $conda_alias"
  done
}
uninstall_conda_aliases() {
  local conda_alias
  for conda_alias in "${conda_aliases[@]}"; do
    if alias "$conda_alias" &>/dev/null; then
      unalias "$conda_alias"
    fi
  done
}
load_conda() {
  local shell
  local conda_setup
  uninstall_conda_aliases
  shell="$(ps -o comm= -p "$$" | sed -En 's/^(-|.*\/)?(.*)$/\2/p')"
  conda_setup="$("$HOME/opt/miniforge3/bin/conda" "shell.$shell" hook)"
  eval "$conda_setup"
  conda activate default
}
install_conda_aliases

# nvm
nvm_aliases=(
  node
  npm
  npx
  nvm
)
install_nvm_aliases() {
  local nvm_alias
  for nvm_alias in "${nvm_aliases[@]}"; do
    # shellcheck disable=SC2139
    alias "$nvm_alias"="load_nvm && $nvm_alias"
  done
}
uninstall_nvm_aliases() {
  local nvm_alias
  for nvm_alias in "${nvm_aliases[@]}"; do
    if alias "$nvm_alias" &>/dev/null; then
      unalias "$nvm_alias"
    fi
  done
}
load_nvm() {
  uninstall_nvm_aliases
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"
  # shellcheck source=/dev/null
  source "$NVM_DIR/bash_completion"
}
install_nvm_aliases

# rbenv
if [ -e "$HOME/.rbenv/bin/rbenv" ]; then
  eval "$("$HOME/.rbenv/bin/rbenv" init -)"
fi

# Local profile settings
if [ -e "$HOME/.profile.local" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.profile.local"
fi
