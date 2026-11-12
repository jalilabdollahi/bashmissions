#!/usr/bin/env bash
# Cron analyzer: expand crontab fields for one day and find jobs that run at the same time.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--min-shared N] MONTH DOM DOW CRONTAB" >&2
  exit 2
}

min=1
if [[ ${1:-} == --min-shared ]]; then
  [[ ${2:-} =~ ^[1-9][0-9]*$ ]] || usage
  min=$2
  shift 2
fi
[[ $# -eq 4 ]] || usage
month=$1 dom=$2 dow=$3 tab=$4

check_day() {  # NAME VALUE LO HI
  if [[ ! $2 =~ ^[0-9]+$ ]] || (( $2 < $3 || $2 > $4 )); then
    echo "error: bad day '$2'" >&2
    exit 2
  fi
}
check_day month "$month" 1 12
check_day dom "$dom" 1 31
check_day dow "$dow" 0 6
if [[ ! -r $tab ]]; then
  echo "error: cannot read $tab" >&2
  exit 2
fi

# awk prints rows tagged "T|" (job table) or "O|KEY|ORDER|TEXT" (overlaps).
out=$(awk -v month="$month" -v dom="$dom" -v dow="$dow" -v min="$min" '
  # expand FIELD LO HI SET: fill SET with the numbers the field selects, return 0 if invalid.
  function expand(f, lo, hi, set,   n, parts, i, p, step, a, b, x, ab, slash) {
    split("", set)
    n = split(f, parts, ",")
    for (i = 1; i <= n; i++) {
      p = parts[i]; step = 1
      slash = index(p, "/")
      if (slash) {
        step = substr(p, slash + 1); p = substr(p, 1, slash - 1)
        if (step !~ /^[0-9]+$/ || step + 0 < 1) return 0
      }
      if (p == "*") { a = lo; b = hi }
      else if (p ~ /^[0-9]+$/ && !slash) { a = p + 0; b = a }
      else if (p ~ /^[0-9]+-[0-9]+$/) { split(p, ab, "-"); a = ab[1] + 0; b = ab[2] + 0 }
      else return 0
      if (a < lo || b > hi || a > b) return 0
      for (x = a; x <= b; x += step) set[x] = 1
    }
    return 1
  }
  function hhmm(t) { return sprintf("%02d:%02d", int(t / 60), t % 60) }

  { lineno = NR }
  /^[ \t]*$/ || /^[ \t]*#/ { next }
  /^[A-Za-z_][A-Za-z0-9_]*=/ { next }
  /^@reboot/ { next }
  {
    line = $0
    run = 1
    if (match(line, /#[ \t]*runs[ \t]+[0-9]+[mh][ \t]*$/)) {
      r = substr(line, RSTART, RLENGTH)
      gsub(/[^0-9mh]/, "", r)          # e.g. 25m
      run = substr(r, 1, length(r) - 1) + 0
      if (substr(r, length(r)) == "h") run *= 60
      line = substr(line, 1, RSTART - 1)
    }
    sub(/[ \t]+$/, "", line)
    nf = split(line, w, /[ \t]+/)
    if (w[1] ~ /^@/) {
      alias = w[1]
      if (alias == "@hourly") spec = "0 * * * *"
      else if (alias == "@daily" || alias == "@midnight") spec = "0 0 * * *"
      else if (alias == "@weekly") spec = "0 0 * * 0"
      else if (alias == "@monthly") spec = "0 0 1 * *"
      else if (alias == "@yearly" || alias == "@annually") spec = "0 0 1 1 *"
      else { printf "warning: line %d skipped: bad minute field\n", lineno > "/dev/stderr"; next }
      split(spec, f, " ")
      cmd = ""
      for (i = 2; i <= nf; i++) cmd = cmd (i > 2 ? " " : "") w[i]
      if (nf < 2) { printf "warning: line %d skipped: too few fields\n", lineno > "/dev/stderr"; next }
    } else {
      if (nf < 6) { printf "warning: line %d skipped: too few fields\n", lineno > "/dev/stderr"; next }
      for (i = 1; i <= 5; i++) f[i] = w[i]
      cmd = w[6]
    }
    if (!expand(f[1], 0, 59, mins)) { printf "warning: line %d skipped: bad minute field\n", lineno > "/dev/stderr"; next }
    if (!expand(f[2], 0, 23, hrs)) { printf "warning: line %d skipped: bad hour field\n", lineno > "/dev/stderr"; next }
    if (!expand(f[3], 1, 31, doms)) { printf "warning: line %d skipped: bad day-of-month field\n", lineno > "/dev/stderr"; next }
    if (!expand(f[4], 1, 12, mons)) { printf "warning: line %d skipped: bad month field\n", lineno > "/dev/stderr"; next }
    if (!expand(f[5], 0, 7, dows)) { printf "warning: line %d skipped: bad day-of-week field\n", lineno > "/dev/stderr"; next }
    if (7 in dows) dows[0] = 1

    j = ++njobs
    nm = w[(w[1] ~ /^@/) ? 2 : 6]
    k = split(nm, seg, "/"); nm = seg[k]
    seen[nm]++
    name[j] = (seen[nm] > 1) ? nm "#" seen[nm] : nm
    runlen[j] = run

    domstar = (substr(f[3], 1, 1) == "*"); dowstar = (substr(f[5], 1, 1) == "*")
    d_ok = (dom in doms); w_ok = (dow in dows)
    day_ok = (domstar || dowstar) ? (d_ok && w_ok) : (d_ok || w_ok)
    runs_today = (month in mons) && day_ok
    starts[j] = 0; first[j] = -1; last[j] = -1
    if (runs_today) {
      for (h = 0; h <= 23; h++) {
        if (!(h in hrs)) continue
        for (m = 0; m <= 59; m++) {
          if (!(m in mins)) continue
          s = h * 60 + m
          starts[j]++
          if (first[j] < 0) first[j] = s
          last[j] = s
          for (t = s; t < s + run && t < 1440; t++) occ[j, t]++
        }
      }
    }
  }
  END {
    print "T|== Jobs on " month "-" dom " (weekday " dow ") =="
    printf "T|%-3s %-12s %6s %-5s %-5s %4s\n", "ID", "NAME", "STARTS", "FIRST", "LAST", "RUN"
    for (j = 1; j <= njobs; j++)
      printf "T|%-3d %-12s %6d %-5s %-5s %4s\n", j, name[j], starts[j],
        (first[j] < 0 ? "-" : hhmm(first[j])), (last[j] < 0 ? "-" : hhmm(last[j])), runlen[j] "m"
    for (t = 0; t < 1440; t++) {
      for (a = 1; a <= njobs; a++) {
        if (occ[a, t] == 0) continue
        if (occ[a, t] > 1) { self[a]++; if (!(a in selfat)) selfat[a] = t }
        for (b = a + 1; b <= njobs; b++) {
          if (occ[b, t] == 0) continue
          key = a SUBSEP b
          shared[key]++
          if (!(key in firstat)) firstat[key] = t
        }
      }
    }
    for (a = 1; a <= njobs; a++)
      if (self[a] >= min)
        printf "O|%06d|%03d%03d|%s x %s: %d minutes running twice, first at %s\n", 100000 - self[a], a, a, name[a], name[a], self[a], hhmm(selfat[a])
    for (key in shared) {
      split(key, ab, SUBSEP)
      if (shared[key] >= min)
        printf "O|%06d|%03d%03d|%s x %s: %d shared minutes, first at %s\n", 100000 - shared[key], ab[1], ab[2], name[ab[1]], name[ab[2]], shared[key], hhmm(firstat[key])
    }
  }' "$tab")

printf '%s\n' "$out" | sed -n 's/^T|//p'
echo "== Overlaps =="
overlaps=$(printf '%s\n' "$out" | sed -n 's/^O|//p' | sort -t'|' -k1,1n -k2,2n | cut -d'|' -f3-)
if [[ -z $overlaps ]]; then
  echo "(none)"
else
  printf '%s\n' "$overlaps"
  exit 1
fi
