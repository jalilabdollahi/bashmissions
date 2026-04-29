#!/usr/bin/env bash
set -u

if (set -u; echo "$missing_value") 2> unset.log; then
  echo "unexpected=success"
else
  echo "unset=blocked"
fi
