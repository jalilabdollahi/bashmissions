#!/usr/bin/env bash
# set -x makes Bash print every command to stderr, after expansion, just
# before running it. Stdout stays clean, so reports are not polluted.
set -x

dest=backups/$1
mkdir -p "$dest"
echo "ready: $dest"
