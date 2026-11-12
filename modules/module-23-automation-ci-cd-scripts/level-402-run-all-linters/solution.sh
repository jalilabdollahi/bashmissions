#!/usr/bin/env bash
set -euo pipefail
# Lint stage: run shellcheck, yamllint and markdownlint on the files in "$@".
# A failing linter must not hide the next one; list all the failures at the end.

# TODO 1: usage check for "no files".
# TODO 2: keep an empty array for the names of failed linters.
# TODO 3: for each linter name, run "NAME -q files..." and keep its exit code
#         without letting set -e end the script.
# TODO 4: print "<name>: ok" or "<name>: FAILED (exit N)"; remember failures.
# TODO 5: after the loop, report on stderr and exit 1, or say all passed.
