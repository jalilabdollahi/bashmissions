#!/usr/bin/env bash
# Shelf-tag printer: every argument on its own line, exactly as typed, then a
# "count: N" line. echo is not trustworthy for arbitrary data (-n, -e, ...).
set -euo pipefail

for tag in "$@"; do
  echo "$tag"
done
# TODO: print with printf and a FIXED format string instead of echo, for the
# tags and for the final count line as well.
echo "count: $#"
