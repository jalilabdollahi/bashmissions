#!/usr/bin/env bash
set -euo pipefail

list=$1
old=$2
new=$3

# One slash = replace only the first match.
# Quoting "$old" turns the search text literal, so [ and * are not wildcards.
echo "${list/"$old"/$new}"
