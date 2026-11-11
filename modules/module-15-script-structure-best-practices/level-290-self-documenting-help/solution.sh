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

# TODO 1: write a function that prints the header block of this very file:
#         the comment lines right after the shebang, up to the first line that
#         is not a comment, with the leading "# " (or lone "#") removed.
#         Hint: awk or sed on "$0".
# TODO 2: --help / -h prints it to stdout (exit 0); no argument prints it to
#         stderr (exit 2).

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
