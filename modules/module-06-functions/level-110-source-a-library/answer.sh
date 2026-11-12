#!/usr/bin/env bash
set -euo pipefail

# "source" runs the file in THIS shell, so the variable and the function it
# defines are available below. Running "bash fixtures/storage.sh" instead
# would define them in a child shell that vanishes immediately.
source fixtures/storage.sh

echo "storage lib v$STORAGE_LIB_VERSION"

for kb in "$@"; do
  echo "$kb KB = $(kb_to_mb "$kb") MB"
done
