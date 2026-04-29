#!/usr/bin/env bash
set -euo pipefail

items=(beta alpha beta gamma alpha)
mapfile -t unique < <(printf '%s\n' "${items[@]}" | sort | uniq)
printf '%s\n' "${unique[@]}"
