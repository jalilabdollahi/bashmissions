#!/usr/bin/env bash
# slugify: turn "Harbour Bakery" into "harbour-bakery".
# As a program: solution.sh TEXT... prints the slug of every argument.
# As a library: `source solution.sh` should only define slugify.
set -euo pipefail

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

# TODO: this runs main even when the file is only being sourced, and the
# set -euo pipefail above changes the sourcing shell. Run main only when
# ${BASH_SOURCE[0]} equals $0, and move strict mode into that branch.
main "$@"
