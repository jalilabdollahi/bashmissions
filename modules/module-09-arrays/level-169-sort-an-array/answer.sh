#!/usr/bin/env bash
set -euo pipefail

items=(banana apple cherry)
readarray -t sorted < <(printf '%s\n' "${items[@]}" | sort)
printf '%s\n' "${sorted[@]}"
