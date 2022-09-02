# oh-my-zsh settings
export ZSH="$HOME/.oh-my-zsh"
plugins=(
    brew
    docker
    docker-compose
    gh
    git
    golang
    httpie
    macos
    npm
    nvm
    pip
    rust
)
source $ZSH/oh-my-zsh.sh >/dev/null 2>/dev/null


# Prompt settings
# PS1="[%n@%m %1~]%(!.#.$) "
user="ruoyu"  # "%n"
host="Ruoyus-MacBook-Pro"  # "%m"
PS1="[$user@$host %1~]%(!.#.$) "
unset user
unset host


# History control
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE


