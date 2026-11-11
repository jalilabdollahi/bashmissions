#!/usr/bin/env bash
# Declarative tests only run the script directly. Here we source it from
# another script and check that nothing runs and that the function still works.
cat > user.sh <<'INNER'
set -u
source ./solution.sh
host_label eel
INNER
out=$(bash user.sh 2>&1); rc=$?
want='host: eel (defined in solution.sh)'
if (( rc != 0 )); then
  echo "Sourcing solution.sh from another script failed (status $rc): $out"
  echo "Did main run on source? It should only run when BASH_SOURCE[0] equals \$0."
  exit 1
fi
if [[ $out != "$want" ]]; then
  echo "After 'source ./solution.sh', host_label eel printed:"
  echo "$out"
  echo "expected exactly: $want"
  exit 1
fi
exit 0
