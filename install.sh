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

files=($(git ls-tree --full-tree --name-only -r HEAD))

for file in "${files[@]}"; do
    if excluded "$file"; then
        continue
    fi
    if [ -e "$HOME/$file" ]; then
        if [ ! -f "$HOME/$file" ]; then
            echo "warning: $HOME/$file is not a regular file; skipped"
            continue
        fi
        read -p "$HOME/$file already exists; overwrite? [Y/n] " input
        case "$input" in
            "") ;;
            [Yy]*) ;;
            *) continue;;
        esac
    fi
    cp "$file" "$HOME"
    echo "$file"
done
