#!/usr/bin/env bash
while true; do
  printf 'port> ' >&2
  # read fails at end of input; without this check the loop would spin forever.
  if ! read -r port; then
    echo "no valid port given" >&2
    exit 1
  fi

  # First make sure it is only digits, then it is safe to compare as a number.
  if [[ $port =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )); then
    echo "port=$port"
    break
  fi
  echo "bad port: $port" >&2
done
