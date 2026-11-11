#!/usr/bin/env bash
exec 3>trace.log          # descriptor 3 now points at the file (truncated)
BASH_XTRACEFD=3           # xtrace output goes there instead of stderr

set -x
count=$(( $2 + 1 ))
echo "site $1 has $count pages"
set +x

# Real messages still use stderr, and nothing else is mixed in with them.
echo "warning: $1 is slow" >&2
