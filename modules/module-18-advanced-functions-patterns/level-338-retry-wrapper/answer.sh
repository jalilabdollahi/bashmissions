#!/usr/bin/env bash
set -euo pipefail

retry() {
  local max=$1 attempt=1 rc=0
  shift                                  # "$@" is now the command and its arguments
  while true; do
    rc=0
    "$@" || rc=$?                        # a failure is data here, not a reason to exit
    if (( rc == 0 )); then
      return 0
    fi
    echo "retry: attempt $attempt/$max failed (status $rc)" >&2
    if (( attempt >= max )); then
      echo "retry: giving up" >&2
      return "$rc"                       # the command's own status, not a generic 1
    fi
    sleep "${RETRY_DELAY:-0}"
    attempt=$(( attempt + 1 ))
  done
}

if (( $# < 2 )) || [[ ! $1 =~ ^[0-9]+$ ]] || (( $1 < 1 )); then
  echo "usage: solution.sh ATTEMPTS COMMAND [ARG...]" >&2
  exit 2
fi

status=0
retry "$@" || status=$?
exit "$status"
