#!/usr/bin/env bash
# Probe every host in parallel. Each background job gets its own result file in
# a scratch folder; afterwards print the files in argument order and clean up.

# TODO: usage error (stderr, exit 2) without arguments
# TODO: tmp=$(mktemp -d)
# TODO: n counts from 1; start latency "$host" > "$tmp/$n" 2>&1 & for each host
# TODO: wait, then cat "$tmp/1" "$tmp/2" ... in order
# TODO: rm -rf the scratch folder (carefully: only after mktemp succeeded)
# TODO: print "checked N hosts"
