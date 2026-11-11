#!/usr/bin/env bash
# Verifies the human-facing part of the level: header block and kept debug lines.
if ! head -n 8 solution.sh | grep -Eq '^# Purpose: .+'; then
  echo "Add a header line like '# Purpose: ...' within the first lines of the script."
  exit 1
fi
if ! head -n 8 solution.sh | grep -Eq '^# Author: .+'; then
  echo "Add a header line like '# Author: your name' within the first lines of the script."
  exit 1
fi
kept=$(grep -Ec '^[[:space:]]*#[[:space:]]*echo[[:space:]]+"DEBUG' solution.sh)
if [ "$kept" -lt 2 ]; then
  echo "Keep both DEBUG lines in the file, but turn them into comments with a leading #."
  exit 1
fi
exit 0
