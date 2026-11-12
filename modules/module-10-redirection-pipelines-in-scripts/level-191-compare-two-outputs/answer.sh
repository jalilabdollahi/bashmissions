#!/usr/bin/env bash
host_a=$1
host_b=$2

# <( ... ) runs the command and gives diff a file name (/dev/fd/N) from which
# it can read that command's output. Two commands, two "files", zero temp files.
# Inside an if, diff's own exit status (0 = identical) decides the message.
if diff <(pkg-list "$host_a" | sort) <(pkg-list "$host_b" | sort); then
  echo "hosts match"
fi
