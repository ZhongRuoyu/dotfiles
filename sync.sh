#!/bin/bash -e

files=($(git ls-tree --full-tree --name-only -r HEAD))

for file in "${files[@]}"; do
    cp $HOME/$file $file
    echo $file
done
