#!/usr/bin/env bash
# Lanternfish label printer: wraps every argument it receives in angle brackets,
# one per line, so you can see exactly where one argument ends and the next begins.
for item in "$@"; do
  printf '<%s>\n' "$item"
done
