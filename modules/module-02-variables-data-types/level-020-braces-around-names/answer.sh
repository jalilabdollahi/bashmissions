#!/usr/bin/env bash
# Naming helper for the backup job.

# Letters, digits and underscores can all belong to a variable name, so
# "$NODE_backup" would mean a variable called NODE_backup. The braces tell
# Bash exactly where the name stops.
echo "archive: ${NODE}_backup.tar.gz"
echo "replica: ${NODE}2"
echo "host: ${NODE}.lanternfish.example"
