#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CONF" >&2
  exit 2
fi
conf=$1

greeting=
reloaded=0

# sed removes only the first "greeting=" prefix, so later "=" signs survive.
load_config() {
  greeting=$(sed -n 's/^greeting=//p' "$conf" | head -n 1)
}

on_hup() {
  load_config
  reloaded=1
  echo "reloaded greeting=$greeting"
}

load_config
echo "loaded greeting=$greeting"

# The trap comes first: if HUP arrived with the default action in place, the
# script would simply be terminated.
trap on_hup HUP

confpush "$$" "$conf" &

for ((poll = 1; poll <= 20; poll++)); do
  sleep 0.1
  if [[ $reloaded -eq 1 ]]; then
    break
  fi
done

if [[ $reloaded -eq 1 ]]; then
  echo "reload handled"
else
  echo "no reload received" >&2
  exit 1
fi
