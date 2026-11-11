#!/usr/bin/env bash
# No "set -e" on purpose: (( x++ )) and (( x-- )) return exit status 1
# whenever the expression evaluates to 0 (for example 0++ gives 0 before
# the increment). With -e that harmless status would kill the script.
set -uo pipefail

total=0
active=0

while read -r event user; do
  case "$event" in
    connect)
      (( total++ ))
      (( active++ ))
      ;;
    disconnect)
      (( active-- ))
      ;;
  esac
done

echo "total_connects=$total"
echo "still_connected=$active"
