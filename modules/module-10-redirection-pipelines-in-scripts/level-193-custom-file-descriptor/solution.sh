#!/usr/bin/env bash
set -euo pipefail

exec 3> fd.log
echo "alpha" >&3
echo "beta" >&3
exec 3>&-
cat fd.log
