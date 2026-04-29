#!/usr/bin/env bash
set -euo pipefail

exec 3> closed.log
echo "before close" >&3
exec 3>&-
if ! echo "after close" >&3 2> /dev/null; then
  echo "fd3=closed"
fi
cat closed.log
