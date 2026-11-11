#!/usr/bin/env bash
set -euo pipefail

file=$1

# '%' removes the SHORTEST suffix matching ".*" - the last dot and what follows.
# Names without a dot do not match, so they come back untouched.
echo "${file%.*}"
