#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh FILE TEXT [--force]" >&2
  exit 2
fi
file=$1
text=$2
force=${3:-}

# From here on, "> existing-file" is an error instead of a silent wipe.
set -o noclobber

if [[ $force == --force ]]; then
  echo "$text" >| "$file"      # >| = "yes, I really mean it"
# The braces let us silence the shell's own complaint: it is printed while
# the redirection is being set up, before a 2>/dev/null on echo would apply.
elif ! { echo "$text" > "$file"; } 2>/dev/null; then
  echo "refusing to overwrite $file" >&2
  exit 1
fi

echo "wrote $file"
