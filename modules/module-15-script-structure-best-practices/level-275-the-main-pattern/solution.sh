#!/usr/bin/env bash
# Invoice line tally, as Theo left it. Works, but has no clear entry point.
set -euo pipefail

total=0
missed=0

if [ "$#" -eq 0 ]; then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi

count_lines() {
  # wc pads its answer on some systems, the arithmetic strips the padding
  echo $(( $(wc -l < "$1") ))
}

for f in "$@"; do
  if [ -r "$f" ]; then
    n=$(count_lines "$f")
    echo "$f: $n lines"
    total=$((total + n))
  else
    echo "skip: $f" >&2
    missed=1
  fi
done
echo "total: $total"
exit "$missed"

# TODO: wrap the top-level logic (usage check, loop, summary) in main(),
# keep count_lines as a helper, and end the file with: main "$@"
# (As written, the script also has no "main" function, so the test fails.)
