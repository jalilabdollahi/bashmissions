#!/usr/bin/env bash
set -euo pipefail
# ./solution.sh PCT   disk watch with levelled logging to stderr.
# TODO: log LEVEL MESSAGE - turn level names into numbers (a case statement in a
#       tiny helper works well), compare with ${LOG_LEVEL:-INFO}, print "[LEVEL] message" to stderr.
# TODO: the main part: the DEBUG and INFO lines, the ERROR/WARN decision, then "checked: PCT%".
