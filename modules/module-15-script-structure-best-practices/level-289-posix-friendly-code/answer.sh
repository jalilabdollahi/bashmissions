#!/bin/sh
# File classifier for the recovery stick: solution.sh PATH...
# Plain POSIX sh: runs under dash, busybox ash, bash --posix and bash.
set -eu

if [ "$#" -eq 0 ]; then
  echo "usage: solution.sh PATH..." >&2
  exit 2
fi

count=0
for path in "$@"; do
  # POSIX has no ${var,,}; tr does the case folding portably.
  lower=$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')
  if [ ! -e "$path" ]; then
    kind=missing
  elif [ -d "$path" ]; then
    kind=directory
  else
    # case with glob patterns replaces a chain of [[ ... == *.x ]] tests.
    case "$lower" in
      *.png|*.jpg|*.jpeg|*.gif) kind=image ;;
      *.tar.gz|*.tgz|*.zip)     kind=archive ;;
      *.log)                    kind=log ;;
      *)                        kind=other ;;
    esac
  fi
  printf '%s: %s\n' "$path" "$kind"
  count=$((count + 1))      # POSIX arithmetic expansion; not the bash-only double-paren command
done
printf 'items: %d\n' "$count"
