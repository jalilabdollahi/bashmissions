#!/usr/bin/env bash
set -euo pipefail

usage="usage: solution.sh [-f] [-m PCT] HOSTSDIR"
only_failures=0
minimum=100
while getopts "fm:" opt; do
  case $opt in
    f) only_failures=1 ;;
    m) minimum=$OPTARG ;;
    *) echo "$usage" >&2; exit 2 ;;
  esac
done
shift $(( OPTIND - 1 ))

if [[ ! $minimum =~ ^[0-9]+$ ]] || (( minimum > 100 )); then
  echo "bad minimum: $minimum" >&2
  exit 2
fi
if [[ $# -ne 1 ]]; then
  echo "$usage" >&2
  exit 2
fi
root=$1
if [[ ! -d $root ]]; then
  echo "no such directory: $root" >&2
  exit 1
fi

# Each check takes the host folder and succeeds when the host is compliant.
check_root_login() {
  [[ -f $1/sshd_config ]] || return 1
  local value
  value=$(awk 'tolower($1) == "permitrootlogin" { print tolower($2); exit }' "$1/sshd_config")
  [[ $value == no ]]
}
check_disk() {
  [[ -f $1/df.txt ]] || return 1
  # Skip the header; "97%" + 0 turns the text into the number 97.
  ! awk 'NR > 1 && ($5 + 0) >= 90 { bad = 1 } END { exit !bad }' "$1/df.txt"
}
check_time_sync() {
  [[ -f $1/services.txt ]] && grep -qx 'chronyd active' "$1/services.txt"
}
check_reboot() {
  [[ ! -e $1/reboot-required ]]
}

names=(root-login-disabled disk-under-90 time-sync no-pending-reboot)
funcs=(check_root_login check_disk check_time_sync check_reboot)

hosts=0 passed=0 total=0
for host_dir in "$root"/*/; do
  [[ -d $host_dir ]] || continue
  host_dir=${host_dir%/}
  hosts=$(( hosts + 1 ))

  results=()
  host_pass=0
  for i in "${!funcs[@]}"; do
    if "${funcs[i]}" "$host_dir"; then
      results+=("PASS")
      host_pass=$(( host_pass + 1 ))
    else
      results+=("FAIL")
    fi
  done

  echo "${host_dir##*/}: $host_pass/${#funcs[@]}"
  for i in "${!names[@]}"; do
    if (( only_failures )) && [[ ${results[i]} == PASS ]]; then continue; fi
    echo "  [${results[i]}] ${names[i]}"
  done
  passed=$(( passed + host_pass ))
  total=$(( total + ${#funcs[@]} ))
done

if (( hosts == 0 )); then
  echo "no hosts in $root" >&2
  exit 1
fi

percent=$(( passed * 100 / total ))
echo "fleet: $passed/$total checks passed ($percent%)"
if (( percent >= minimum )); then
  echo "result: PASS"
else
  echo "result: FAIL (need $minimum%)"
  exit 1
fi
