#!/usr/bin/env bash
set -euo pipefail

# Both regexes share this prefix: "Nov  7 09:30:15 anchovy sshd[2211]: "
#   [A-Z][a-z]{2} +[0-9]{1,2}   month and day (padding may be spaces)
#   ([0-9:]{8})                 group 1: the time
#   [^ ]+ sshd\[[0-9]+\]:       host and process, not captured
# Failed: groups  1 time, 2 "invalid user " (optional, may be empty), 3 user, 4 addr
failed_re='^[A-Z][a-z]{2} +[0-9]{1,2} ([0-9]{2}:[0-9]{2}:[0-9]{2}) [^ ]+ sshd\[[0-9]+\]: Failed password for (invalid user )?([^ ]+) from ([0-9.]+) port [0-9]+ ssh2$'
# Accepted: groups 1 time, 2 method, 3 user, 4 addr
accepted_re='^[A-Z][a-z]{2} +[0-9]{1,2} ([0-9]{2}:[0-9]{2}:[0-9]{2}) [^ ]+ sshd\[[0-9]+\]: Accepted (password|publickey) for ([^ ]+) from ([0-9.]+) port [0-9]+ ssh2$'

declare -A failures=() last_user=() last_time=() alert_user=()

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $failed_re ]]; then
    # Group 2 is the optional one: it is empty when absent, but the numbering stays put.
    addr=${BASH_REMATCH[4]}
    failures[$addr]=$(( ${failures[$addr]:-0} + 1 ))
    last_user[$addr]=${BASH_REMATCH[3]}
    last_time[$addr]=${BASH_REMATCH[1]}
  elif [[ $line =~ $accepted_re ]]; then
    addr=${BASH_REMATCH[4]}
    # Only a login that happens when the IP already has 3+ failures is suspicious.
    if (( ${failures[$addr]:-0} >= 3 )); then
      alert_user[$addr]=${BASH_REMATCH[3]}
    fi
  fi
done

# Collect the offenders, then sort them so the report order is stable.
offenders=()
for addr in "${!failures[@]}"; do
  if (( failures[$addr] >= 3 )); then
    offenders+=("$addr")
  fi
done

if (( ${#offenders[@]} > 0 )); then
  while IFS= read -r addr; do
    echo "BLOCK $addr failures=${failures[$addr]} last-user=${last_user[$addr]} last-seen=${last_time[$addr]}"
    if [[ -n ${alert_user[$addr]:-} ]]; then
      echo "ALERT $addr logged in as ${alert_user[$addr]} after 3+ failures"
    fi
  done < <(printf '%s\n' "${offenders[@]}" | sort)
fi
