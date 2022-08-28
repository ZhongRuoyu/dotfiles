source $HOME/.profile
source $HOME/.zshrc

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions${FPATH:+:$FPATH}"
    autoload -Uz compinit
    compinit
fi

