#!/usr/bin/env bash
set -euo pipefail

name=${1:-}
if [[ ! $name =~ ^[A-Za-z0-9_-]+$ ]] || (( $# < 2 )); then
  echo "usage: solution.sh NAME COMMAND [ARG...]" >&2
  exit 2
fi
shift                              # from here on "$@" is the command and its arguments

lock="locks/$name.lock"
log="logs/$name.log"
mkdir -p locks logs

# mkdir either creates the directory or fails, in one atomic step, so two
# runs can never both believe they hold the lock.
if ! mkdir "$lock" 2>/dev/null; then
  echo "[$name] skipped: previous run still active" >> "$log"
  exit 0                           # no trap yet: the lock belongs to the other run
fi

# The trap goes AFTER we own the lock. If it were earlier, a skipped run would
# delete the lock of the run that is still working.
trap 'rmdir "$lock"' EXIT
trap 'exit 130' INT                # turn signals into a normal exit so EXIT runs
trap 'exit 143' TERM

echo "[$name] start: $*" >> "$log"

rc=0
"$@" >> "$log" 2>&1 || rc=$?

echo "[$name] finish: exit $rc" >> "$log"
exit "$rc"
