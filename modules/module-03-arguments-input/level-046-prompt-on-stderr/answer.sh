#!/usr/bin/env bash
set -euo pipefail

# -p shows the prompt text before reading. Bash writes it to stderr, and only if
# stdin is a terminal, so it never pollutes stdout or piped input.
# -r keeps backslashes, as in the previous level.
read -rp "Server to restart: " server

echo "restart queued for $server"
