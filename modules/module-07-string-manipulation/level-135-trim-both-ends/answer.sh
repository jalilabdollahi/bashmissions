#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

str="$1"
str="${str##+([[:space:]])}"
str="${str%%+([[:space:]])}"
echo "$str"
