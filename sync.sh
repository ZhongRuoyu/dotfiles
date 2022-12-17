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

sync() {
  local file="$1"
  if excluded "$file"; then
    return
  fi
  if ignored "$file"; then
    echo "$file is ignored."
    return
  fi
  if [[ ! -e "$HOME/$file" ]]; then
    echo "Warning: $HOME/$file does not exist; skipped"
    return
  fi
  if [[ ! -f "$HOME/$file" ]]; then
    echo "Warning: $HOME/$file is not a regular file; skipped"
    return
  fi
  if cmp -s "$file" "$HOME/$file"; then
    echo "$file is up to date."
    return
  fi
  cp -v "$HOME/$file" "$file"
}

files=()
while IFS='' read -r line; do
  files+=("$line")
done < <(git ls-tree --full-tree --name-only -r HEAD)

for file in "${files[@]}"; do
  sync "$file"
done
