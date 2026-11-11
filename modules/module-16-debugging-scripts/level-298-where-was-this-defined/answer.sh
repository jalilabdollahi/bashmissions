#!/usr/bin/env bash
set -u

# ${BASH_SOURCE[0]} is the file this function's code was read from, even when
# the function is called later by somebody else.
host_label() {
  echo "host: $1 (defined in $(basename "${BASH_SOURCE[0]}"))"
}

main() {
  if (( $# == 0 )); then
    echo "usage: solution.sh HOSTNAME" >&2
    exit 2
  fi
  host_label "$1"
}

# When run as "bash solution.sh", BASH_SOURCE[0] and $0 are the same file.
# When sourced, $0 is still the caller's name, so the test is false.
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  main "$@"
fi
