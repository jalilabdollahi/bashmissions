#!/usr/bin/env bash
set -euo pipefail

exec 4>&1
exec > >(tee full.log)
echo "build started"
echo "build finished"
exec >&4
exec 4>&-
wait
echo "log:$(paste -sd, full.log)"
