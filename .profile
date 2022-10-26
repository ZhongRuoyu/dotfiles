# Locale
export LANG=en_GB.UTF-8
export LC_COLLATE=POSIX
export LC_CTYPE=UTF-8
export LC_MESSAGES=POSIX
export LC_MONETARY=POSIX
export LC_NUMERIC=POSIX
export LC_TIME=POSIX

# Default programs
export EDITOR=vim
export PAGER=less
export VISUAL=vim


# ls
alias ls="ls -G"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# grep
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias grep="grep --color=auto"

# rm
rm() {
    echo "use \`command rm' instead:" >&2
    echo "command rm $@" >&2
    return 1
}

# sudo
alias sudo="sudo "

# tar
tar() {
    if [ "$#" -ge 1 ]; then
        local options="$1"
        if [ "${options:0:1}" != "-" ]; then
            options="-$options"
        fi
        set -- "$options" "${@:2}"
    fi
    COPYFILE_DISABLE=1 command tar --exclude=.DS_Store "$@"
}


# Local settings
export PATH="${PATH:+$PATH:}$HOME/local/bin"
export MANPATH=":${MANPATH:+$MANPATH:}$HOME/local/share/man"
export INFOPATH=":${INFOPATH:+$INFOPATH:}$HOME/local/share/info"
export CPATH="${CPATH:+$CPATH:}$HOME/local/include"
export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$HOME/local/lib"


# Homebrew
# eval "$("$HOME/opt/homebrew/bin/brew" shellenv)"
export HOMEBREW_PREFIX="$HOME/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH:+:$PATH}"
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH:+:$MANPATH}:"
export INFOPATH="$HOMEBREW_PREFIX/share/info${INFOPATH:+:$INFOPATH}:"
export CPATH="$HOMEBREW_PREFIX/include${CPATH:+:$CPATH}"
export LIBRARY_PATH="$HOMEBREW_PREFIX/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"


# Java
export CLASSPATH="${CLASSPATH:+$CLASSPATH:}$HOME/local/java/lib/*"


# Anaconda
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
    uninstall_conda_aliases
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("$HOME/opt/anaconda3/bin/conda" "shell.$(basename "$SHELL")" hook 2>/dev/null)"
    if [ "$?" -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/opt/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/opt/anaconda3/bin${PATH:+:$PATH}"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
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
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
install_nvm_aliases


# rbenv
eval "$(rbenv init - "$(basename "$SHELL")")"


# Local profile settings
if [ -e "$HOME/.profile.local" ]; then
    source "$HOME/.profile.local"
fi


