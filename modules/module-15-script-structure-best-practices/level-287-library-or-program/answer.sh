#!/usr/bin/env bash
# slugify: turn "Harbour Bakery" into "harbour-bakery".
# As a program: solution.sh TEXT... prints the slug of every argument.
# As a library: `source solution.sh` only defines slugify.

# No "set -e" at the top: when this file is sourced, it would switch the
# options of the *caller's* shell. Strict mode lives inside the program branch.

slugify() {
  local s=${1,,}
  s=$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
  printf '%s\n' "$s"
}

main() {
  if [ "$#" -eq 0 ]; then
    echo "usage: solution.sh TEXT..." >&2
    exit 2
  fi
  local arg
  for arg in "$@"; do
    slugify "$arg"
  done
}

# When run as a command, bash sets $0 to this file's path, which is also
# BASH_SOURCE[0]. When sourced, $0 is still the *caller's* name.
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  set -euo pipefail
  main "$@"
fi
