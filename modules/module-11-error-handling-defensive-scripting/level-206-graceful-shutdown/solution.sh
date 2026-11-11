#!/usr/bin/env bash
# Night-queue worker for halibut. Reads jobs from queue.txt, one per line.
# On TERM it must finish the current job, start no new one, and save the rest.

mapfile -t jobs < queue.txt
done_count=0

# TODO 1: a handler + trap for TERM that only sets stopping=1 (no exit!).
# TODO 2: initialise stopping=0 and check it at the top of each iteration.

for job in "${jobs[@]}"; do
  echo "working on $job"
  # Test hook: the system asks us to stop while this job is running.
  if [[ ${TERM_DURING:-} == "$job" ]]; then
    kill -TERM $$
  fi
  echo "finished $job"
  done_count=$(( done_count + 1 ))
done

echo "drained: $done_count done"
# TODO 3: if we stopped early print "shutdown: N done, M left" instead, save the
#         untouched jobs to queue.left (one per line), and exit 0.
