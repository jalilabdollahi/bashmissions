#!/usr/bin/env bash
set -euo pipefail
# Promote the version running in environment $1 to the next environment $2,
# enforcing: one step at a time, no downgrades, prod needs an approval file.

# TODO 1: keep the stages in order in an array; find the index of $1 and $2.
# TODO 2: $2 must be the stage right after $1.
# TODO 3: read versions/FROM; validate it. Compare it with versions/TO using a
#         function that splits both on dots and compares number by number.
# TODO 4: prod needs approvals/VERSION.
# TODO 5: run deployctl; only when it succeeded, record the version (write a
#         temp file and mv it) and print the "promoted" line.
