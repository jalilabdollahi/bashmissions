#!/usr/bin/env bash
# Check every server given as an argument with "probe-host NAME" (1 second each)
# at the same time, then print "<name>: <up|down>" in argument order and
# "checked N hosts".
# TODO: tmp dir, background jobs saving their output, wait, ordered report.
for host in "$@"; do
  echo "$host: $(probe-host "$host")"
done
echo "checked $# hosts"
