#!/usr/bin/env bash
# Service health dashboard: every check in parallel, one screen, deterministic order.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--color] [--problems-only] CONFIG" >&2
  exit 2
}

color=0 problems=0
while (( $# > 0 )); do
  case $1 in
    --color) color=1; shift ;;
    --problems-only) problems=1; shift ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 1 ]] || usage
config=$1
if [[ ! -r $config ]]; then
  echo "error: cannot read $config" >&2
  exit 2
fi

# Load and validate the whole config before running a single check.
g_of=() n_of=() t_of=() a_of=() r_of=()
lineno=0
while IFS='|' read -r group name type target arg; do
  lineno=$((lineno + 1))
  [[ -z ${group// /} || $group == \#* ]] && continue
  if [[ -z $group || -z $name || -z $type || -z $target || -z $arg ]]; then
    echo "error: $config line $lineno: need GROUP|NAME|TYPE|TARGET|ARG" >&2
    exit 3
  fi
  case $type in
    http | tcp | file | disk) ;;
    *)
      echo "error: $config line $lineno: unknown type '$type'" >&2
      exit 3
      ;;
  esac
  g_of+=("$group") n_of+=("$name") t_of+=("$type") a_of+=("$arg") r_of+=("$target")
done < "$config"

check_http() {
  local code
  code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 3 "$1" 2> /dev/null) || code=000
  if [[ $code == "$2" ]]; then echo "UP|HTTP $code"
  elif [[ $code == 000 ]]; then echo "DOWN|no response"
  elif (( 10#$code >= 500 )); then echo "DOWN|HTTP $code"
  else echo "DEGRADED|HTTP $code (want $2)"
  fi
}
check_tcp() {
  if nc -z -w 2 "${1%:*}" "${1##*:}" > /dev/null 2>&1; then echo "UP|port open"
  else echo "DOWN|connection refused"
  fi
}
check_file() {
  if [[ ! -e $1 ]]; then echo "DOWN|missing"
  elif [[ -n $(find "$1" -mmin "-$2") ]]; then echo "UP|fresh (<= $2 min)"
  else echo "DOWN|stale (> $2 min)"
  fi
}
check_disk() {
  local pct
  pct=$(df -P "$1" | awk 'NR == 2 { gsub("%", "", $5); print $5 }')
  if (( pct >= $2 )); then echo "DOWN|$pct% used"
  elif (( pct >= $2 - 10 )); then echo "DEGRADED|$pct% used"
  else echo "UP|$pct% used"
  fi
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for i in "${!n_of[@]}"; do
  (
    case ${t_of[i]} in
      http) check_http "${r_of[i]}" "${a_of[i]}" ;;
      tcp) check_tcp "${r_of[i]}" ;;
      file) check_file "${r_of[i]}" "${a_of[i]}" ;;
      disk) check_disk "${r_of[i]}" "${a_of[i]}" ;;
    esac > "$work/$i"
  ) &
done
wait

paint() {  # STATE -> padded, optionally coloured word
  local pad
  pad=$(printf '%-8s' "$1")
  if (( color )); then
    case $1 in
      UP) printf '\033[32m%s\033[0m' "$pad" ;;
      DEGRADED) printf '\033[33m%s\033[0m' "$pad" ;;
      *) printf '\033[31m%s\033[0m' "$pad" ;;
    esac
  else
    printf '%s' "$pad"
  fi
}

states=() details=()
for i in "${!n_of[@]}"; do
  IFS='|' read -r s d < "$work/$i"
  states[i]=$s
  details[i]=$d
done

# Group names may contain spaces, so track membership with a separator that cannot.
groups=()
declare -A seen
for g in "${g_of[@]}"; do
  [[ -z ${seen[$g]:-} ]] || continue
  seen[$g]=1
  groups+=("$g")
done

echo "== Lanternfish Status Board =="
up=0 degraded=0 down=0 crit_down=0
for g in "${groups[@]}"; do
  total=0 gup=0
  for i in "${!n_of[@]}"; do
    [[ ${g_of[i]} == "$g" ]] || continue
    total=$((total + 1))
    [[ ${states[i]} != UP ]] || gup=$((gup + 1))
  done
  if (( problems && gup == total )); then
    continue
  fi
  echo "== $g == [$gup/$total up]"
  for i in "${!n_of[@]}"; do
    [[ ${g_of[i]} == "$g" ]] || continue
    if (( problems )) && [[ ${states[i]} == UP ]]; then continue; fi
    printf '  %s %-14s %s\n' "$(paint "${states[i]}")" "${n_of[i]}" "${details[i]}"
  done
done

for i in "${!n_of[@]}"; do
  case ${states[i]} in
    UP) up=$((up + 1)) ;;
    DEGRADED) degraded=$((degraded + 1)) ;;
    DOWN)
      down=$((down + 1))
      [[ ${n_of[i]} != *! ]] || crit_down=$((crit_down + 1))
      ;;
  esac
done
if (( crit_down > 0 )); then overall=DOWN
elif (( down + degraded > 0 )); then overall=DEGRADED
else overall=UP
fi
echo "overall: $overall ($down down, $degraded degraded, $up up)"
case $overall in UP) exit 0 ;; DEGRADED) exit 1 ;; *) exit 2 ;; esac
