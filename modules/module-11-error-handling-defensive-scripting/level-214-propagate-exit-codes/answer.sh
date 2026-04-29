#!/usr/bin/env bash
set -u

run_check() {
  grep -q "$1" fixtures/data.txt
  return $?
}

run_check delta
code=$?
echo "function_exit=$code"
exit 0
