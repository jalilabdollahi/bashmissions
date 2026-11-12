#!/usr/bin/env bash
# Config drift detector: compare a golden config tree with the live one and report
# only the differences that matter (settings, content, permissions).
#   solution.sh [--plan] GOLDEN_DIR LIVE_DIR

# TODO: parse --plan, validate the two directories (exit 2)
# TODO: read golden/.modes (path -> octal) into an associative array, golden/.ignore into a list
# TODO: mode_octal: turn the ls -l permission string into octal digits
# TODO: conf_diff: normalise two .conf files in awk and print ~ / + / - lines sorted by key,
#       masking secret-looking keys
# TODO: build the merged, sorted list of relative paths from both trees
# TODO: classify each path (DRIFT / MISSING / UNMANAGED) and print the report or collect plan commands
# TODO: summary line (or the plan header + commands) and the exit status
