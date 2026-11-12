#!/usr/bin/env bash
# The failing line number depends on how the player lays out the script, so
# compare it with the real contents of solution.sh instead of a fixed number.
if [[ $BM_EXIT == 0 ]]; then
  if grep -q '^error:' "$BM_STDERR_FILE"; then
    echo "The script succeeded but still printed an error line on stderr."
    exit 1
  fi
  exit 0
fi
case $BM_TEST_NAME in
  "the copy fails") want='cp release/app.tar out/' ;;
  "the version check fails") want='grep -q ^version= release/app.version' ;;
  *) exit 0 ;;
esac
line=$(grep -E '^error: line [0-9]+: ' "$BM_STDERR_FILE" | head -n 1)
if [[ -z $line ]]; then
  echo "No stderr line shaped like 'error: line N: COMMAND' was found."
  exit 1
fi
count=$(grep -c '^error:' "$BM_STDERR_FILE")
if (( count != 1 )); then
  echo "Expected exactly one 'error:' line on stderr, found $count."
  exit 1
fi
rest=${line#error: line }
n=${rest%%:*}
text=${rest#*: }
if [[ $text != "$want" ]]; then
  echo "The command part says '$text' but the failing command was '$want'."
  exit 1
fi
src=$(sed -n "${n}p" solution.sh)
if [[ $src != *"$want"* ]]; then
  echo "You reported line $n, but that line of solution.sh is: $src"
  exit 1
fi
exit 0
