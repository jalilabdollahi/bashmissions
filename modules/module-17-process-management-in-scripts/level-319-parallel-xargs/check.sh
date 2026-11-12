#!/usr/bin/env bash
# The number of thumbnails that were running at the same moment must reach
# min(WORKERS, images) and never exceed WORKERS.
workers=${1:-1}
[[ -f .calls.log ]] || exit 0
images=$(grep -c '^start ' .calls.log || true)
want=$(( images < workers ? images : workers ))
peak=$(awk '
  /^start/ { running++; if (running > top) top = running }
  /^end/   { running-- }
  END      { print top + 0 }' .calls.log)
if (( peak > workers )); then
  echo "$peak thumbnails ran together but WORKERS was $workers."
  exit 1
fi
if (( peak < want )); then
  echo "Only $peak thumbnails ever ran together; with $workers workers and $images images it should reach $want. Is -P set?"
  exit 1
fi
exit 0
