#!/usr/bin/env bash
set -euo pipefail

PS3="choice: "
select item in apple banana cherry; do
  echo "selected=$item"
  break
done <<< "${1:-1}"
