#!/usr/bin/env bash
# Sort sshd_config lines (stdin) into blank / comment / risky / other.
# Rules, checked in this order: empty line, starts with #, ends with " yes", the rest.
# TODO: read each line, then test it with [[ =~ ]] using ^ and $
# TODO: print exactly one word per line
while IFS= read -r line || [[ -n $line ]]; do
  echo other
done
