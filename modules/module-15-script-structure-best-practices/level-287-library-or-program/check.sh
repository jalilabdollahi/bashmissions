#!/usr/bin/env bash
# Library side: source solution.sh from a second script and inspect the result.
expected=$'sourced ok\nslug: north-pier-dental'
out=$(bash fixtures/use-lib.sh 2>&1) || {
  echo "Sourcing solution.sh from fixtures/use-lib.sh failed (it probably ran main or exited): $out"
  exit 1
}
if [ "$out" != "$expected" ]; then
  echo "Sourcing solution.sh must print nothing by itself and must not turn on errexit in the caller. use-lib.sh printed: $out"
  exit 1
fi
exit 0
