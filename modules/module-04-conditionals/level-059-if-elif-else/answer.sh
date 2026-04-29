#!/usr/bin/env bash
set -euo pipefail

if [ "$1" = "start" ]; then
  echo "starting"
elif [ "$1" = "stop" ]; then
  echo "stopping"
else
  echo "unknown"
fi
