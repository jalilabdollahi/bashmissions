#!/usr/bin/env bash
for server in anchovy barracuda cuttlefish dory eel flounder; do
  if [[ -e down/$server ]]; then
    echo "STOP: $server is down"
    # Leave the loop entirely. Servers after this one are never visited.
    break
  fi
  echo "patched $server"
done
