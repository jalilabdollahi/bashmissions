#!/usr/bin/env bash
# tidy-tmp.sh - remove stale .tmp files from one directory
#
# Usage: tidy-tmp.sh [--help] DIR
#
# Deletes every *.tmp file directly inside DIR (not in subfolders) and
# prints how many were removed.
#
# Exit status: 0 success, 1 DIR is not a directory, 2 bad usage.

set -euo pipefail

# Print this script's own header block: skip the shebang (line 1), then print
# comment lines with the leading "# " (or bare "#") stripped, and stop at the
# first line that is not a comment. $0 is the path this script was started as.
show_help() {
  awk 'NR == 1 { next }
       /^#/    { sub(/^# ?/, ""); print; next }
               { exit }' "$0"
}

case "${1:-}" in
  -h|--help)
    show_help
    exit 0
    ;;
  "")
    show_help >&2
    exit 2
    ;;
esac

dir=$1
if [ ! -d "$dir" ]; then
  echo "tidy-tmp.sh: no such directory: $dir" >&2
  exit 1
fi

removed=0
for f in "$dir"/*.tmp; do
  if [ -f "$f" ]; then
    rm -- "$f"
    removed=$((removed + 1))
  fi
done
echo "removed $removed"
