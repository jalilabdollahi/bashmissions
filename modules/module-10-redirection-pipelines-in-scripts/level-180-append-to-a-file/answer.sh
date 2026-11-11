#!/usr/bin/env bash
set -euo pipefail

# One ">>" per write: the file is opened in append mode, so every line lands
# after whatever is already there, and a missing file is simply created.
for event in "$@"; do
  printf '[audit] %s\n' "$event" >> audit.log
done
