#!/usr/bin/env bash
# Search the given config files, in order, for "PermitRootLogin yes".
# First hit: print "first insecure config: <path>" and exit 0.
# No hit: print "no insecure config found" and exit 1.
# TODO: loop, grep -q each file, remember the hit, break.
for file in "$@"; do
  echo "checking $file"
done
