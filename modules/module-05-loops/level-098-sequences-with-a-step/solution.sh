#!/usr/bin/env bash
# Stagger backups: host-n starts (n-1)*STEP minutes after 02:00.
# Arguments: COUNT STEP. Print "host-<n> starts at HH:MM" per server.
# TODO: use seq to walk the offsets 0, STEP, 2*STEP, ... up to (COUNT-1)*STEP.
echo "host-1 starts at 02:00"
