#!/usr/bin/env bash
# Run "run-job JOB" under a lock directory run/JOB.lock so that two copies
# never overlap. mkdir creates the lock; a trap removes it again.

job=$1

run-job "$job"
# TODO: usage check; make sure the folder "run" exists
# TODO: take the lock with mkdir -- if that fails, say who is running and exit 1
# TODO: from then on, release the lock when the script ends (trap ... EXIT)
# TODO: log "JOB started", run the job, log "JOB finished"
