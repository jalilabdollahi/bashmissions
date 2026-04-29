#!/usr/bin/env bash
set -u

set +e
(set -e; echo before; false; echo after)
code=$?
set -e
if (( code != 0 )); then
  echo "aborted=true"
fi
