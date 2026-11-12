#!/usr/bin/env bash
# A circuit breaker for any command. Its memory (state, failures, opened_at)
# lives in a file so that separate runs share it. NOW is passed in.
#   solution.sh STATE run NOW CMD [ARGS...] | status NOW | reset
# Settings: THRESHOLD (default 3) and COOLDOWN (default 30) from the environment.

# TODO: usage(), and validation of THRESHOLD, COOLDOWN and NOW
# TODO: load_state: read the three key=value lines, exit 2 on corruption
# TODO: save_state: temp file next to STATE, then mv it into place
# TODO: run: closed -> count failures; open -> skip or become half-open probe
# TODO: remember the guarded command's exit status and exit with it
# TODO: status and reset
