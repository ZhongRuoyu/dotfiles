#!/bin/bash -e

excluded() {
    local excludes=(
        "install.sh"
        "sync.sh"
        "LICENSE"
    )
    local file
    for file in "${excludes[@]}"; do
        if [ "$1" = "$file" ]; then
            return 0
        fi
    done
    return 1
}

install() {
    local file="$1"
    if excluded "$file"; then
        continue
    fi
    if [ -e "$HOME/$file" ]; then
        if [ ! -f "$HOME/$file" ]; then
            echo "warning: $HOME/$file is not a regular file; skipped"
            return
        fi
        if cmp -s "$file" "$HOME/$file"; then
            echo "$file is up to date."
            return
        fi
        while true; do
            read -p "$HOME/$file already exists; overwrite? [Y/n/diff] " input
            case "$input" in
            "") break ;;
            [Yy]*) break ;;
            diff) diff "$file" "$HOME/$file" | ${PAGER:-less} ;;
            *) return ;;
            esac
        done
    else
        read -p "install $file to $HOME/$file? [Y/n] " input
        case "$input" in
        "") ;;
        [Yy]*) ;;
        *) return ;;
        esac
    fi
    cp "$file" "$HOME"
    echo "$file installed to $HOME/$file"
}

files=($(git ls-tree --full-tree --name-only -r HEAD))

for file in "${files[@]}"; do
    install "$file"
done
