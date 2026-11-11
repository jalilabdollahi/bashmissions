#!/usr/bin/env bash
# Theo's site census. Expected output for "dory eel":
#   1. dory ####
#   2. eel ###
#   total: 2
# BUG HUNT: the numbers are all "1". One variable is used by both the main loop
# and a function. Fix it inside the function; leave the main loop alone.

# make_bar WORD: leaves a row of # (one per character of WORD) in $bar
make_bar() {
  count=${#1}
  bar=""
  while (( count > 0 )); do
    bar+="#"
    count=$(( count - 1 ))
  done
}

count=0
for site in "$@"; do
  count=$(( count + 1 ))
  make_bar "$site"
  echo "$count. $site $bar"
done
echo "total: $count"
