#!/usr/bin/env bash
set -euo pipefail

line=$1

# IFS=: applies only to this one read. -r keeps backslashes, -a stores the
# pieces in an indexed array. <<< feeds the string to read's standard input.
IFS=: read -ra fields <<< "$line"

# Arrays count from 0, so field 1 is index 0, field 3 is index 2, and so on.
echo "user=${fields[0]}"
echo "uid=${fields[2]}"
echo "home=${fields[5]}"
echo "shell=${fields[6]}"
