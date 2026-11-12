#!/usr/bin/env bash
check=1
# "until" runs the body while the command FAILS, and stops at the first success.
until replica-status; do
  echo "check $check: not ready"
  check=$(( check + 1 ))
done
echo "replica ready after $check check(s)"
