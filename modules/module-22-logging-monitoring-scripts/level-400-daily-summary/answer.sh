#!/usr/bin/env bash
# Summarise one day of logs from several files in a single awk pass.
set -euo pipefail

date=${1:-}
if [[ ! $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ || $# -lt 2 ]]; then
  echo "usage: solution.sh DATE LOGFILE..." >&2
  exit 2
fi
shift

for f in "$@"; do
  if [[ ! -r $f ]]; then
    echo "cannot read $f" >&2
    exit 1
  fi
done

# awk prints a small tagged data stream; bash lays out the report from it.
# Time strings like 08:14:03 compare correctly as text, so no date maths.
data=$(awk -v day="$date" '
  $1 == day && NF >= 4 {
    total++
    level[$3]++
    if ($3 == "ERROR") {
      host[$4]++
      if (first == "" || $2 < first) { first = $2; firsthost = $4 }
      if (last == "" || $2 >= last)  { last = $2;  lasthost = $4 }
    }
  }
  END {
    print "LINES", total + 0
    print "INFO", level["INFO"] + 0
    print "WARN", level["WARN"] + 0
    print "ERROR", level["ERROR"] + 0
    for (h in host) print "HOST", h, host[h]
    if (first != "") { print "FIRST", first, firsthost; print "LAST", last, lasthost }
  }
' "$@")

count() { awk -v k="$1" '$1 == k { print $2 }' <<< "$data"; }

echo "Daily summary for $date"
echo "lines: $(count LINES)"
echo "INFO: $(count INFO)"
echo "WARN: $(count WARN)"
echo "ERROR: $(count ERROR)"
echo "errors by host:"

# Most errors first (numeric, reverse), then host name; keep three.
hosts=$(awk '$1 == "HOST" { print $2, $3 }' <<< "$data" | sort -k2,2nr -k1,1 | head -n 3)
if [[ -z $hosts ]]; then
  echo "  none"
else
  while read -r h n; do
    echo "  $h $n"
  done <<< "$hosts"
fi

first=$(awk '$1 == "FIRST" { print $2 " (" $3 ")" }' <<< "$data")
last=$(awk '$1 == "LAST" { print $2 " (" $3 ")" }' <<< "$data")
echo "first error: ${first:-none}"
echo "last error: ${last:-none}"
