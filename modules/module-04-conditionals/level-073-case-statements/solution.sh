#!/usr/bin/env bash
# Front end of the lanternctl wrapper: pick the line to print from the action in $1.
# Four known actions, everything else is a usage error (stderr, exit 2).

# TODO: read $1 safely (it may be missing)
# TODO: case "$action" in  start) ... ;;  stop) ... ;;  ...  esac
# TODO: the last branch, *), prints the usage line to stderr and exits 2
