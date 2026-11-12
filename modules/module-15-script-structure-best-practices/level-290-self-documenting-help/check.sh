#!/usr/bin/env bash
# Proves the help is read from the script, not copied into it: insert a new line
# into the header of a copy and make sure --help shows it.
marker="MARKER-LINE-7731 added by the checker"
awk -v m="# $marker" 'NR == 2 { print m } { print }' solution.sh > .mutated.sh
out=$(bash .mutated.sh --help 2>&1) || true
rm -f .mutated.sh
case "$out" in
  *"$marker"*) exit 0 ;;
  *)
    echo "--help must be read from the script's own header: a line added to the header did not show up in the help."
    exit 1
    ;;
esac
