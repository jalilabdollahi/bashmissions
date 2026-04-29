#!/usr/bin/env bash
set -u

if (set -o pipefail; false | true); then
  echo "pipeline=ok"
else
  echo "pipeline=failed"
fi
