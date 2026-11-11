#!/usr/bin/env bash
set -euo pipefail

environment=$1
# shift throws $1 away and renumbers: old $2 becomes $1, and $# goes down by one.
shift

echo "environment: $environment"
# After the shift, $# and $* describe only the servers.
echo "targets=$# [$*]"
