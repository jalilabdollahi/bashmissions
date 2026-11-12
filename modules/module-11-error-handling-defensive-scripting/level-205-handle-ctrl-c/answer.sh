#!/usr/bin/env bash
last=0

on_interrupt() {
  echo "interrupted after batch $last"
  echo "$last" > import.state     # next run can resume from here
  exit 130                          # 128 + 2 (SIGINT): "killed by Ctrl-C"
}
trap on_interrupt INT

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
