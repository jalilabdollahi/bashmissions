#!/usr/bin/env bash
# Compare the (sorted) package lists of two hosts, $1 and $2, with diff.
# If they are the same print "hosts match". No temp files.

host_a=$1
host_b=$2

# TODO: diff <(sorted list of host a) <(sorted list of host b)
# TODO: "hosts match" when diff finds nothing
