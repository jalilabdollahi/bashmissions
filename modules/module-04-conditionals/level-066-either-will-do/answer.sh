#!/usr/bin/env bash
set -euo pipefail

day="$1"
holiday="$2"

# || means "or": the condition is true as soon as ONE of the three tests is true.
if [[ $day == sat || $day == sun || $holiday == yes ]]; then
  echo "weekend rota: Mara has the pager"
else
  echo "weekday rota: Theo has the pager"
fi
