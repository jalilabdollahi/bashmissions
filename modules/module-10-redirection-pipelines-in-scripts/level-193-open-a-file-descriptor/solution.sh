#!/usr/bin/env bash
# For every service given, run svc-status and write "<service>: <state>"
# into report.txt through a descriptor of your own (fd 3, opened ONCE).
# On the screen print only "checked N services, M down".

total=0
down=0

# TODO: open report.txt as fd 3 before the loop
for service in "$@"; do
  # TODO: capture svc-status output; count failures
  # TODO: write the report line to fd 3
  total=$(( total + 1 ))
done
# TODO: close fd 3

echo "checked $total services, $down down"
