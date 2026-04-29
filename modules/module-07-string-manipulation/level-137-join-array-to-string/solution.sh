#!/usr/bin/env bash
set -euo pipefail

items=("$@")
joined=$(IFS=,; echo "${items[*]}")
echo "$joined"
