#!/usr/bin/env bash
set -u

# $LINENO is replaced by the line of the command that is running, so each
# message carries its own address. Two different messages, two different numbers.
if [[ ! -e $1 ]]; then
  echo "error (line $LINENO): file not found: $1" >&2
  exit 1
fi

if [[ ! -s $1 ]]; then
  echo "error (line $LINENO): file is empty: $1" >&2
  exit 2
fi

echo "config ok: $1"
