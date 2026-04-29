#!/usr/bin/env bash
set -euo pipefail

DEBUG=1
debug() {
  if [[ $DEBUG == 1 ]]; then
    printf 'DEBUG: %s\n' "$*"
  fi
}
debug "loading config"
echo "run=ok"
