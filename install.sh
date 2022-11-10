#!/bin/bash -e

ignored() {
    local file="$1"
    if [[ ! -f "$HOME/.dotfiles_ignore" ]]; then
        return 1
    fi
    if grep -Fqx "$file" "$HOME/.dotfiles_ignore"; then
        return 0
    fi
    return 1
}

excluded() {
    local excludes=(
        "install.sh"
        "sync.sh"
        "LICENSE"
    )
    local file="$1"
    local exclude
    for exclude in "${excludes[@]}"; do
        if [[ "$file" = "$exclude" ]]; then
            return 0
        fi
    done
    return 1
}

install() {
    local file="$1"
    if excluded "$file"; then
        return
    fi
    if ignored "$file"; then
        echo "$file is ignored."
        return
    fi
    local input
    if [[ -e "$HOME/$file" ]]; then
        if [[ ! -f "$HOME/$file" ]]; then
            echo "Warning: $HOME/$file is not a regular file; skipped"
            return
        fi
        if cmp -s "$file" "$HOME/$file"; then
            echo "$file is up to date."
            return
        fi
        while true; do
            read -p "$HOME/$file already exists; overwrite? [y/N/diff] " input
            case "$input" in
            [Yy]*) break ;;
            [Dd]*) diff "$file" "$HOME/$file" | ${PAGER:-less} ;;
            *) return ;;
            esac
        done
    else
        read -p "Install $file to $HOME/$file? [y/N] " input
        case "$input" in
        [Yy]*) ;;
        *) return ;;
        esac
    fi
    mkdir -p "$(dirname "$HOME/$file")"
    cp -v "$file" "$HOME/$file"
}

files=($(git ls-tree --full-tree --name-only -r HEAD))

for file in "${files[@]}"; do
    install "$file"
done
