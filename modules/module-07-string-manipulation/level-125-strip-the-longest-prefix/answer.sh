#!/usr/bin/env bash
set -euo pipefail

for path in "$@"; do
  # '##' removes the LONGEST prefix matching "*/": that is, everything up to
  # and including the last slash. A path with no slash is left as it is.
  file=${path##*/}
  echo "$path -> $file"
done
