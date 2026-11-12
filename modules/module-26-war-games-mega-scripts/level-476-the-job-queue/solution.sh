#!/usr/bin/env bash
# A file-based FIFO job queue: pending/ done/ failed/ claims/ under queue/.
#   solution.sh submit [--name NAME] COMMAND...
#   solution.sh work [--workers N] [--max-tries T] [--limit K]
#   solution.sh status | retry ID | log ID

# TODO: usage, positive-integer option validation
# TODO: submit: next id from queue/.next (%04d), write the job elsewhere, mv it into pending/
# TODO: work: run lock with mkdir queue/work.lock + trap; recover orphaned claims; select the pending ids (--limit)
# TODO: a worker function: for each selected id, claim with mkdir queue/claims/ID (skip on failure),
#       run `bash -c` up to --max-tries times with sleep 1 between, move job + .out to done/ or failed/, remove the claim
# TODO: start W workers in the background, wait, then print one line per job in id order and the summary
# TODO: status (counts + table), retry ID, log ID
