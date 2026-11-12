#!/usr/bin/env bash
# Invoice line tally.
set -euo pipefail

# Helper: how many lines does one file have?
count_lines() {
  # arithmetic strips the padding some wc versions add
  echo $(( $(wc -l < "$1") ))
}

main() {
  if [ "$#" -eq 0 ]; then
    echo "usage: solution.sh FILE..." >&2
    return 2
  fi

  local total=0 missed=0 f n
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
  return "$missed"
}

# Everything above only defines things. This single line starts the program,
# and its status becomes the script's exit status.
main "$@"
