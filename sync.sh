#!/bin/bash -e

excluded() {
    local excludes=(
        "$(basename "$0")"
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
    cp "$HOME/$file" "$file"
    echo "$file"
done
