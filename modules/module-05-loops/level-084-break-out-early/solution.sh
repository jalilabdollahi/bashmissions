#!/usr/bin/env bash
# Patch anchovy barracuda cuttlefish dory eel flounder in order.
# A server is down if the file down/<server> exists. At the first down server,
# print the STOP line and stop the whole rollout.
# TODO: loop over the servers; check the file; patch or stop.
for server in anchovy barracuda cuttlefish dory eel flounder; do
  echo "patched $server"
done
