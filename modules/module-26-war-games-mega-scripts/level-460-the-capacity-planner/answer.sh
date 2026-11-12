#!/usr/bin/env bash
# Capacity planner: least-squares growth per disk, projected full date, alert level.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--warn DAYS] [--crit DAYS] FILE" >&2
  exit 3
}

warn=45
crit=14
while (( $# > 0 )); do
  case $1 in
    --warn | --crit)
      if [[ $# -lt 2 || ! $2 =~ ^[0-9]+$ ]]; then
        echo "error: $1 needs a whole number of days" >&2
        exit 3
      fi
      if [[ $1 == --warn ]]; then warn=$2; else crit=$2; fi
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 1 ]] || usage
file=$1
if (( crit > warn )); then
  echo "error: --crit must not exceed --warn" >&2
  exit 3
fi
if [[ ! -r $file ]]; then
  echo "error: cannot read $file" >&2
  exit 3
fi

# Rows leave awk as "SORTKEY|host|mount|pct|slope|left|full|status".
rows=$(awk -F, -v warn="$warn" -v crit="$crit" '
  # Days since 1970-01-01 for a civil date, and the way back (Hinnant algorithms).
  function days(y, m, d,   era, yoe, doy, doe) {
    y -= (m <= 2)
    era = int((y >= 0 ? y : y - 399) / 400)
    yoe = y - era * 400
    doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + d - 1
    doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
    return era * 146097 + doe - 719468
  }
  function civil(z,   era, doe, yoe, y, doy, mp, d, m) {
    z += 719468
    era = int((z >= 0 ? z : z - 146096) / 146097)
    doe = z - era * 146097
    yoe = int((doe - int(doe / 1460) + int(doe / 36524) - int(doe / 146096)) / 365)
    y = yoe + era * 400
    doy = doe - (365 * yoe + int(yoe / 4) - int(yoe / 100))
    mp = int((5 * doy + 2) / 153)
    d = doy - int((153 * mp + 2) / 5) + 1
    m = mp + (mp < 10 ? 3 : -9)
    return sprintf("%04d-%02d-%02d", y + (m <= 2), m, d)
  }
  /^[ \t]*$/ { next }
  NR == 1 && $1 == "date" { next }
  {
    if (NF != 5 || $1 !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/ ||
        $4 !~ /^[0-9]+(\.[0-9]+)?$/ || $5 !~ /^[0-9]+(\.[0-9]+)?$/ || $5 + 0 <= 0) {
      bad++
      next
    }
    k = $2 SUBSEP $3
    x = days(substr($1, 1, 4) + 0, substr($1, 6, 2) + 0, substr($1, 9, 2) + 0)
    c = ++n[k]
    xs[k, c] = x; ys[k, c] = $4 + 0
    if (c == 1 || x < first[k]) first[k] = x
    if (c == 1 || x >= last[k]) { last[k] = x; used[k] = $4 + 0; total[k] = $5 + 0 }
    host[k] = $2; mnt[k] = $3
  }
  END {
    if (bad > 0) printf "warning: skipped %d malformed line(s)\n", bad > "/dev/stderr"
    for (k in n) {
      if (n[k] < 3) { print "999999|" host[k] "|" mnt[k] "|-|-|-|-|NODATA"; continue }
      sx = sy = sxy = sxx = 0
      for (i = 1; i <= n[k]; i++) {
        x = xs[k, i] - first[k]; y = ys[k, i]
        sx += x; sy += y; sxy += x * y; sxx += x * x
      }
      den = n[k] * sxx - sx * sx
      slope = (den == 0) ? 0 : (n[k] * sxy - sx * sy) / den
      pct = used[k] * 100 / total[k]
      left = "-"; full = "-"; rank = 900000
      if (slope > 0) {
        left = (total[k] <= used[k]) ? 0 : int((total[k] - used[k]) / slope)
        full = civil(last[k] + left)
        rank = left
      }
      st = "OK"
      if (slope > 0 && left <= warn) st = "WARN"
      if (slope > 0 && left <= crit) st = "CRIT"
      if (pct >= 95) { st = "CRIT"; if (slope <= 0) rank = -1 }
      printf "%d|%s|%s|%.1f|%.2f|%s|%s|%s\n", rank, host[k], mnt[k], pct, slope, left, full, st
    }
  }' "$file" | sort -t'|' -k1,1n -k2,2 -k3,3)

if [[ -z $rows ]]; then
  echo "error: no usable samples in $file" >&2
  exit 3
fi

printf '%-8s %-8s %6s %8s %9s  %-10s  %s\n' HOST MOUNT 'USED%' GB/DAY DAYS_LEFT FULL_ON STATUS
awk -F'|' '{ printf "%-8s %-8s %6s %8s %9s  %-10s  %s\n", $2, $3, $4, $5, $6, $7, $8 }' <<< "$rows"

read -r c w o d < <(awk -F'|' '{ s[$8]++ } END { print s["CRIT"] + 0, s["WARN"] + 0, s["OK"] + 0, s["NODATA"] + 0 }' <<< "$rows")
echo "summary: $c crit, $w warn, $o ok, $d nodata"
if (( c > 0 )); then exit 2; fi
if (( w > 0 )); then exit 1; fi
