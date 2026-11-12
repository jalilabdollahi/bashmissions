#!/usr/bin/env bash
set -euo pipefail
fleet=("$@")

# ${#fleet[@]} = how many elements. ${#fleet[0]} = how long element 0 is.
# For an empty array element 0 does not exist, and its length is simply 0.
echo "servers: ${#fleet[@]}"
echo "first tag width: ${#fleet[0]}"
