#!/usr/bin/env bash
# lantern: the Lanternfish operations CLI. One command, small shared functions:
# health probes, backup verification, a one-page report, and a gated handover.
set -euo pipefail

usage() {
  echo "usage: solution.sh version | health [SERVICES] | backups TODAY [DIR] | report TODAY | handover TODAY PERSON" >&2
  exit 2
}

# --- calendar: no `date -d`, everything is integer maths ---------------------------
valid_date() {   # YYYYMMDD -> success if it is a real calendar date
  local s=$1 y m d dim
  [[ $s =~ ^[0-9]{8}$ ]] || return 1
  y=$((10#${s:0:4})) m=$((10#${s:4:2})) d=$((10#${s:6:2}))
  (( y >= 1 && m >= 1 && m <= 12 && d >= 1 )) || return 1
  case $m in
    1|3|5|7|8|10|12) dim=31 ;;
    4|6|9|11) dim=30 ;;
    2) if (( y % 4 == 0 && (y % 100 != 0 || y % 400 == 0) )); then dim=29; else dim=28; fi ;;
  esac
  (( d <= dim ))
}

# days_of YYYYMMDD -> sets DAYS (days since 1970-01-01), "days from civil"
days_of() {
  local s=$1 y m d era yoe mp doy doe
  y=$((10#${s:0:4})) m=$((10#${s:4:2})) d=$((10#${s:6:2}))
  (( m <= 2 )) && y=$((y - 1))
  era=$(( (y >= 0 ? y : y - 399) / 400 ))
  yoe=$((y - era * 400))
  mp=$(( m > 2 ? m - 3 : m + 9 ))
  doy=$(( (153 * mp + 2) / 5 + d - 1 ))
  doe=$(( yoe * 365 + yoe / 4 - yoe / 100 + doy ))
  DAYS=$(( era * 146097 + doe - 719468 ))
}

pretty() { echo "${1:0:4}-${1:4:2}-${1:6:2}"; }

# --- health -------------------------------------------------------------------------
h_ok=0 h_warn=0 h_down=0
# do_health FILE: prints one line per service and sets the counters
do_health() {
  local file=$1 name url code label
  h_ok=0 h_warn=0 h_down=0
  while read -r name url _; do
    [[ -z $name || $name == \#* ]] && continue
    code=$(curl -s -o /dev/null -w '%{http_code}' "$url" 2> /dev/null) || true
    [[ $code =~ ^[0-9]{3}$ ]] || code=000
    case $code in
      2??) label=ok;   h_ok=$((h_ok + 1)) ;;
      3??|4??) label=WARN; h_warn=$((h_warn + 1)) ;;
      *)   label=DOWN; h_down=$((h_down + 1)) ;;
    esac
    printf '%-8s %s %s\n' "$name" "$code" "$label"
  done < "$file"
}

# --- backups ------------------------------------------------------------------------
b_ok=0 b_problems=0 b_corrupt=0 b_stale=0 b_nosum=0 b_found=0
# do_backups TODAY DIR: prints one line per backup name and sets the counters
do_backups() {
  local today=$1 dir=$2 f base name date status age tdays
  local -A newest=()
  b_ok=0 b_problems=0 b_corrupt=0 b_stale=0 b_nosum=0 b_found=0
  for f in "$dir"/*.bak; do
    [[ -f $f ]] || continue
    base=${f##*/}
    [[ $base =~ ^(.+)-([0-9]{8})\.bak$ ]] || continue
    name=${BASH_REMATCH[1]} date=${BASH_REMATCH[2]}
    valid_date "$date" || continue
    if [[ -z ${newest[$name]:-} || $date > ${newest[$name]} ]]; then newest[$name]=$date; fi
  done
  (( ${#newest[@]} > 0 )) || return 0
  b_found=${#newest[@]}
  days_of "$today"; tdays=$DAYS
  local max_age=${MAX_AGE:-7}
  for name in $(printf '%s\n' "${!newest[@]}" | LC_ALL=C sort); do
    date=${newest[$name]}
    f=$dir/$name-$date.bak
    days_of "$date"
    age=$((tdays - DAYS))
    if [[ -f $f.sum ]]; then
      local a b
      read -r a b < "$f.sum" || true
      if [[ "$a $b" != "$(cksum < "$f")" ]]; then status=CORRUPT; b_corrupt=$((b_corrupt + 1)); fi
    else
      status=NOSUM; b_nosum=$((b_nosum + 1))
    fi
    if [[ -z ${status:-} ]]; then
      if (( age > max_age )); then status=STALE; b_stale=$((b_stale + 1)); else status=ok; fi
    fi
    if [[ $status == ok ]]; then b_ok=$((b_ok + 1)); else b_problems=$((b_problems + 1)); fi
    printf '%-10s %s age %dd %s\n' "$name" "$(pretty "$date")" "$age" "$status"
    status=
  done
}

# --- report ---------------------------------------------------------------------------
verdict=
# do_report TODAY: prints the whole page and sets $verdict
do_report() {
  local today=$1 red=0 amber=0
  echo "LANTERN STATUS $(pretty "$today")"
  echo "-- services --"
  if [[ -r services.conf ]]; then
    do_health services.conf
    (( h_down > 0 )) && red=1
    (( h_warn > 0 )) && amber=1
  else
    echo "cannot read services.conf"
    red=1
  fi
  echo "-- backups --"
  do_backups "$today" backups
  if (( b_found == 0 )); then
    echo "no backups found in backups"
    red=1
  fi
  (( b_corrupt > 0 || b_stale > 0 )) && red=1
  (( b_nosum > 0 )) && amber=1
  echo "-- verdict --"
  if (( red )); then verdict=RED
  elif (( amber )); then verdict=AMBER
  else verdict=GREEN; fi
  echo "$verdict"
}

verdict_status() {
  case $1 in GREEN) return 0 ;; AMBER) return 1 ;; *) return 3 ;; esac
}

[[ $# -ge 1 ]] || usage
cmd=$1
shift
case $cmd in
  version)
    [[ $# -eq 0 ]] || usage
    echo "lantern 1.0.0"
    ;;
  health)
    [[ $# -le 1 ]] || usage
    services=${1:-services.conf}
    [[ -r $services ]] || { echo "cannot read $services" >&2; exit 2; }
    do_health "$services"
    echo "health: $h_ok ok, $h_warn warn, $h_down down"
    (( h_down == 0 ))
    ;;
  backups)
    [[ $# -ge 1 && $# -le 2 ]] || usage
    valid_date "$1" || usage
    dir=${2:-backups}
    max=${MAX_AGE:-7}
    [[ $max =~ ^[0-9]+$ ]] || { echo "invalid MAX_AGE" >&2; exit 2; }
    do_backups "$1" "$dir"
    if (( b_found == 0 )); then
      echo "no backups found in $dir" >&2
      exit 1
    fi
    echo "backups: $b_ok ok, $b_problems problems"
    (( b_problems == 0 ))
    ;;
  report)
    [[ $# -eq 1 ]] && valid_date "$1" || usage
    do_report "$1"
    verdict_status "$verdict"
    ;;
  handover)
    [[ $# -eq 2 ]] && valid_date "$1" && [[ $2 =~ ^[a-z]+$ ]] || usage
    today=$1 person=$2
    do_report "$today" > /dev/null || true
    if [[ $verdict != GREEN ]]; then
      echo "refusing handover: status is $verdict" >&2
      exit 3
    fi
    old=nobody
    if [[ -r oncall.txt ]]; then
      read -r old _ < oncall.txt || true
      [[ -n $old ]] || old=nobody
    fi
    if [[ $old == "$person" ]]; then
      echo "$person is already on call" >&2
      exit 1
    fi
    echo "$person since $today" > oncall.txt
    echo "$today $old -> $person" >> handover.log
    echo "pager handed over: $old -> $person"
    echo "Good luck, $person. The lantern is yours."
    ;;
  *) usage ;;
esac
