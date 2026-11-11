#!/usr/bin/env bash
set -euo pipefail

# read takes ONE line from stdin and stores it in the variable.
# -r means "raw": do not treat backslash as an escape character.
read -r title

echo "paging on-call about: $title"
