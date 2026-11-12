#!/usr/bin/env bash
# Order data pipeline: ingest -> validate -> deduplicate -> transform -> load -> report.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--dry-run] INBOX" >&2
  exit 2
}

dry=0
if [[ ${1:-} == --dry-run ]]; then
  dry=1
  shift
fi
[[ $# -eq 1 ]] || usage
inbox=${1%/}
if [[ ! -d $inbox ]]; then
  echo "error: cannot read $1" >&2
  exit 2
fi

files=()
for f in "$inbox"/*.csv; do
  [[ -f $f ]] && files+=("$f")
done
if (( ${#files[@]} == 0 )); then
  echo "inbox is empty"
  exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# In-run copies of the two memories: loaded order ids and processed files.
: > "$work/ids"
[[ -f db/orders.psv ]] && cat db/orders.psv > "$work/ids"
: > "$work/processed"
[[ -f state/processed.list ]] && cat state/processed.list > "$work/processed"
: > "$work/allreasons"
: > "$work/revenues"

if (( ! dry )); then
  mkdir -p db rejects quarantine archive state
fi

header='order_id,customer,sku,qty,unit_price,date'
nfiles=0 rows=0 loaded=0 rejected=0 dups=0 quarantined=0 skipped=0

for f in "${files[@]}"; do
  name=${f##*/}

  # --- ingest ----------------------------------------------------------
  tr -d '\r' < "$f" > "$work/in.csv"
  if [[ $(head -n 1 "$work/in.csv") != "$header" ]]; then
    echo "$name: quarantined (bad header)"
    quarantined=$((quarantined + 1))
    (( dry )) || mv "$f" "quarantine/$name"
    continue
  fi
  read -r crc size _ < <(cksum < "$f")
  old=$(awk -v c="$crc" -v s="$size" '$1 == c && $2 == s { print $3; exit }' "$work/processed")
  if [[ -n $old ]]; then
    echo "$name: skipped (already processed as $old)"
    skipped=$((skipped + 1))
    (( dry )) || mv "$f" "archive/$name.dup"
    continue
  fi

  # --- validate, deduplicate, transform -----------------------------------
  : > "$work/out.psv"
  : > "$work/rej"
  awk -F, -v ids="$work/ids" -v out="$work/out.psv" -v rej="$work/rej" \
    -v counts="$work/counts" -v reasons="$work/allreasons" '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    function reject(why) { print NR "|" why "|" $0 >> rej; why_n[why]++; bad++ }
    BEGIN {
      while ((getline line < ids) > 0) { split(line, a, "|"); known[a[1]] = 1 }
      close(ids)
    }
    NR == 1 || /^[ \t]*$/ { next }
    {
      n++
      if (NF != 6) { reject("wrong field count"); next }
      id = trim($1); cust = trim($2); sku = trim($3); qty = trim($4); price = trim($5); date = trim($6)
      if (id == "") { reject("empty order id"); next }
      if (cust == "") { reject("empty customer"); next }
      if (qty !~ /^[0-9]+$/ || qty + 0 < 1) { reject("bad quantity"); next }
      if (price !~ /^[0-9]+(\.[0-9]+)?$/) { reject("bad price"); next }
      if (date !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/ ||
          substr(date, 6, 2) + 0 < 1 || substr(date, 6, 2) + 0 > 12 ||
          substr(date, 9, 2) + 0 < 1 || substr(date, 9, 2) + 0 > 31) { reject("bad date"); next }
      if (id in known) { dup++; next }
      known[id] = 1
      total = qty * price
      revenue += total
      good++
      printf "%s|%s|%s|%s|%.2f|%s\n", id, cust, toupper(sku), qty, total, date >> out
    }
    END {
      printf "%d %d %d %d %.2f\n", n, good, bad, dup, revenue > counts
      for (w in why_n) print w "|" why_n[w] >> reasons
    }' "$work/in.csv"
  read -r f_rows f_good f_bad f_dup f_rev < "$work/counts"
  echo "$name: $f_rows rows, $f_good loaded, $f_bad rejected, $f_dup duplicate"

  # --- load ------------------------------------------------------------------
  cat "$work/out.psv" >> "$work/ids"
  echo "$crc $size $name" >> "$work/processed"
  echo "$f_rev" >> "$work/revenues"
  if (( ! dry )); then
    cat "$work/out.psv" >> db/orders.psv
    [[ ! -s $work/rej ]] || cat "$work/rej" >> "rejects/$name.rej"
    echo "$crc $size $name" >> state/processed.list
    mv "$f" "archive/$name"
  fi
  nfiles=$((nfiles + 1))
  rows=$((rows + f_rows))
  loaded=$((loaded + f_good))
  rejected=$((rejected + f_bad))
  dups=$((dups + f_dup))
done

# --- report ------------------------------------------------------------------
revenue=$(awk '{ s += $1 } END { printf "%.2f", s }' "$work/revenues")
echo "total: $nfiles files, $rows rows, $loaded loaded, $rejected rejected, $dups duplicates, revenue $revenue"
echo "quarantined: $quarantined, already processed: $skipped"
if (( rejected > 0 )); then
  echo "rejected by reason:"
  awk -F'|' '{ c[$1] += $2 } END { for (r in c) print c[r] "|" r }' "$work/allreasons" |
    sort -t'|' -k1,1nr -k2,2 |
    awk -F'|' '{ printf "  %s: %d\n", $2, $1 }'
fi
(( ! dry )) || echo "dry run: nothing was written"
if (( rejected > 0 || quarantined > 0 )); then exit 1; fi
