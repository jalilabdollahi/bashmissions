#!/usr/bin/env bash
# Page counter for the support desk. $1 = site, $2 = number of pages.
# The trace is useful, but it must not travel by e-mail with stderr.

# TODO 1: open file descriptor 3 onto trace.log.
# TODO 2: tell Bash to send its trace to that descriptor.

set -x
count=$(( $2 + 1 ))
echo "site $1 has $count pages"
set +x

echo "warning: $1 is slow" >&2
