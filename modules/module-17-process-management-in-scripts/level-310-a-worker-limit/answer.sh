#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh MAX NAME..." >&2
  exit 2
fi
max=$1
shift

running=0
ok=0
failed=0

# Wait for whichever job ends first and book its status.
# Inside "if", a failing wait -n does not trigger set -e.
reap_one() {
  if wait -n; then
    ok=$((ok + 1))
  else
    failed=$((failed + 1))
  fi
  running=$((running - 1))
}

for name in "$@"; do
  # Pool full? Make room before starting the next job.
  while (( running >= max )); do
    reap_one
  done
  resize "$name" &
  running=$((running + 1))
done

# The last few jobs are still running: collect them too.
while (( running > 0 )); do
  reap_one
done

echo "done: $ok ok, $failed failed"
if (( failed > 0 )); then
  exit 1
fi
