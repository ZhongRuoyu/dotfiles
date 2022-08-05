#!/bin/bash -e

files=($(git ls-tree --full-tree --name-only -r HEAD | grep -v "^$(basename "$0")\$"))

for file in "${files[@]}"; do
    cp "$HOME/$file" "$file"
    echo "$file"
done
