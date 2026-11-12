#!/usr/bin/env bash
# Night watchman: detect a stopped service, restart once, verify, report.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SERVICE..." >&2
  exit 2
fi

failed=0
for svc in "$@"; do
  if systemctl is-active "$svc" > /dev/null; then      # exit status 0 = running
    echo "ok $svc"
    continue
  fi

  # Try the restart exactly once. A failing restart is an expected outcome here,
  # so it sits in an `if` where set -e does not abort the script.
  if systemctl restart "$svc" && systemctl is-active "$svc" > /dev/null; then
    echo "restarted $svc"
  else
    echo "FAILED $svc"
    failed=1
  fi
done

exit "$failed"
