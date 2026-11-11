#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
  echo "usage: solution.sh CONFIG NEWLEVEL" >&2
  exit 2
fi
config=$1
newlevel=$2

# One reader for both the first load and every reload. It prints the level when
# it is valid and fails otherwise, so callers can use it in an if.
read_level() {
  local key value found=
  while IFS='=' read -r key value || [[ -n $key ]]; do
    key=${key#"${key%%[![:space:]]*}"};       key=${key%"${key##*[![:space:]]}"}
    value=${value:-}
    value=${value#"${value%%[![:space:]]*}"}; value=${value%"${value##*[![:space:]]}"}
    if [[ $key == level ]]; then
      found=$value                      # the last line wins
    fi
  done < "$config"
  case $found in
    debug|info|warn|error) printf '%s' "$found" ;;
    *) return 1 ;;
  esac
}

if ! level=$(read_level); then
  echo "no valid level in $config" >&2
  exit 1
fi
echo "loaded: level=$level"

reload() {
  local fresh
  # Only assign to the live variable after the new value passed validation.
  if fresh=$(read_level); then
    level=$fresh
    echo "reloaded: level=$level"
  else
    echo "reload rejected: keeping level=$level" >&2
  fi
}
trap reload HUP

# The administrator edits the file...
printf 'level=%s\n' "$newlevel" >> "$config"
# ...and tells the process. Bash runs the trap as soon as this command returns.
kill -HUP $$

echo "done: level=$level"
