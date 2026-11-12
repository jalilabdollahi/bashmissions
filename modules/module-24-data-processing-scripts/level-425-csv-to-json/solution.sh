#!/usr/bin/env bash
# "$1": a CSV with header. Print a JSON array of objects (one per data row),
# keys from the header, values: null / bare number / escaped string.

# TODO 1: awk -F, ; strip \r, skip blank lines, remember the header names.
# TODO 2: write esc(s): loop with substr, turn \ into \\ and " into \" .
# TODO 3: write a value function: "" -> null, a JSON number -> as is, else quoted.
# TODO 4: build each object line; print "[" before the first, a comma after
#         every object but the last, "]" at the end, or "[]" if there were none.
