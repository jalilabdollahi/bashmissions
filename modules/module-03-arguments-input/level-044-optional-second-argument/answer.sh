#!/usr/bin/env bash
set -euo pipefail

host=$1
# ${2:-22} means: use $2, but if it is unset OR empty, use 22.
# It is also safe under set -u: the default stops the "unbound variable" error.
port=${2:-22}

echo "connect $host on port $port"
