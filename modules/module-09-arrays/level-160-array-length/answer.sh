#!/usr/bin/env bash
set -euo pipefail

servers=(api web worker cache)
echo "count=${#servers[@]}"
