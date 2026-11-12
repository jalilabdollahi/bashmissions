#!/usr/bin/env bash
set -euo pipefail
# Print the effective configuration: defaults < file ($1, optional) < LF_* env,
# sorted by name, aligned, each line ending with the layer that decided it.

# TODO 1: two associative arrays: value and source. Fill them with the defaults.
# TODO 2: read the file (if given; unreadable -> exit 1) and overwrite value/source
#         for every valid, non-empty setting.
# TODO 3: find the LF_* variables by name prefix, lowercase the rest of the name,
#         and overwrite again.
# TODO 4: find the longest name, then print the sorted names with printf '%-*s'.
