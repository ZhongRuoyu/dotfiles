#!/usr/bin/env bash

set -e

cd "${0%/*}"

destination="$HOME"
interactive=""
force=""

if [[ -t 1 ]] && [[ "$TERM" != "dumb" ]]; then
  diff=(diff -Nu --color=always --)
else
  diff=(diff -Nu --)
fi

pager="${PAGER:-}"
if [[ -z "$pager" ]]; then
  for pager_cmd in less more; do
    if command -v "$pager_cmd" > /dev/null 2>&1; then
      pager="$pager_cmd"
      break
    fi
  done
fi

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [<file>...]

Options:
  -h, --help            Display this help text
  -d <dir>, --destination <dir>
                        Set destination directory (default: $HOME)
  -i, --interactive     Prompt before installing or deleting files (default)
  -f, --force           Do not prompt before installing or deleting files

EOF
}

ignored() {
  local file="$1"
  if [[ ! -f "$destination/.dotfiles_ignore" ]]; then
    return 1
  fi
  if grep -Fqx -e "$file" -- "$destination/.dotfiles_ignore"; then
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

show_diff() {
  if [[ -n "$pager" ]]; then
    "${diff[@]}" "$destination/$1" "$1" | $pager
  else
    "${diff[@]}" "$destination/$1" "$1"
  fi
}

files_equal() {
  local a="$1" b="$2"
  if [[ -L "$a" ]] && [[ -L "$b" ]]; then
    [[ "$(readlink -- "$a")" = "$(readlink -- "$b")" ]]
  else
    cmp -s -- "$a" "$b"
  fi
}

install() {
  local file="$1"
  local input
  if [[ -e "$destination/$file" ]] || [[ -L "$destination/$file" ]]; then
    if [[ -L "$file" ]] && [[ ! -L "$destination/$file" ]]; then
      echo "Warning: $destination/$file is not a symlink; skipped"
      return
    elif [[ -f "$file" ]] && [[ ! -f "$destination/$file" ]]; then
      echo "Warning: $destination/$file is not a regular file; skipped"
      return
    fi
    if files_equal "$file" "$destination/$file"; then
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
        [Dd] | [Dd][Ii][Ff][Ff]) show_diff "$file" ;;
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
  mkdir -p -- "$(dirname "$destination/$file")"
  cp -P -- "$file" "$destination/$file"
  echo "Installed $file to $destination/$file"
}

uninstall() {
  local file="$1"
  local input
  if [[ ! -e "$destination/$file" ]]; then
    return
  fi
  if [[ ! -f "$destination/$file" ]]; then
    echo "Warning: $destination/$file is not a regular file; skipped"
    return
  fi
  if [[ -n "$interactive" ]]; then
    while true; do
      echo -n "Remove $destination/$file? [y/N] "
      read -r input
      case "$input" in
      [Yy]) break ;;
      [Nn] | "") return ;;
      *) echo "Please enter a valid option." ;;
      esac
    done
  fi
  rm -- "$destination/$file"
  echo "Removed $destination/$file"
}

files=()
while [[ "$#" -ge 1 ]]; do
  case "$1" in
  "-h" | "--help")
    usage
    exit 0
    ;;
  "-d" | "--destination")
    if [[ "$#" -lt 2 ]]; then
      echo "Error: option $1 requires an argument." >&2
      usage
      exit 1
    fi
    shift
    destination="$1"
    shift
    ;;
  "-i" | "--interactive")
    interactive="1"
    shift
    ;;
  "-f" | "--force")
    force="1"
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

if [[ -n "$force" ]] && [[ -n "$interactive" ]]; then
  echo "Error: options --force and --interactive cannot be used together." >&2
  exit 1
elif [[ -z "$force" ]] && [[ -z "$interactive" ]] && [[ -t 0 ]]; then
  interactive="1"
fi

if [[ ! -e "$destination" ]]; then
  echo "Error: destination $destination does not exist." >&2
  exit 1
fi
if [[ ! -d "$destination" ]]; then
  echo "Error: destination $destination is not a directory." >&2
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

uninstall_files=(
  .condarc
  .config/conda/condarc
  .gdbinit
  .gitignore_global
  .homebrew/brew.env
  .homebrew/Brewfile
  .homebrew/Brewfile.personal
  .pylintrc
  .rubocop.yml
  .ruff.toml
  .rustfmt.toml
  .style.yapf
)
for file in "${uninstall_files[@]}"; do
  uninstall "$file"
done
