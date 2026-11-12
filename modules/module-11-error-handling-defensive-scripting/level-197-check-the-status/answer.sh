#!/usr/bin/env bash
# No "set -e" here on purpose: grep exits 1 when it finds nothing, and that is a
# normal answer we want to inspect, not a reason to abort the script.

file=$1

grep -qx 'maintenance=on' "$file" 2>/dev/null
status=$?          # grab it NOW: the next command would overwrite $?

case $status in
  0) echo "maintenance: ON" ;;
  1) echo "maintenance: off" ;;
  *)
    echo "cannot read $file (grep status $status)" >&2
    exit 2
    ;;
esac
