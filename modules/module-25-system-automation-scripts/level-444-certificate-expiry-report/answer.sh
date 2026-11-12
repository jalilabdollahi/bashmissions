#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh TODAY CERTDIR" >&2
  exit 2
fi
today=$1
dir=$2
if [[ ! $today =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})$ ]]; then
  echo "bad date: $today" >&2
  exit 2
fi
ty=${BASH_REMATCH[1]} tm=${BASH_REMATCH[2]} td=${BASH_REMATCH[3]}

# Days since a fixed origin, via the classic "March-based year" formula.
# Only differences between two results mean anything.
daynum() {
  local y=$1 m=$((10#$2)) d=$((10#$3))
  if (( m < 3 )); then y=$(( y - 1 )); m=$(( m + 12 )); fi
  echo $(( 365 * y + y / 4 - y / 100 + y / 400 + (153 * (m - 3) + 2) / 5 + d ))
}

months=" Jan 1 Feb 2 Mar 3 Apr 4 May 5 Jun 6 Jul 7 Aug 8 Sep 9 Oct 10 Nov 11 Dec 12 "
today_n=$(daynum "$ty" "$tm" "$td")

shopt -s nullglob
certs=("$dir"/*.pem)
if (( ${#certs[@]} == 0 )); then
  echo "no certificates in $dir" >&2
  exit 1
fi

rows=""
bad=0
for cert in "${certs[@]}"; do
  name=$(basename "$cert" .pem)
  if ! line=$(openssl x509 -enddate -noout -in "$cert" 2>/dev/null); then
    echo "cannot read certificate: $name" >&2
    bad=$(( bad + 1 ))
    continue
  fi
  # "notAfter=Mar  4 12:00:00 2026 GMT": unquoted expansion splits on any run of spaces.
  read -r mon day _ year _ <<< "${line#notAfter=}"
  rest=${months#* "$mon" }
  mnum=${rest%% *}
  days=$(( $(daynum "$year" "$mnum" "$day") - today_n ))
  rows+="$days $name"$'\n'
  if (( days <= 30 )); then bad=$(( bad + 1 )); fi
done

total=${#certs[@]}
if [[ -n $rows ]]; then
  while read -r days name; do
    if (( days < 0 )); then status=EXPIRED
    elif (( days <= 30 )); then status=WARN
    else status=OK
    fi
    printf '%-10s %5d  %s\n' "$name" "$days" "$status"
  done < <(printf '%s' "$rows" | sort -n -k1,1 -k2,2)
fi
echo "checked $total certificates, $bad need attention"
(( bad == 0 ))
