#!/usr/bin/env bash
# Translate the HTTP status code in $1 into the action from the runbook.
# Five outcomes, but only one line of output per run.

# TODO: store the code in a variable
# TODO: if it is 200 -> healthy line
# TODO: elif it is 301, 404, 503 -> their lines (one elif each)
# TODO: else -> the "unexpected status" line that includes the code
