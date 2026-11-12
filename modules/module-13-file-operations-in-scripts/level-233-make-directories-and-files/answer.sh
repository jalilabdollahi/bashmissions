#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER" >&2
  exit 2
fi
site="sites/$1"

# -p: make "sites" too if needed, and do not complain when a folder exists.
mkdir -p "$site/public" "$site/logs" "$site/backup"

# touch creates a missing file but leaves an existing one's content alone.
touch "$site/logs/access.log" "$site/logs/error.log" "$site/public/index.html"

echo "ready: $site"
