#!/usr/bin/env bash
set -euo pipefail

exec 3> trace.log
BASH_XTRACEFD=3
quiet="before"
set -x
traced="inside"
set +x
after="after"
exec 3>&-
printf '%s,%s,%s\n' "$quiet" "$traced" "$after"
grep -q 'traced=inside' trace.log && ! grep -q 'after=after' trace.log && echo 'block=traced'
