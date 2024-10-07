#!/usr/bin/env bash

set -e

cd "${0%/*}"

destination="$HOME"
interactive=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] file...

Options:
  -h, --help            Display this help text
  -d, --destination     Set destination directory (default: $HOME)
  -i, --interactive     Prompt before each file write

EOF
}

ignored() {
  local file="$1"
  if [[ ! -f "$destination/.dotfiles_ignore" ]]; then
    return 1
  fi
  if grep -Fqx "$file" "$destination/.dotfiles_ignore"; then
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

install() {
  local file="$1"
  local input
  if [[ -e "$destination/$file" ]]; then
    if [[ ! -f "$destination/$file" ]]; then
      echo "Warning: $destination/$file is not a regular file; skipped"
      return
    fi
    if cmp -s "$file" "$destination/$file"; then
      echo "$file is up to date."
      return
    fi
    if [[ -n "$interactive" ]]; then
      while true; do
        echo -n "$destination/$file already exists; overwrite? [y/N/diff] "
        read -r input
        case "$input" in
        [Yy]) break ;;
        [Nn] | "") return ;;
        [Dd] | [Dd][Ii][Ff][Ff]) diff "$file" "$destination/$file" | ${PAGER:-less} ;;
        *) echo "Please enter a valid option." ;;
        esac
      done
    fi
  else
    if [[ -n "$interactive" ]]; then
      while true; do
        echo -n "Install $file to $destination/$file? [y/N] "
        read -r input
        case "$input" in
        [Yy]) break ;;
        [Nn] | "") return ;;
        *) echo "Please enter a valid option." ;;
        esac
      done
    fi
  fi
  mkdir -p "$(dirname "$destination/$file")"
  cp -v "$file" "$destination/$file"
}

files=()
while [[ "$#" -ge 1 ]]; do
  case "$1" in
  "-h" | "--help")
    usage
    exit 0
    ;;
  "-d" | "--destination")
    shift
    destination="$1"
    shift
    ;;
  "-i" | "--interactive")
    shift
    interactive="$1"
    shift
    ;;
  "--")
    files+=("$@")
    shift "$#"
    ;;
  *)
    files+=("$1")
    shift
    ;;
  esac
done

if [[ ! -e "$destination" ]]; then
  echo "Error: destination directory $destination does not exist." >&2
  exit 1
fi
for file in "${files[@]}"; do
  if [[ ! -e "$file" ]]; then
    echo "Error: file $file does not exist." >&2
    exit 1
  fi
done

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
  install "$file"
done
