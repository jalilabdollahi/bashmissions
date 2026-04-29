#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=${DRY_RUN:-1}
run_cmd() {
  if [[ $DRY_RUN == 1 ]]; then
    printf 'DRY: %s\n' "$*"
  else
    "$@"
  fi
}
run_cmd rm output.txt
