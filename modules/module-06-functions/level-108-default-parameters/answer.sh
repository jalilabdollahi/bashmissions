#!/usr/bin/env bash
set -u

# ${1:-30} reads $1, but uses 30 when $1 is missing or empty.
# That keeps "set -u" happy: a bare $1 with no argument would be an error.
retention_line() {
  local days=${1:-30}
  local tier=${2:-standard}
  echo "keep backups for $days days ($tier tier)"
}

retention_line "$@"
