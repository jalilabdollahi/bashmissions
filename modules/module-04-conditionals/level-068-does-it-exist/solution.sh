#!/usr/bin/env bash
# Path inspector for cleanup jobs: what is at the path in $1?
# Print "<path>: <kind>" with kind = regular file / directory / something else / not found.

# TODO: keep the path in a variable (and quote it everywhere you use it)
# TODO: ladder: -f, then -d, then -e for "exists but odd", else not found
