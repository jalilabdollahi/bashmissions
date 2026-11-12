#!/usr/bin/env bash
# notes: a sticky note for the night shift, stored in ./notes.txt.
#   solution.sh add TEXT... | list | remove N
# Right now it can only list. Add the other verbs and a dispatcher.
set -euo pipefail

readonly NOTES=notes.txt

usage() {
  echo "usage: solution.sh add TEXT... | list | remove N" >&2
  exit 2
}

cmd_list() {
  if [ ! -s "$NOTES" ]; then
    echo "no notes"
    return 0
  fi
  awk '{ printf "%d) %s\n", NR, $0 }' "$NOTES"
}

# TODO: write cmd_add (append the joined words, print "added: ..."),
# cmd_remove (validate N, print "removed: ...", rewrite the file without that line),
# and finish with a dispatcher: case on "${1:-}", shift the verb, call cmd_*.
cmd_list
