#!/usr/bin/env bash
set -euo pipefail

mission='The Template Engine'
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
log="$tmp/mission.log"
declare -a steps=(prepare validate execute verify report)
run_step() { local step=$1; printf '%s:%s
' "$mission" "$step" >> "$log"; }
for step in "${steps[@]}"; do run_step "$step"; done
printf 'mission=%s
' "$mission"
printf 'steps=%s
' "$(wc -l < "$log")"
printf 'status=complete
'
