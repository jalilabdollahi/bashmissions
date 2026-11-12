#!/usr/bin/env bash
# Backup folder setup for one customer (argument 1).
# It works, but nobody can see what it really did. Make it explain itself.

# TODO: switch tracing on here, before the first command.

dest=backups/$1
mkdir -p "$dest"
echo "ready: $dest"
