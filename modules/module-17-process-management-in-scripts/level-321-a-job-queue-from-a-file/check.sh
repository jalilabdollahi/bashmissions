#!/usr/bin/env bash
# Replay the call log: the workers must overlap (as many as WORKERS, or as
# many as there are jobs if fewer), and never more than WORKERS.
workers=$1
[[ -f .calls.log ]] || exit 0
jobs_run=$(grep -c '^start ' .calls.log || true)
peak=0
live=0
while read -r what _; do
  case $what in
    start) live=$((live + 1)); (( live > peak )) && peak=$live ;;
    end)   live=$((live - 1)) ;;
  esac
done < .calls.log
need=$workers
(( jobs_run < workers )) && need=$jobs_run
if (( peak > workers )); then
  echo "$peak deploys overlapped, but only $workers workers were allowed."
  exit 1
fi
if (( peak < need )); then
  echo "Only $peak deploys overlapped; $need workers should have been busy at once."
  exit 1
fi
exit 0
