#!/usr/bin/env bash
# The scratch file must be gone after the run. The planted traps are symlinks
# (type l), so any regular file left in tmp/ belongs to the player's script.
left=$(find tmp -type f | head -n 1)
if [[ -n $left ]]; then
  echo "A scratch file was left behind: $left. Remove it with a trap on EXIT."
  exit 1
fi
exit 0
