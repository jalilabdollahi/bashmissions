#!/usr/bin/env bash
# Release packager: three steps, any of which can die. When one does, say
# which line and which command, in one line on stderr:
#   error: line N: COMMAND

mkdir -p out
cp release/app.tar out/
grep -q ^version= release/app.version
echo "packaged"

# TODO 1: set -e at the top.
# TODO 2: before the first command, add an ERR trap that prints the
#         "error: line N: COMMAND" line to stderr. Mind the quotes: $LINENO and
#         $BASH_COMMAND must be read when the trap fires, not when it is set.
