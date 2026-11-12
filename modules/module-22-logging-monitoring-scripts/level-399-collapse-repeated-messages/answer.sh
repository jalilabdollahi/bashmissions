#!/usr/bin/env bash
# Collapse consecutive repeated log messages, syslog style.
set -euo pipefail

prev=""        # message of the previous line
have_prev=0    # becomes 1 after the first line (an empty message is still a message)
repeats=0      # extra copies seen since the run started

# Print the pending "repeated" note, if any, and reset the counter.
flush() {
  if (( repeats == 1 )); then
    echo "last message repeated 1 time"
  elif (( repeats > 1 )); then
    echo "last message repeated $repeats times"
  fi
  repeats=0
}

while IFS= read -r line; do
  msg=${line#* }                      # drop the timestamp (everything up to the first space)
  [[ $line == *" "* ]] || msg=""      # a line with no space has no message at all
  if (( have_prev )) && [[ -n $msg && $msg == "$prev" ]]; then
    repeats=$((repeats + 1))
    continue
  fi
  flush                               # the run (if any) ended: report it first
  printf '%s\n' "$line"
  prev=$msg
  have_prev=1
done

flush                                 # input ended while a run was still open
