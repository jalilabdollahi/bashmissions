#!/usr/bin/env bash
# Access log -> Prometheus text file, published atomically.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh ACCESSLOG OUTFILE" >&2
  exit 2
fi
log=$1
out=$2
if [[ ! -r $log ]]; then
  echo "cannot read $log" >&2
  exit 1
fi

# One pass: "valid total_bytes largest malformed" on a single line.
read -r valid bytes largest bad < <(awk '
  NF == 5 && $4 ~ /^[0-9]+$/ && $5 ~ /^[0-9]+$/ {
    valid++; bytes += $5; if ($5 + 0 > largest) largest = $5 + 0
    next
  }
  { bad++ }
  END { print valid + 0, bytes + 0, largest + 0, bad + 0 }
' "$log")

# Requests per status code, numerically sorted ("200 3" per line).
codes=$(awk 'NF == 5 && $4 ~ /^[0-9]+$/ && $5 ~ /^[0-9]+$/ { n[$4]++ }
             END { for (c in n) print c, n[c] }' "$log" | sort -n)

tmp="$out.tmp"
{
  echo '# HELP lanternfish_http_requests_total Requests served, by status code.'
  echo '# TYPE lanternfish_http_requests_total counter'
  while read -r code count; do
    [[ -n $code ]] && printf 'lanternfish_http_requests_total{code="%s"} %s\n' "$code" "$count"
  done <<< "$codes"
  echo '# HELP lanternfish_http_response_bytes_total Bytes sent to clients.'
  echo '# TYPE lanternfish_http_response_bytes_total counter'
  echo "lanternfish_http_response_bytes_total $bytes"
  echo '# HELP lanternfish_http_largest_response_bytes Largest single response.'
  echo '# TYPE lanternfish_http_largest_response_bytes gauge'
  echo "lanternfish_http_largest_response_bytes $largest"
  echo '# HELP lanternfish_http_malformed_lines_total Log lines that could not be parsed.'
  echo '# TYPE lanternfish_http_malformed_lines_total counter'
  echo "lanternfish_http_malformed_lines_total $bad"
} > "$tmp"

mv "$tmp" "$out"            # rename is atomic: the scraper sees old or new, never half
echo "wrote $out ($valid requests)"
