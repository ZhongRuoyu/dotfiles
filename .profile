# Locale
export LC_ALL=en_GB.UTF-8

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
    echo "use command rm instead:" >&2
    echo "command rm $@" >&2
    return 1
}

# sudo
alias sudo="sudo "

# tar
tar() {
    COPYFILE_DISABLE=1 command tar --exclude=.DS_Store "$@"
}


# Local settings
export PATH="${PATH:+$PATH:}$HOME/local/bin"
export MANPATH=":${MANPATH:+$MANPATH:}$HOME/local/share/man"
export INFOPATH=":${INFOPATH:+$INFOPATH:}$HOME/local/share/info"
export CPATH="${CPATH:+$CPATH:}$HOME/local/include"
export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$HOME/local/lib"


# Homebrew
# eval "$($HOME/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_PREFIX="$HOME/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
export PATH="${PATH:+$PATH:}$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin"
export MANPATH=":${MANPATH:+$MANPATH:}$HOMEBREW_PREFIX/share/man"
export INFOPATH=":${INFOPATH:+$INFOPATH:}$HOMEBREW_PREFIX/share/info"
export CPATH="${CPATH:+$CPATH:}$HOMEBREW_PREFIX/include"
export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$HOMEBREW_PREFIX/lib"

# GNU Binutils
export PATH="${PATH:+$PATH:}$HOMEBREW_PREFIX/opt/binutils/bin"

# GNU sed
export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin${PATH:+:$PATH}"

# LLVM
export PATH="${PATH:+$PATH:}$HOMEBREW_PREFIX/opt/llvm/bin"

# OpenSSL
export CPATH="${CPATH:+$CPATH:}$HOMEBREW_PREFIX/opt/openssl/include"
export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$HOMEBREW_PREFIX/opt/openssl/lib"

# Ruby
export PATH="$HOMEBREW_PREFIX/opt/ruby/bin${PATH:+:$PATH}"


# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export CLASSPATH="${CLASSPATH:+$CLASSPATH:}$HOME/local/java/lib/*:."


# Go
export GOPRIVATE="${GOPRIVATE:+$GOPRIVATE,}"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($HOME/opt/anaconda3/bin/conda shell.$(basename "$SHELL") hook 2>/dev/null)"
if [ $? -eq 0 ]; then
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

# conda
conda activate python3.10


# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


