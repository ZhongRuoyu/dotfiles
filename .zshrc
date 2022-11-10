# oh-my-zsh settings
export ZSH="$HOME/.oh-my-zsh"
plugins=(
    brew
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
)
source "$ZSH/oh-my-zsh.sh"


# Prompt settings
PS1="[%n@%m %1~]%(!.#.$) "


# History control
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE


# Local zsh settings
if [[ -e "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi


