#!/usr/bin/env bash
set -euo pipefail
# Run each step script given on the command line, in order.
# The first failing step must stop the pipeline and set our exit code.

# TODO 1: no arguments -> usage message on stderr, exit 2.
# TODO 2: loop over the steps, printing "step N/TOTAL: name" before each.
# TODO 3: run the step with bash, but capture a failure instead of letting
#         set -e kill the script before you can report it.
# TODO 4: on failure report on stderr and exit with the step's own code.
# TODO 5: if the loop finishes, print the "pipeline passed" line.
