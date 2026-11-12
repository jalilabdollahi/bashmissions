#!/usr/bin/env bash
# Log viewer settings: ${name:-default} gives the default when the variable
# is unset OR empty, and the variable itself is left untouched.

echo "level=${LOG_LEVEL:-info}"
echo "dir=${LOG_DIR:-/var/log/lanternfish}"
echo "lines=${MAX_LINES:-200}"
