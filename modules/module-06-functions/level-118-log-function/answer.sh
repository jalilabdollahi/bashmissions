#!/usr/bin/env bash
set -euo pipefail

log() {
  local message="$1"
  printf '[%s] %s\n' "$(date +%Y-%m-%d)" "$message"
}

log "deploy"
