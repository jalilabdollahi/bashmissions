#!/usr/bin/env bash
set -euo pipefail

passed=0
failed=0

source "$1"    # defines the test functions (and helpers) in this shell

# compgen -A function lists function names starting with the given prefix;
# sort makes the order stable. The while-read loop keeps names intact.
while IFS= read -r name; do
  # The subshell isolates the test: exit, crashes and variable changes stay
  # inside it. Used as an if condition, its non-zero status is just an answer.
  if ( "$name" ) > /dev/null 2>&1; then
    echo "PASS $name"
    passed=$(( passed + 1 ))        # not ((passed++)): that returns 1 when passed is 0
  else
    echo "FAIL $name"
    failed=$(( failed + 1 ))
  fi
done < <(compgen -A function test_ | sort)

echo "$passed passed, $failed failed"
(( failed == 0 ))
