source $HOME/.profile
source $HOME/.bashrc


# Homebrew completions
if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
        source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "$HOMEBREW_PREFIX/etc/bash_completion.d/"*; do
            [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
    fi
fi


# Local bash profile
if [[ -e "$HOME/.bash_profile.local" ]]; then
    source "$HOME/.bash_profile.local"
fi


