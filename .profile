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
load_homebrew() {
  case "$(uname -s)" in
  "Darwin")
    case "$(uname -m)" in
    "amd64") HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}" ;;
    "x86_64") HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/usr/local}" ;;
    *) return ;;
    esac
    ;;
  "Linux") HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}" ;;
  *) return ;;
  esac
  if [ ! -e "$HOMEBREW_PREFIX" ]; then
    if [ -e "$HOME/opt/homebrew" ]; then
      HOMEBREW_PREFIX="$HOME/opt/homebrew"
    else
      return
    fi
  fi
  export HOMEBREW_PREFIX
  eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_NO_INSTALL_FROM_API=1
}
load_homebrew

# Local settings
export PATH="$HOME/local/bin${PATH:+:$PATH}"
export MANPATH="$HOME/local/share/man${MANPATH:+:$MANPATH}:"
export INFOPATH="$HOME/local/share/info${INFOPATH:+:$INFOPATH}:"
export CPATH="$HOME/local/include${CPATH:+:$CPATH}"
export LIBRARY_PATH="$HOME/local/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"

# shims
# https://github.com/ZhongRuoyu/shims
export SHIMS_LOCAL_PROFILES_PATH="$HOME/opt/shims/profiles"
export PATH="$HOME/opt/shims/local:$HOME/opt/shims/shims${PATH:+:$PATH}"

# shell-utils
# https://github.com/ZhongRuoyu/shell-utils
export PATH="$HOME/opt/shell-utils/bin${PATH:+:$PATH}"

# GPG
if [ -t 1 ]; then
  GPG_TTY="$(tty)"
  export GPG_TTY
fi

# Keychain
load_keychain() {
  KEYCHAIN_PREFIX="${KEYCHAIN_PREFIX:-$HOME/opt/keychain}"
  if [ ! -e "$KEYCHAIN_PREFIX" ]; then
    return
  fi
  export KEYCHAIN_PREFIX
  export PATH="$KEYCHAIN_PREFIX${PATH:+:$PATH}"
  eval "$(keychain --eval --noask --quiet)"
}
load_keychain

# cargo
load_cargo() {
  CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
  if [ ! -e "$CARGO_HOME" ]; then
    return
  fi
  export CARGO_HOME
  # shellcheck source=/dev/null
  source "$CARGO_HOME/env"
}
load_cargo

# opam
load_opam() {
  OPAM_HOME="${OPAM_HOME:-$HOME/.opam}"
  if [ ! -e "$OPAM_HOME" ]; then
    return
  fi
  # shellcheck source=/dev/null
  source "$OPAM_HOME/opam-init/init.zsh"
}
load_opam

# Conda
conda_aliases=(
  conda
  mamba
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
  CONDA_ROOT="${CONDA_ROOT:-$HOME/opt/miniforge3}"
  if [ ! -e "$CONDA_ROOT" ]; then
    return
  fi
  export CONDA_ROOT
  shell="$(ps -o comm= -p "$$" | sed -En 's/^(-|.*\/)?(.*)$/\2/p')"
  conda_setup="$("$CONDA_ROOT/bin/conda" "shell.$shell" hook)"
  eval "$conda_setup"
  # shellcheck source=/dev/null
  source "$CONDA_ROOT/etc/profile.d/mamba.sh"
  mamba activate default
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
  NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  if [ ! -e "$NVM_DIR" ]; then
    return
  fi
  export NVM_DIR
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"
  # shellcheck source=/dev/null
  source "$NVM_DIR/bash_completion"
}
install_nvm_aliases

# rbenv
rbenv_aliases=(
  rbenv
  bundle
  bundler
  erb
  gem
  irb
  racc
  rake
  rbs
  rdbg
  rdoc
  ri
  ruby
  typeprof
)
install_rbenv_aliases() {
  local rbenv_alias
  for rbenv_alias in "${rbenv_aliases[@]}"; do
    # shellcheck disable=SC2139
    alias "$rbenv_alias"="load_rbenv && $rbenv_alias"
  done
}
uninstall_rbenv_aliases() {
  local rbenv_alias
  for rbenv_alias in "${rbenv_aliases[@]}"; do
    if alias "$rbenv_alias" &>/dev/null; then
      unalias "$rbenv_alias"
    fi
  done
}
load_rbenv() {
  uninstall_rbenv_aliases
  RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
  if [ ! -e "$RBENV_ROOT" ]; then
    return
  fi
  export RBENV_ROOT
  eval "$("$RBENV_ROOT/bin/rbenv" init -)"
}
install_rbenv_aliases

# Local profile settings
if [ -e "$HOME/.profile.local" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.profile.local"
fi
