#!/usr/bin/env bash
# Morning summary of two pools. Arguments: web servers, then "--", then
# database servers. The parsing below is done; the summarize function is not.
web=()
db=()
past_separator=0
for arg in "$@"; do
  if [[ $arg == -- ]]; then
    past_separator=1
  elif (( past_separator )); then
    db+=("$arg")
  else
    web+=("$arg")
  fi
done

# summarize NAME  ->  "<name>: <count> hosts (first=..., last=...)"
# TODO: NAME is the name of an array. Bind a name reference to it
#       (local -n) and report on the real array.
summarize() {
  echo "$1: ? hosts"
}

summarize web
summarize db
