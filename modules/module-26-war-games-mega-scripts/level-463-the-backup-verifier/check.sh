#!/usr/bin/env bash
# The scratch restore directory must be gone after every run.
left=$(ls -A "$TMPDIR" 2> /dev/null | head -n 1)
if [[ -n $left ]]; then
  echo "A scratch directory was left behind in \$TMPDIR ($left). Remove it with a trap on EXIT."
  exit 1
fi
if [[ -e fixtures/backups/../evil.txt ]]; then
  echo "An archive wrote outside the scratch directory. Reject unsafe paths before extracting."
  exit 1
fi
exit 0
