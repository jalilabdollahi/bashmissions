#!/usr/bin/env bash
# $? is overwritten by EVERY command, including echo, so each status is
# copied into its own variable on the very next line.

grep -q -x -F "$HOST" fixtures/active.txt
active_rc=$?

grep -q -x -F "$HOST" fixtures/retired.txt
retired_rc=$?

echo "active=$active_rc"
echo "retired=$retired_rc"

exit "$active_rc"
