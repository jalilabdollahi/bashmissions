#!/usr/bin/env bash
# Nightly customer import in five batches. Gus wants it to survive Ctrl-C
# politely: report the last finished batch, save it, exit 130.

last=0

# TODO: add a handler function and trap INT before the loop starts.
#       It should print "interrupted after batch N", write N into
#       import.state, and exit 130.

for batch in 1 2 3 4 5; do
  # (real import work would happen here)
  last=$batch
  echo "batch $batch done"
  # Test hook: simulates the operator pressing Ctrl-C after this batch.
  if [[ ${INTERRUPT_AFTER:-0} == "$batch" ]]; then
    kill -INT $$
  fi
done
echo "import complete"
