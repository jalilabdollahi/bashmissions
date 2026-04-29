#!/usr/bin/env bash
set -euo pipefail

declare -A capitals=([france]=paris [japan]=tokyo)
echo "france=${capitals[france]}"
echo "japan=${capitals[japan]}"
