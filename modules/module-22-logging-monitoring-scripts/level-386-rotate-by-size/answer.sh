#!/usr/bin/env bash
# Size-based log rotation in plain Bash.
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh LOGFILE MAXBYTES KEEP" >&2
  exit 2
fi
log=$1
max=$2
keep=$3

if [[ ! -f $log ]]; then
  echo "no such log: $log" >&2
  exit 1
fi

# wc pads its number with spaces on some systems; $(( )) removes them.
size=$(( $(wc -c < "$log") ))

if (( size <= max )); then
  echo "$log ok ($size bytes)"
  exit 0
fi

rm -f "$log.$keep"                       # the oldest copy falls off the end
for (( i = keep - 1; i >= 1; i-- )); do  # highest first, or we would overwrite
  if [[ -e $log.$i ]]; then
    mv "$log.$i" "$log.$((i + 1))"
  fi
done
mv "$log" "$log.1"
: > "$log"                               # new, empty log for the service to use
echo "rotated $log ($size bytes)"
