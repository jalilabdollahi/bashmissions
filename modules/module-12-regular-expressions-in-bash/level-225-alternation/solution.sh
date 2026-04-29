#!/usr/bin/env bash
set -euo pipefail

cmd=${1:-}
if [[ $cmd =~ ^(start|stop)$ ]]; then
  echo "command=allowed"
else
  echo "command=blocked"
fi
