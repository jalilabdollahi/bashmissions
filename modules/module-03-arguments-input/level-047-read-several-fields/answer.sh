#!/usr/bin/env bash
set -euo pipefail

# With several names, read cuts the line on whitespace: word 1 -> host,
# word 2 -> address, and ALL the remaining words go into the last variable.
read -r host address role

echo "role=$role host=$host address=$address"
