#!/usr/bin/env bash
# Newsletter gatekeeper. For every address on stdin print "OK <addr>" or "BAD <addr>".
# Valid = local part [letters digits . _ % + -], @, domain [letters digits . -],
# a dot, and a final extension of 2 or more letters. The whole line must fit.
# TODO: one anchored regex; mind the literal dot and where the - goes inside [ ]
while IFS= read -r addr || [[ -n $addr ]]; do
  echo "OK $addr"
done
