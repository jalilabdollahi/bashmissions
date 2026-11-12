#!/usr/bin/env bash
set -euo pipefail

# Three interchangeable algorithms: same input (cents), same output (euros).
round_nearest() { echo $(( ($1 + 50) / 100 )); }
round_up()      { echo $(( ($1 + 99) / 100 )); }   # adding 99 pushes any fraction over the edge
round_down()    { echo $(( $1 / 100 )); }

if (( $# == 0 )); then
  echo "usage: solution.sh nearest|up|down" >&2
  exit 2
fi

# The decision is taken once, here.
case $1 in
  nearest) strategy=round_nearest ;;
  up)      strategy=round_up ;;
  down)    strategy=round_down ;;
  *) echo "unknown strategy: $1" >&2; exit 2 ;;
esac

bad=0
while read -r cents; do
  [[ -z $cents ]] && continue
  if [[ ! $cents =~ ^[0-9]+$ ]]; then
    echo "skip: '$cents' is not an amount" >&2
    bad=1
    continue
  fi
  # The loop neither knows nor cares which algorithm this is.
  echo "${cents}c -> $("$strategy" "$cents") EUR"
done

exit "$bad"
