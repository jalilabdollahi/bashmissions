#!/usr/bin/env bash
# Deploy pipeline: build, test, ship. Each stage runs through run_stage, which
# also keeps a log with tee. At the moment the exit status of a failed stage
# vanishes somewhere between lanternci and the end of the script.

run_stage() {
  echo "[$1] start"
  lanternci "$1" 2>&1 | tee "$1.log"
  # TODO 1: get lanternci's own status (not tee's). If it is not 0, print
  #         "[NAME] failed with status N" to stderr and return that status.
}

# TODO 2: run build, test, ship in order. The first failing stage must end the
#         script with that stage's exit status; ship must not run after a failed test.
echo "deployed"
