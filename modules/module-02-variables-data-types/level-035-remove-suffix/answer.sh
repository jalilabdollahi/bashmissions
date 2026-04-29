#!/usr/bin/env bash
set -euo pipefail

filename="$1"
echo "${filename%.*}"
