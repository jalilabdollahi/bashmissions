#!/usr/bin/env bash
set -euo pipefail

file=$1 first=$2 last=$3

# head keeps lines 1..LAST; tail -n +FIRST then starts printing at line FIRST.
# "+N" means "from line N", not "the last N lines".
head -n "$last" "$file" | tail -n +"$first"
