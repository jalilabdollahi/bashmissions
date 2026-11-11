#!/usr/bin/env bash
set -euo pipefail
# Deploy ceremony with hooks. solution.sh SITE [before:NAME | after:NAME ...]
# Hooks are functions named hook_lock, hook_snapshot, hook_notify, hook_cache.

site=$1
shift

# TODO 1: write the four hook functions (each prints its line using $1).
# TODO 2: create the empty arrays before_hooks and after_hooks.
# TODO 3: for each remaining argument, split "phase:name"; validate both
#         parts; append hook_<name> to the right array. Bad spec -> stderr, exit 2.
# TODO 4: run the before hooks, print "deploying SITE", run the after hooks.
