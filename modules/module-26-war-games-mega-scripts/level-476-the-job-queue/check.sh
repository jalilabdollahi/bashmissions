#!/usr/bin/env bash
# No job may ever run twice, and no claim or lock may be left behind by a finished run.
if [[ -f ran.log ]]; then
  dup=$(sort ran.log | uniq -d | head -n 1)
  if [[ -n $dup ]]; then
    echo "Job $dup ran more than once. Claim a job with mkdir before running it."
    exit 1
  fi
fi
if [[ $BM_TEST_NAME != "another worker run is active" && -d queue/work.lock ]]; then
  echo "queue/work.lock was left behind. Remove it with a trap."
  exit 1
fi
for c in queue/claims/*; do
  [[ -d $c ]] || continue
  case $BM_TEST_NAME in
    "status shows every state" | "a crashed run is recovered") ;;
    *) echo "claim $c was not released after the job finished."; exit 1 ;;
  esac
done
exit 0
