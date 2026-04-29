#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

str="$1"
echo "${str%%+([[:space:]])}"
