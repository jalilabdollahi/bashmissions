#!/usr/bin/env bash
# Feature flags: parse a config file into maps, then evaluate ordered rules.
set -euo pipefail

usage() {
  echo "usage: solution.sh FLAGS check FLAG USER [ENV] | list USER [ENV] | validate" >&2
  exit 2
}

[[ $# -ge 2 ]] || usage
file=$1
mode=$2
shift 2
[[ -r $file ]] || { echo "cannot read $file" >&2; exit 2; }

declare -A fstate frollout fallow fdeny fenv
order=()
problems=0

trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  printf '%s' "$s"
}

problem() {
  echo "$file:$1: $2" >&2
  problems=$((problems + 1))
}

# load_flags: fills the arrays; reports each bad line once.
load_flags() {
  local n=0 line name rest state opt key val rollout
  local allow deny env
  while IFS= read -r line || [[ -n $line ]]; do
    n=$((n + 1))
    line=$(trim "$line")
    [[ -z $line || $line == \#* ]] && continue
    if [[ $line != *=* ]]; then
      problem "$n" "expected NAME = STATE"
      continue
    fi
    name=$(trim "${line%%=*}")
    rest=$(trim "${line#*=}")
    if [[ ! $name =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
      problem "$n" "bad flag name '$name'"
      continue
    fi
    read -r state rest <<< "$rest"
    if [[ $state != on && $state != off ]]; then
      problem "$n" "state must be on or off"
      continue
    fi
    rollout=100 allow= deny= env=
    local bad=0
    for opt in $rest; do
      key=${opt%%=*}
      val=${opt#*=}
      case $key in
        rollout)
          if [[ $opt != *=* ]] || [[ ! $val =~ ^[0-9]+$ ]] || (( 10#$val > 100 )); then
            problem "$n" "rollout must be 0-100"; bad=1; break
          fi
          rollout=$((10#$val)) ;;
        allow) allow=",$val," ;;
        deny)  deny=",$val," ;;
        env)   env=",$val," ;;
        *) problem "$n" "unknown option '$key'"; bad=1; break ;;
      esac
    done
    (( bad )) && continue
    if [[ -n ${fstate[$name]:-} ]]; then
      problem "$n" "duplicate flag '$name'"
      continue
    fi
    fstate[$name]=$state
    frollout[$name]=$rollout
    fallow[$name]=$allow
    fdeny[$name]=$deny
    fenv[$name]=$env
    order+=("$name")
  done < "$file"
}

# decide FLAG USER ENV -> sets $decision (on|off) and $reason
decide() {
  local flag=$1 user=$2 env=$3 sum _size bucket
  if [[ ${fstate[$flag]} == off ]]; then
    decision=off reason="kill switch"
  elif [[ ${fdeny[$flag]} == *",$user,"* ]]; then
    decision=off reason="denied"
  elif [[ -n ${fenv[$flag]} && ${fenv[$flag]} != *",$env,"* ]]; then
    decision=off reason="not enabled in $env"
  elif [[ ${fallow[$flag]} == *",$user,"* ]]; then
    decision=on reason="allow list"
  elif (( frollout[$flag] == 100 )); then
    decision=on reason="fully on"
  else
    read -r sum _size < <(printf '%s' "$flag:$user" | cksum)
    bucket=$((sum % 100))
    reason="rollout ${frollout[$flag]}%, bucket $bucket"
    if (( bucket < frollout[$flag] )); then decision=on; else decision=off; fi
  fi
}

load_flags

case $mode in
  validate)
    [[ $# -eq 0 ]] || usage
    (( problems == 0 )) || exit 1
    echo "OK: ${#order[@]} flags"
    exit 0
    ;;
  check|list) ;;
  *) usage ;;
esac
(( problems == 0 )) || exit 3

if [[ $mode == check ]]; then
  [[ $# -eq 2 || $# -eq 3 ]] || usage
  flag=$1 user=$2 env=${3:-prod}
  if [[ -z ${fstate[$flag]:-} ]]; then
    echo "unknown flag $flag" >&2
    exit 2
  fi
  decide "$flag" "$user" "$env"
  echo "$flag for $user: $decision ($reason)"
  [[ $decision == on ]]
else
  [[ $# -eq 1 || $# -eq 2 ]] || usage
  user=$1 env=${2:-prod}
  for flag in "${order[@]}"; do
    decide "$flag" "$user" "$env"
    printf '%-14s %s\n' "$flag" "$decision"
  done
fi
