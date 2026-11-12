#!/usr/bin/env bash
# Invoice generator: graduated tiers, integer money, half-up rounding.
set -euo pipefail

usage() {
  echo "usage: solution.sh PRICES USAGE [DISCOUNTS]" >&2
  exit 2
}
[[ $# -eq 2 || $# -eq 3 ]] || usage
prices=$1 usagefile=$2 discounts=${3:-}

for f in "$prices" "$usagefile" ${discounts:+"$discounts"}; do
  [[ -r $f ]] || { echo "cannot read $f" >&2; exit 2; }
done

tax_pct=${TAX_PCT:-0}
min_charge=${MIN_CHARGE:-0}
[[ $tax_pct =~ ^[0-9]+$ ]] || { echo "invalid TAX_PCT" >&2; exit 2; }
[[ $min_charge =~ ^[0-9]+$ ]] || { echo "invalid MIN_CHARGE" >&2; exit 2; }

# round_div NUM DEN -> NUM/DEN rounded half up (non-negative numbers only)
round_div() { echo $(( ($1 + $2 / 2) / $2 )); }

money() {   # cents -> $D.CC or -$D.CC
  local c=$1 sign=
  (( c < 0 )) && { sign=-; c=$((-c)); }
  printf '%s$%d.%02d' "$sign" $((c / 100)) $((c % 100))
}

# --- price list --------------------------------------------------------------
items=()
declare -A unit tiers
n=0
while read -r item u rest; do
  n=$((n + 1))
  [[ -z $item || $item == \#* ]] && continue
  prev=0 spec= ok=1 last_open=0
  for t in $rest; do
    if (( last_open )) || [[ ! $t =~ ^([0-9]+|\*):([0-9]+)(\.([0-9]{1,4}))?$ ]]; then
      ok=0; break
    fi
    upto=${t%%:*}
    frac=${BASH_REMATCH[4]:-}
    while (( ${#frac} < 4 )); do frac+=0; done
    price=$((10#${BASH_REMATCH[2]} * 10000 + 10#$frac))
    if [[ $upto == '*' ]]; then
      last_open=1
    elif (( 10#$upto <= prev )); then
      ok=0; break
    else
      prev=$((10#$upto))
    fi
    spec+="$upto:$price "
  done
  if [[ -z ${u:-} || -z $spec ]] || (( ! ok || ! last_open )); then
    echo "bad price line $n" >&2
    exit 2
  fi
  items+=("$item")
  unit[$item]=$u
  tiers[$item]=$spec
done < "$prices"

# line_cost ITEM QTY -> tenthousandths of a dollar, graduated across the tiers
line_cost() {
  local qty=$2 prev=0 total=0 t upto price top
  for t in ${tiers[$1]}; do
    upto=${t%%:*}
    price=${t#*:}
    if [[ $upto == '*' ]]; then top=$qty; else top=$(( qty < upto ? qty : upto )); fi
    (( top > prev )) && total=$(( total + (top - prev) * price ))
    [[ $upto == '*' ]] && break
    prev=$upto
    (( qty <= upto )) && break
  done
  echo "$total"
}

# --- discounts ---------------------------------------------------------------
declare -A disc
if [[ -n $discounts ]]; then
  n=0
  while read -r who pct extra; do
    n=$((n + 1))
    [[ -z $who || $who == \#* ]] && continue
    if [[ -n ${extra:-} || ! ${pct:-} =~ ^[0-9]+$ ]] || (( 10#$pct > 100 )); then
      echo "bad discount line $n" >&2
      exit 2
    fi
    disc[$who]=$((10#$pct))
  done < "$discounts"
fi

# --- usage -------------------------------------------------------------------
declare -A qty
customers=()
skipped=0
n=0
while IFS= read -r line || [[ -n $line ]]; do
  n=$((n + 1))
  [[ -z $line ]] && continue
  (( n == 1 )) && [[ $line == customer,item,quantity ]] && continue
  IFS=, read -r cust item q extra <<< "$line"
  if [[ -n ${extra:-} || -z ${q:-} ]] || [[ $line != *,*,* ]]; then
    echo "line $n: expected CUSTOMER,ITEM,QUANTITY" >&2; skipped=1; continue
  fi
  if [[ -z ${unit[$item]:-} ]]; then
    echo "line $n: unknown item $item" >&2; skipped=1; continue
  fi
  if [[ ! $q =~ ^[0-9]+$ ]]; then
    echo "line $n: bad quantity" >&2; skipped=1; continue
  fi
  if [[ -z ${qty[$cust|$item]:-} ]]; then
    already=0
    for c in "${customers[@]:-}"; do [[ $c == "$cust" ]] && already=1; done
    (( already )) || customers+=("$cust")
    qty[$cust|$item]=0
  fi
  qty[$cust|$item]=$(( qty[$cust|$item] + 10#$q ))
done < "$usagefile"

# --- invoices ----------------------------------------------------------------
grand=0
count=0
if (( ${#customers[@]} > 0 )); then
  sorted=$(printf '%s\n' "${customers[@]}" | sort)
else
  sorted=
fi
while IFS= read -r cust; do
  [[ -n $cust ]] || continue
  count=$((count + 1))
  echo "== $cust =="
  subtotal=0
  for item in "${items[@]}"; do
    [[ -n ${qty[$cust|$item]:-} ]] || continue
    cents=$(round_div "$(line_cost "$item" "${qty[$cust|$item]}")" 100)
    subtotal=$((subtotal + cents))
    printf '%-10s %6d %-5s %10s\n' "$item" "${qty[$cust|$item]}" "${unit[$item]}" "$(money "$cents")"
  done
  printf '%-23s %10s\n' subtotal "$(money "$subtotal")"
  pct=${disc[$cust]:-0}
  dcents=$(round_div $((subtotal * pct)) 100)
  net=$((subtotal - dcents))
  (( pct > 0 )) && printf '%-23s %10s\n' "discount $pct%" "$(money $((-dcents)))"
  if (( net < min_charge )); then
    printf '%-23s %10s\n' "minimum charge" "$(money $((min_charge - net)))"
    net=$min_charge
  fi
  tcents=$(round_div $((net * tax_pct)) 100)
  (( tax_pct > 0 )) && printf '%-23s %10s\n' "tax $tax_pct%" "$(money "$tcents")"
  total=$((net + tcents))
  printf '%-23s %10s\n' total "$(money "$total")"
  grand=$((grand + total))
done <<< "$sorted"

echo "customers: $count, grand total: $(money "$grand")"
exit "$skipped"
