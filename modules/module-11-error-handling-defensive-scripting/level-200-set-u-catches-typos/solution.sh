#!/usr/bin/env bash
# Dry-run planner for old releases. Reads DEPLOY_ROOT (required) and
# RELEASE_TAG (optional, default "latest") from the environment.
# Prints what it would delete. It must never guess when a variable is missing.

# TODO 1: switch on set -u.
# TODO 2: one of the names below is misspelled. Find it.
# TODO 3: RELEASE_TAG may be unset: give it a default.

target="$DEPLOY_RROT/releases/$RELEASE_TAG"
echo "would clear $target"
