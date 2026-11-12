#!/usr/bin/env bash
site=$1

# "2>" retargets only descriptor 2. Descriptor 1 is untouched, so the
# progress messages keep flowing to the terminal (or to cron's mail).
nightly-backup "$site" 2> backup-errors.log
