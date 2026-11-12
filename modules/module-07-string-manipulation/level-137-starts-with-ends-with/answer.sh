#!/usr/bin/env bash
set -euo pipefail

for name in "$@"; do
  # Inside [[ ]], the right side of == is a pattern (when unquoted).
  # A star AFTER literal text means "starts with"; a star BEFORE it means "ends with".
  if [[ $name == .* ]]; then
    label=hidden
  elif [[ $name == *.pem ]]; then
    label=quarantine
  elif [[ $name == backup-* ]]; then
    label=archive
  else
    label=accept
  fi
  echo "$name: $label"
done
