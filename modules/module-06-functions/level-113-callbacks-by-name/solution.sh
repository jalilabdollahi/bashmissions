#!/usr/bin/env bash
# ./solution.sh MODE ITEM...   MODE is "upper" or "length".
# The two workers below are finished. Write apply_each and the dispatch.

upper_line() {
  echo "${1^^}"
}

length_line() {
  echo "$1: ${#1}"
}

# TODO: apply_each CALLBACK ITEM... - call the function named CALLBACK on every item.
# TODO: pick the callback from MODE (case works well), or complain with exit 2.
