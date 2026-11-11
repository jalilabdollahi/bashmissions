#!/usr/bin/env bash
set -euo pipefail
# Health run. solution.sh NAME... calls check_NAME for each NAME that is a real function.

check_disk() { echo "disk ok"; }
check_mail() { echo "mail ok"; }
check_cert() { echo "cert ok"; }

# TODO 1: loop over the arguments.
# TODO 2: ask declare -F whether check_<name> is a function (throw its output away, use its status).
# TODO 3: yes -> call it. No -> "skip: no check named NAME" on stderr and remember that something was skipped.
# TODO 4: exit 1 at the end if anything was skipped.
