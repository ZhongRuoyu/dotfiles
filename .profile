# shellcheck disable=SC2148

# Default programs
export EDITOR=vim
export PAGER=less
export VISUAL=vim


# ls
alias ls="ls -G"
alias l="ls -ahl"
alias la="ls -Ahl"
alias ll="ls -hl"

# grep
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias grep="grep --color=auto"

# sudo
alias sudo="sudo "

# tar
tar() {
  local options
  if [ "$#" -ge 1 ]; then
    options="$1"
    if [ "${options:0:1}" != "-" ]; then
      options="-$options"
    fi
    set -- "$options" "${@:2}"
  fi
  COPYFILE_DISABLE=1 command tar --exclude=.DS_Store "$@"
}


# Homebrew
if [ -e "$HOME/opt/homebrew/bin/brew" ]; then
  eval "$("$HOME/opt/homebrew/bin/brew" shellenv)"
  export CPATH="$HOME/opt/homebrew/include${CPATH:+:$CPATH}"
  export LIBRARY_PATH="$HOME/opt/homebrew/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
fi


# Keychain
if [ -e "$HOME/opt/keychain/keychain" ]; then
  export PATH="$HOME/opt/keychain${PATH:+:$PATH}"
  eval "$(keychain --eval --noask --quiet)"
fi


# Local settings
export PATH="$HOME/local/bin${PATH:+:$PATH}"
export MANPATH="$HOME/local/share/man${MANPATH:+:$MANPATH}:"
export INFOPATH="$HOME/local/share/info${INFOPATH:+:$INFOPATH}:"
export CPATH="$HOME/local/include${CPATH:+:$CPATH}"
export LIBRARY_PATH="$HOME/local/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"


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
  unset -f install_conda_aliases
  local conda_alias
  for conda_alias in "${conda_aliases[@]}"; do
    # shellcheck disable=SC2139
    alias "$conda_alias"="load_conda && $conda_alias"
  done
}
uninstall_conda_aliases() {
  unset -f uninstall_conda_aliases
  local conda_alias
  for conda_alias in "${conda_aliases[@]}"; do
    unalias "$conda_alias" || true
  done
}
load_conda() {
  unset -f load_conda
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
  nvm
  node
  npm
  npx
)
install_nvm_aliases() {
  unset -f install_nvm_aliases
  local nvm_alias
  for nvm_alias in "${nvm_aliases[@]}"; do
    # shellcheck disable=SC2139
    alias "$nvm_alias"="load_nvm && $nvm_alias"
  done
}
uninstall_nvm_aliases() {
  unset -f uninstall_nvm_aliases
  local nvm_alias
  for nvm_alias in "${nvm_aliases[@]}"; do
    unalias "$nvm_alias" || true
  done
}
load_nvm() {
  unset -f load_nvm
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


