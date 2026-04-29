#!/usr/bin/env bash
set -euo pipefail

if [[ -n ${BASH_VERSION:-} ]]; then
  values=(alpha beta)
  printf 'bash=yes\n'
  printf 'array_second=%s\n' "${values[1]}"
fi
