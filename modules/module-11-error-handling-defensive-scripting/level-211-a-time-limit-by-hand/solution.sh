#!/usr/bin/env bash
# Time-limited scan. Argument 1 = LIMIT seconds. No "timeout" command allowed:
# macOS does not ship it. Build the limit from a background job, sleep and kill.

limit=$1

# TODO 1: start lanternscan in the background and save its PID.
# TODO 2: sleep for $limit seconds.
# TODO 3: still running (kill -0)?  yes -> kill it, wait for it, message, exit 124
#                                    no  -> wait for it, pass its status along
