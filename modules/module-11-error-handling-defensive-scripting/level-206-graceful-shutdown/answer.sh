#!/usr/bin/env bash
mapfile -t jobs < queue.txt
done_count=0
stopping=0

# The handler only raises a flag. Exiting here would cut the running job in half.
request_stop() { stopping=1; }
trap request_stop TERM

for job in "${jobs[@]}"; do
  # Safe point: between jobs nothing is half-finished.
  if (( stopping )); then
    break
  fi
  echo "working on $job"
  # Test hook: the system asks us to stop while this job is running.
  if [[ ${TERM_DURING:-} == "$job" ]]; then
    kill -TERM $$
  fi
  echo "finished $job"
  done_count=$(( done_count + 1 ))
done

if (( stopping )); then
  left=$(( ${#jobs[@]} - done_count ))
  echo "shutdown: $done_count done, $left left"
  printf '%s\n' "${jobs[@]:done_count}" > queue.left
  exit 0
fi
echo "drained: $done_count done"
