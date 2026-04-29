#!/usr/bin/env bash
set -euo pipefail

value="server-42"
if [[ $value =~ [0-9]+ ]]; then
  echo "match=yes"
else
  echo "match=no"
fi
