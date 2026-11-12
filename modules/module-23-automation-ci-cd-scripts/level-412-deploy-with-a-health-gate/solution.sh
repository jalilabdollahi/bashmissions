#!/usr/bin/env bash
set -euo pipefail
# Deploy VERSION with deployctl, then poll URL until it is healthy or the
# attempts run out. A deploy is only "done" when the service answers.

# TODO 1: validate arguments; MAX_ATTEMPTS defaults to 5 and must be >= 1.
# TODO 2: run deployctl push; on failure say "deploy failed" and exit 1.
# TODO 3: loop attempt = 1..MAX, asking curl with the flags from the objective
#         and using its exit status as the test (hide its output).
# TODO 4: healthy -> report the attempt number and exit 0.
# TODO 5: not healthy -> say so, and sleep 2 only if another attempt follows.
# TODO 6: out of attempts -> message on stderr, exit 1.
