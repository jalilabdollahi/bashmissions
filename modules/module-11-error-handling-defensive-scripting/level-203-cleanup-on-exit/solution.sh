#!/usr/bin/env bash
# Deploy wrapper. The lock file must not outlive the script, even when the build
# crashes and set -e kills us in the middle.

touch deploy.lock

lanternbuild
echo "deploy finished"

# TODO 1: set -e at the top.
# TODO 2: right after touch, register a trap on EXIT that removes deploy.lock
#         and prints "lock released".
