#!/bin/bash -e

excluded() {
    local excludes=(
        "install.sh"
        "sync.sh"
        "LICENSE"
    )
    local file="$1"
    shift
    for exclude in "${excludes[@]}"; do
        if [ "$file" = "$exclude" ]; then
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
    if [ ! -e "$HOME/$file" ]; then
        echo "Warning: $HOME/$file does not exist; skipped"
        continue
    fi
    if [ ! -f "$HOME/$file" ]; then
        echo "Warning: $HOME/$file is not a regular file; skipped"
        continue
    fi
    cp -v "$HOME/$file" "$file"
done
