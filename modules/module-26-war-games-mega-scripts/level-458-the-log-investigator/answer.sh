#!/usr/bin/env bash
# Merge three log formats into one incident timeline.
set -euo pipefail

usage() { echo "usage: solution.sh FROM TO LOGFILE..." >&2; exit 2; }

[[ $# -ge 3 ]] || usage
from=$1
to=$2
shift 2

ts_re='^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
for t in "$from" "$to"; do
  if [[ ! $t =~ $ts_re ]]; then
    echo "error: bad timestamp '$t'" >&2
    exit 2
  fi
done
# Zero-padded ISO timestamps sort correctly as plain strings.
if [[ ! $from < $to ]]; then
  echo "error: window is empty" >&2
  exit 2
fi
for f in "$@"; do
  if [[ ! -r $f ]]; then
    echo "error: cannot read $f" >&2
    exit 2
  fi
done

year=${from%%-*}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
: > "$work/events"
: > "$work/stats"

# extract FILE INDEX: print "TS|INDEX|LINENO|SERVICE|LEVEL|MESSAGE" for kept events
# and append "read bad inwindow kept" to the stats file.
extract() {
  awk -v idx="$2" -v year="$year" -v from="$from" -v to="$to" -v stats="$work/stats" '
    BEGIN {
      n = split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", names, " ")
      for (i = 1; i <= n; i++) mon[names[i]] = sprintf("%02d", i)
      rank["INFO"] = 1; rank["WARN"] = 2; rank["ERROR"] = 3; rank["CRIT"] = 4
      nd = "[0-9]"
      reA = "^\\[" nd nd nd nd "-" nd nd "-" nd nd " " nd nd ":" nd nd ":" nd nd "\\] "
      reB = "^" nd nd nd nd "-" nd nd "-" nd nd "T" nd nd ":" nd nd ":" nd nd "Z\\|"
      reC = "^[A-Z][a-z][a-z] [ 0-9]" nd " " nd nd ":" nd nd ":" nd nd " "
    }
    function norm(l) {
      if (l == "WARNING") return "WARN"
      if (l == "CRITICAL") return "CRIT"
      if (l == "ERR") return "ERROR"
      return l
    }
    function word(s) { sub(/ .*/, "", s); return s }
    /^[ \t]*$/ { next }
    {
      read++
      ts = ""
      if ($0 ~ reA) {
        ts = substr($0, 2, 19)
        rest = substr($0, 23)
        svc = word(rest); rest = substr(rest, length(svc) + 2)
        lvl = word(rest); msg = substr(rest, length(lvl) + 2)
      } else if ($0 ~ reB) {
        ts = substr($0, 1, 10) " " substr($0, 12, 8)
        split($0, p, "|")
        svc = p[2]; lvl = p[3]
        msg = substr($0, length(p[1]) + length(p[2]) + length(p[3]) + 4)
      } else if ($0 ~ reC && mon[substr($0, 1, 3)] != "") {
        day = substr($0, 5, 2); gsub(/ /, "0", day)
        ts = year "-" mon[substr($0, 1, 3)] "-" day " " substr($0, 8, 8)
        rest = substr($0, 17)
        host = word(rest); rest = substr(rest, length(host) + 2)
        svc = word(rest); rest = substr(rest, length(svc) + 2)
        sub(/\[.*/, "", svc); sub(/:$/, "", svc)
        lvl = "INFO"; msg = rest
        if (rest ~ /^\[[A-Za-z]+\] /) {
          lvl = substr(rest, 2, index(rest, "]") - 2)
          msg = substr(rest, index(rest, "]") + 2)
        }
      } else {
        bad++
        next
      }
      lvl = norm(lvl)
      if (ts < from || ts > to) next
      inwin++
      if (rank[lvl] >= 2) {
        kept++
        print ts "|" idx "|" NR "|" svc "|" lvl "|" msg
      }
    }
    END { printf "%d %d %d %d\n", read, bad, inwin, kept >> stats }
  ' "$1"
}

idx=0
for f in "$@"; do
  idx=$((idx + 1))
  extract "$f" "$idx" >> "$work/events"
done

sort -t'|' -k1,1 -k2,2n -k3,3n "$work/events" > "$work/sorted"

echo "== Incident timeline $from .. $to =="
if [[ -s $work/sorted ]]; then
  awk -F'|' '{
    msg = $6
    for (i = 7; i <= NF; i++) msg = msg "|" $i
    printf "%s %-8s %-5s %s\n", $1, $4, $5, msg
  }' "$work/sorted"
else
  echo "(no WARN-or-worse events in window)"
fi

read -r read_n bad_n win_n kept_n < <(awk '{ r += $1; b += $2; w += $3; k += $4 } END { print r + 0, b + 0, w + 0, k + 0 }' "$work/stats")
first=$(awk -F'|' '$5 == "ERROR" || $5 == "CRIT" { print $1 " " $4; exit }' "$work/sorted")
by_service=$(awk -F'|' '{ c[$4]++ } END { for (s in c) print s "=" c[s] }' "$work/sorted" | sort | paste -s -d' ' -)

echo "== Summary =="
echo "files: $# | lines: $read_n | in window: $win_n | kept: $kept_n | unparseable: $bad_n"
echo "first error: ${first:-none}"
echo "by service: ${by_service:-none}"

if awk -F'|' '$5 == "CRIT" { found = 1 } END { exit !found }' "$work/sorted"; then
  exit 1
fi
