#!/usr/bin/env bash
set -euo pipefail

check_disk() { echo "disk ok"; }
check_mail() { echo "mail ok"; }
check_cert() { echo "cert ok"; }

skipped=0
for name in "$@"; do
  # declare -F NAME prints the name and succeeds only when NAME is a function.
  # We want the status, not the text. As an `if` condition a failure is an
  # answer, not an error, so set -e leaves it alone.
  if declare -F "check_$name" > /dev/null; then
    "check_$name"
  else
    echo "skip: no check named $name" >&2
    skipped=1
  fi
done

exit "$skipped"
