#!/usr/bin/env bash
# Certificate watchdog: classify, optionally renew within a limit, reload once.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--warn DAYS] [--crit DAYS] [--renew] [--max-renewals N] CERTDIR" >&2
  exit 64
}

warn=30 crit=7 renew=0 max=3
while (( $# > 0 )); do
  case $1 in
    --warn | --crit)
      if [[ ! ${2:-} =~ ^[0-9]+$ ]]; then
        echo "error: $1 needs a whole number of days" >&2
        exit 64
      fi
      if [[ $1 == --warn ]]; then warn=$2; else crit=$2; fi
      shift 2
      ;;
    --max-renewals)
      if [[ ! ${2:-} =~ ^[1-9][0-9]*$ ]]; then
        echo "error: --max-renewals needs a positive whole number" >&2
        exit 64
      fi
      max=$2
      shift 2
      ;;
    --renew) renew=1; shift ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 1 ]] || usage
dir=${1%/}
if (( crit > warn )); then
  echo "error: --crit must not exceed --warn" >&2
  exit 64
fi
if [[ ! -d $1 ]]; then
  echo "error: $1 is not a directory" >&2
  exit 64
fi
certs=("$dir"/*.pem)
if [[ ! -e ${certs[0]} ]]; then
  echo "error: no certificates in $1" >&2
  exit 64
fi

# inspect FILE: sets $status and $expires.
inspect() {
  local f=$1 end
  if ! end=$(openssl x509 -noout -enddate -in "$f" 2> /dev/null); then
    status=INVALID
    expires=-
    return 0
  fi
  expires=${end#notAfter=}
  if ! openssl x509 -noout -checkend 0 -in "$f" > /dev/null 2>&1; then
    status=EXPIRED
  elif ! openssl x509 -noout -checkend $((crit * 86400)) -in "$f" > /dev/null 2>&1; then
    status=CRIT
  elif ! openssl x509 -noout -checkend $((warn * 86400)) -in "$f" > /dev/null 2>&1; then
    status=WARN
  else
    status=OK
  fi
}

declare -A count=([OK]=0 [WARN]=0 [CRIT]=0 [EXPIRED]=0 [INVALID]=0)
rows=()
attempts=0
renewed_any=0
status= expires=
for f in "${certs[@]}"; do
  name=${f##*/}
  name=${name%.pem}
  inspect "$f"
  note=
  if (( renew )) && [[ $status == WARN || $status == CRIT || $status == EXPIRED ]]; then
    if (( attempts >= max )); then
      note="renew skipped"
    else
      attempts=$((attempts + 1))
      if certbot renew --cert-name "$name" --config-dir "$dir" > /dev/null 2>&1; then
        inspect "$f"
        note=renewed
        renewed_any=1
      else
        note="renew failed"
      fi
    fi
  fi
  count[$status]=$((count[$status] + 1))
  rows+=("$(printf '%-14s %-8s %-30s %s' "$name" "$status" "$expires" "$note")")
done

printf '%-14s %-8s %-30s %s\n' NAME STATUS EXPIRES NOTE
printf '%s\n' "${rows[@]}"

# One reload, after all renewals, and only if something actually changed.
if (( renewed_any )); then
  if systemctl reload nginx > /dev/null 2>&1; then
    echo "reload: nginx reloaded"
  else
    echo "reload: nginx reload FAILED"
    echo "warning: nginx reload failed" >&2
  fi
fi
echo "summary: ${count[OK]} ok, ${count[WARN]} warn, ${count[CRIT]} crit, ${count[EXPIRED]} expired, ${count[INVALID]} invalid"

if (( count[CRIT] + count[EXPIRED] + count[INVALID] > 0 )); then exit 2; fi
if (( count[WARN] > 0 )); then exit 1; fi
