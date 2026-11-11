#!/usr/bin/env bash
set -e     # stop at the first command that fails

echo "start"

# grep exits 1 when it finds nothing. As the condition of an if, that status is
# an answer, not a failure, so set -e leaves it alone.
if grep -q FATAL "$1"; then
  echo "fatal lines present"
else
  echo "no fatal lines"
fi

cp "$1" archive/log.copy     # fails when archive/ is missing: script exits here
echo "done"
