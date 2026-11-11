#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh WORKERS QUEUE" >&2
  exit 2
fi
workers=$1
queue=$2

if [[ ! -r $queue ]]; then
  echo "cannot read $queue" >&2
  exit 1
fi

# One worker = one pass over the queue, doing only its own share.
worker() {
  local id=$1 n=0 job
  while IFS= read -r job; do
    # Skip comments and lines with nothing but blanks; they are not jobs.
    if [[ -z ${job//[[:space:]]/} || $job == \#* ]]; then
      continue
    fi
    # Job number n belongs to worker n % workers. n counts every job,
    # whether or not it is ours, so all workers agree on the numbering.
    if (( n % workers == id )); then
      if deploy "$job"; then
        echo "$job ok"
      else
        echo "$job FAILED"
      fi
    fi
    n=$((n + 1))
  done < "$queue"
}

# All workers print into the same pipe; the group waits for them, and
# sort puts the lines in a fixed order.
results=$(
  {
    for ((id = 0; id < workers; id++)); do
      worker "$id" &
    done
    wait
  } | sort
)

total=0
failed=0
if [[ -n $results ]]; then
  printf '%s\n' "$results"
  total=$(printf '%s\n' "$results" | awk 'END { print NR }')
  failed=$(printf '%s\n' "$results" | awk '/ FAILED$/ { n++ } END { print n + 0 }')
fi

echo "$total jobs, $failed failed"
if (( failed > 0 )); then
  exit 1
fi
