#!/usr/bin/env bash

set -e

cd "${0%/*}"

source="$HOME"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [<file>...]

Options:
  -h, --help            Display this help text
  -s <dir>, --source <dir>
                        Set source directory (default: $HOME)

EOF
}

ignored() {
  local file="$1"
  if [[ ! -f "$source/.dotfiles_ignore" ]]; then
    return 1
  fi
  if grep -Fqx "$file" "$source/.dotfiles_ignore"; then
    return 0
  fi
  return 1
}

excluded() {
  local excludes=(
    "install.sh"
    "sync.sh"
    "LICENSE"
    "README.md"
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

files_equal() {
  local a="$1" b="$2"
  if [[ -L "$a" ]] && [[ -L "$b" ]]; then
    [[ "$(readlink -- "$a")" = "$(readlink -- "$b")" ]]
  else
    cmp -s -- "$a" "$b"
  fi
}

sync() {
  local file="$1"
  if [[ -L "$source/$file" ]] && [[ ! -L "$file" ]]; then
    echo "Warning: $file is not a symlink; skipped"
    return
  elif [[ -f "$source/$file" ]] && [[ ! -f "$file" ]]; then
    echo "Warning: $source/$file is not a regular file; skipped"
    return
  fi
  if files_equal "$file" "$source/$file"; then
    echo "$file is up to date."
    return
  fi
  cp -Pv -- "$source/$file" "$file"
}

files=()
while [[ "$#" -ge 1 ]]; do
  case "$1" in
  "-h" | "--help")
    usage
    exit 0
    ;;
  "-s" | "--source")
    if [[ "$#" -lt 2 ]]; then
      echo "Error: option $1 requires an argument." >&2
      usage
      exit 1
    fi
    shift
    source="$1"
    shift
    ;;
  "--")
    shift
    files+=("$@")
    shift "$#"
    ;;
  *)
    files+=("$1")
    shift
    ;;
  esac
done

if [[ ! -e "$source" ]]; then
  echo "Error: source directory $source does not exist." >&2
  exit 1
fi

if [[ "${#files[@]}" -eq 0 ]]; then
  while IFS="" read -r file; do
    if excluded "$file"; then
      continue
    fi
    if ignored "$file"; then
      echo "Note: $file is ignored."
      continue
    fi
    files+=("$file")
  done < <(git ls-tree --full-tree --name-only -r HEAD)
fi

for file in "${files[@]}"; do
  sync "$file"
done
