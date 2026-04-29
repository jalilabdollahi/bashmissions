#!/usr/bin/env bash
set -euo pipefail

grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' fixtures/data.txt | awk -F'"' '{print "name=" $4}'
