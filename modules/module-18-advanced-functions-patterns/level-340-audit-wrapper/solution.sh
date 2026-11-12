#!/usr/bin/env bash
set -euo pipefail
# Night bot with a paper trail. Reads commands from stdin, runs each through audited,
# which appends "USER: WORDS status=N" to the audit log.

# TODO 1: log path: ${AUDIT_LOG:-audit.log} (also when the variable is set but empty).
# TODO 2: audited(): run "$@" without letting a failure end the script; keep its status.
#         Build the WORDS text with printf -v ... '%q ' "$@" (trim the last space),
#         then append the line with >>.
# TODO 3: loop over stdin: read -ra splits a line into words; skip empty lines;
#         call audited "${words[@]}". Remember if any command failed.
# TODO 4: exit 1 if anything failed, else 0.
