#!/usr/bin/env bash
set -euo pipefail

# paste reads its files in parallel: line 1 of each, then line 2 of each...
# The default delimiter is a tab; -d, switches it to a comma.
# When one file runs out, paste keeps going with empty values.
paste -d, "$1" "$2" "$3"
