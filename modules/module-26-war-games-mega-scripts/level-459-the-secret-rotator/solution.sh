#!/usr/bin/env bash
# Rotate credentials listed in rotation.map (NAME|CONFIG|KEY|DBUSER):
# new secret -> database -> config -> verify, rolling back on failure.
#   solution.sh [--dry-run] [NAME...]

# TODO: --dry-run flag, read rotation.map into associative arrays (keep the order)
# TODO: validate every requested NAME before changing anything (exit 2)
# TODO: write_config: replace the KEY= line, keep mode, build next to the old file, mv
#       (pass the value to awk via the environment)
# TODO: rotate_one NAME: the six steps from the objective, setting $reason on failure
# TODO: loop over the targets, print per-name status, append to rotation.log
# TODO: final "rotated:" / "failed:" lines and the exit status
