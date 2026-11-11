#!/usr/bin/env bash
set -euo pipefail

# ${1:-} gives an empty string instead of an "unbound variable" error
# when the script is started without arguments.
target="${1:-}"

# [[ ... ]] is the test; the if runs its body only when the test is true.
if [[ $target == prod ]]; then
  echo "CAUTION: production - the two-person rule applies"
fi
