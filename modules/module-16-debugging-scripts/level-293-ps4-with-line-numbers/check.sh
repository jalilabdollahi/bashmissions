#!/usr/bin/env bash
# Line numbers depend on how the player lays out the file, so verify that each
# number in the trace points at a line of solution.sh holding that command.
stray=$(grep -vE '^\+ L[0-9]+: ' "$BM_STDERR_FILE" | head -n 1)
if [[ -n $stray ]]; then
  echo "A trace line does not start with '+ L<number>: ': $stray"
  exit 1
fi
[[ -s $BM_STDERR_FILE ]] || {
  if [[ $BM_TEST_NAME == "nothing to check" ]]; then exit 0; fi
  echo "No trace on stderr. Did you turn on set -x?"; exit 1; }
while IFS= read -r line; do
  rest=${line#+ L}
  n=${rest%%:*}
  cmd=${rest#*: }
  word=${cmd%% *}
  src=$(sed -n "${n}p" solution.sh)
  if [[ $src != *"$word"* ]]; then
    echo "Trace says line $n for '$cmd', but line $n of solution.sh is: $src"
    echo "Is PS4 in single quotes, so \$LINENO is expanded per trace line?"
    exit 1
  fi
done < "$BM_STDERR_FILE"
exit 0
