#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi

# Without -i, sed only prints the changed text and leaves the file alone.
#  s/old/new/g   g = every occurrence on the line, not just the first
#  \.            the dot in the pattern is a regex wildcard, so escape it
#  s|a|b|g       with | as the delimiter, the slashes in the path need no escaping
sed -e 's/lanternfish\.internal/example.test/g' \
    -e 's|/srv/lanternfish|/srv/app|g' "$1"
