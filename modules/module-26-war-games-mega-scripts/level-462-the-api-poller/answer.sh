#!/usr/bin/env bash
# API poller: debounce status changes, fire webhooks, never lose an alert.
set -euo pipefail

usage() {
  echo "usage: solution.sh --webhook URL [--confirm N] ENDPOINTS" >&2
  exit 2
}

webhook=
confirm=2
while (( $# > 0 )); do
  case $1 in
    --webhook)
      [[ -n ${2:-} ]] || usage
      webhook=$2
      shift 2
      ;;
    --confirm)
      if [[ ! ${2:-} =~ ^[1-9][0-9]*$ ]]; then
        echo "error: --confirm needs a positive whole number" >&2
        exit 2
      fi
      confirm=$2
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ -n $webhook && $# -eq 1 ]] || usage
endpoints=$1
if [[ ! -r $endpoints ]]; then
  echo "error: cannot read $endpoints" >&2
  exit 2
fi

mkdir -p state
outbox=state/outbox

post() {
  curl -sS --fail --max-time 5 -X POST -H 'Content-Type: application/json' \
    -d "$1" "$webhook" > /dev/null 2>&1
}

# flush_outbox: retry queued alerts, keep the ones that still fail.
flush_outbox() {
  [[ -s $outbox ]] || return 0
  local sent=0 kept=0 line tmp=$outbox.new
  : > "$tmp"
  while IFS= read -r line; do
    if post "$line"; then
      sent=$((sent + 1))
    else
      kept=$((kept + 1))
      printf '%s\n' "$line" >> "$tmp"
    fi
  done < "$outbox"
  mv "$tmp" "$outbox"
  echo "outbox: sent $sent, $kept still queued"
}

# notify NAME FROM TO: sets $delivery to "sent" or "queued".
delivery=
notify() {
  local body
  body=$(printf '{"service":"%s","from":"%s","to":"%s"}' "$1" "$2" "$3")
  if post "$body"; then
    delivery=sent
  else
    printf '%s\n' "$body" >> "$outbox"
    delivery=queued
  fi
}

# fetch_status URL: ok | degraded | down | unreachable | invalid
fetch_status() {
  local body status
  if ! body=$(curl -sS --fail --max-time 5 "$1" 2> /dev/null); then
    echo unreachable
    return 0
  fi
  status=$(printf '%s' "$body" | tr -d '\n' |
    sed -n -E 's/.*"status"[[:space:]]*:[[:space:]]*"([a-z]+)".*/\1/p')
  case $status in
    ok | degraded | down) echo "$status" ;;
    *) echo invalid ;;
  esac
}

flush_outbox

worst=0
while IFS='|' read -r name url; do
  [[ -z $name || $name == \#* ]] && continue
  reading=$(fetch_status "$url")
  confirmed=unknown
  cand=-
  count=0
  if [[ -f state/$name.state ]]; then
    read -r confirmed cand count < "state/$name.state"
  fi

  if [[ $confirmed == unknown ]]; then
    confirmed=$reading
    if [[ $reading == ok ]]; then
      echo "$name: $reading (first reading)"
    else
      notify "$name" unknown "$reading"
      echo "$name: $reading (first reading, webhook $delivery)"
    fi
    cand=-
    count=0
  elif [[ $reading == "$confirmed" ]]; then
    echo "$name: $reading"
    cand=-
    count=0
  else
    if [[ $reading == "$cand" ]]; then
      count=$((count + 1))
    else
      cand=$reading
      count=1
    fi
    if (( count >= confirm )); then
      notify "$name" "$confirmed" "$reading"
      echo "$name: $confirmed -> $reading (webhook $delivery)"
      confirmed=$reading
      cand=-
      count=0
    else
      echo "$name: $confirmed (saw $reading, pending $count/$confirm)"
    fi
  fi
  echo "$confirmed $cand $count" > "state/$name.state"
  [[ $confirmed == ok ]] || worst=1
done < "$endpoints"
exit "$worst"
