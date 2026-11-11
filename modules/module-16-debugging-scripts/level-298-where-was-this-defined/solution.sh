#!/usr/bin/env bash
set -u
# A host labelling helper that is both a library and a command.
# Run it:      ./solution.sh anchovy
# Source it:   source ./solution.sh; host_label anchovy

# TODO 1: host_label() should print "host: NAME (defined in FILE)" with FILE
#         taken from BASH_SOURCE[0] (base name only; basename is allowed).

main() {
  if (( $# == 0 )); then
    echo "usage: solution.sh HOSTNAME" >&2
    exit 2
  fi
  host_label "$1"
}

# TODO 2: call main "$@" only when this file is executed, not sourced.
