#!/usr/bin/env bash
set -euo pipefail

message=$1
shift

make_logger() {
  local level=$1
  # eval pastes text into the shell's own input, so the name must be
  # harmless *before* it gets near eval: lowercase letters only.
  if [[ ! $level =~ ^[a-z]+$ ]]; then
    echo "make_logger: bad level name '$level'" >&2
    exit 2
  fi
  # Double quotes: $level and ${level^^} are filled in NOW (they are baked in).
  # The escaped \$* is left for the generated function to expand when called.
  eval "log_$level() { printf '[%s] %s\\n' '${level^^}' \"\$*\"; }"
}

for level in "$@"; do
  make_logger "$level"
done

# Safe: every name here already passed the check above.
for level in "$@"; do
  "log_$level" "$message"
done
