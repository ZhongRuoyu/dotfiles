source $HOME/.profile
source $HOME/.zshrc


# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions${FPATH:+:$FPATH}"
    autoload -Uz compinit
    compinit
fi


# Local zsh profile
if [[ -e "$HOME/.zprofile.local" ]]; then
    source "$HOME/.zprofile.local"
fi


