#!/usr/bin/env bash
# Endpoint list cleaner: one loop that does everything. Split it into four
# single-purpose functions without changing what it prints.
set -euo pipefail

while IFS= read -r line; do
  [ -z "$line" ] && continue
  if [[ $line != *:* ]]; then
    echo "invalid: $line"
    continue
  fi
  host=${line%%:*}
  port=${line#*:}
  host=${host,,}
  host=${host%.}
  if [ -z "$host" ] || ! [[ $port =~ ^[0-9]{1,5}$ ]] || (( 10#$port < 1 || 10#$port > 65535 )); then
    echo "invalid: $line"
    continue
  fi
  echo "endpoint=$host:$((10#$port))"
done

# TODO: extract normalise_host, is_port and format_endpoint, put the loop in
# main, and finish the file with: main "$@"
# Reminder: functions that answer yes/no should return a status, not print.
