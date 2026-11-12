#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh PROBE_FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

up=0
down=0

report_up() {
  echo "UP $1"
  up=$((up + 1))
}
report_down() {
  echo "DOWN $1 ($2)"
  down=$((down + 1))
}

# "read -r kind name a b" splits the line on whitespace: for http, "a" is the URL;
# for tcp, "a" is the host and "b" the port.
while read -r kind name a b; do
  case $kind in
    ''|'#'*) continue ;;
  esac

  case $kind in
    http)
      # 000 means curl never got an answer; it also exits non-zero, hence "|| true".
      code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 "$a") || true
      case $code in
        000)                   report_down "$name" "no connection" ;;
        [23][0-9][0-9])        report_up "$name" ;;
        *)                     report_down "$name" "HTTP $code" ;;
      esac
      ;;
    tcp)
      if nc -z -w 2 "$a" "$b"; then
        report_up "$name"
      else
        report_down "$name" "port closed"
      fi
      ;;
    *)
      report_down "$name" "unknown type $kind"
      ;;
  esac
done < "$file"

echo "summary: $up up, $down down"
if (( down > 0 )); then
  exit 1
fi
