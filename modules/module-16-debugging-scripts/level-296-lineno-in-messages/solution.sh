#!/usr/bin/env bash
set -u
# Config file sanity check. $1 = the config file.
# Every error must name the line of THIS script that raised it.

if [[ ! -e $1 ]]; then
  # TODO: print "error (line N): file not found: NAME" to stderr, N via $LINENO
  exit 1
fi

if [[ ! -s $1 ]]; then
  # TODO: print "error (line N): file is empty: NAME" to stderr
  exit 2
fi

echo "config ok: $1"
