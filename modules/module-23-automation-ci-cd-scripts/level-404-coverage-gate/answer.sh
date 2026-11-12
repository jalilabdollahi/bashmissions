#!/usr/bin/env bash
set -euo pipefail

threshold=${1:-}
report=${2:-}

if [[ ! $threshold =~ ^[0-9]+$ ]] || (( threshold > 100 )) || [[ -z $report ]]; then
  echo "usage: solution.sh THRESHOLD REPORT" >&2
  exit 2
fi
if [[ ! -r $report || -d $report ]]; then
  echo "cannot read $report" >&2
  exit 2
fi

# percent_text COVERED TOTAL -> "82.5": scale by 1000, add half the divisor to
# round half up, then split the integer into whole part and tenths.
# (Plain arithmetic for the split; ${t/10} would be a text substitution.)
percent_text() {
  local t=$(( ($1 * 1000 + $2 / 2) / $2 ))
  echo "$(( t / 10 )).$(( t % 10 ))"
}

paths=() covs=() tots=()
sum_cov=0 sum_tot=0 lineno=0

while IFS= read -r line || [[ -n $line ]]; do
  lineno=$(( lineno + 1 ))
  [[ $line =~ ^[[:space:]]*(#.*)?$ ]] && continue

  if [[ $line =~ ^([^[:space:]]+)[[:space:]]+([0-9]+)[[:space:]]+([0-9]+)[[:space:]]*$ ]]; then
    path=${BASH_REMATCH[1]}
    # 10# forces base ten, so a value like 08 is not read as octal.
    cov=$(( 10#${BASH_REMATCH[2]} ))
    tot=$(( 10#${BASH_REMATCH[3]} ))
  else
    echo "bad report line $lineno" >&2
    exit 2
  fi
  if (( cov > tot )); then
    echo "bad report line $lineno" >&2
    exit 2
  fi

  paths+=("$path") covs+=("$cov") tots+=("$tot")
  sum_cov=$(( sum_cov + cov ))
  sum_tot=$(( sum_tot + tot ))
done < "$report"

if (( sum_tot == 0 )); then
  echo "no measurable lines" >&2
  exit 2
fi

echo "coverage=$(percent_text "$sum_cov" "$sum_tot")% (threshold ${threshold}%)"

for i in "${!paths[@]}"; do
  (( tots[i] > 0 )) || continue
  # exact comparison without division: cov/tot < threshold/100
  if (( covs[i] * 100 < threshold * tots[i] )); then
    echo "low: ${paths[i]} $(percent_text "${covs[i]}" "${tots[i]}")%"
  fi
done

if (( sum_cov * 100 >= threshold * sum_tot )); then
  echo "gate: PASS"
else
  echo "gate: FAIL"
  exit 1
fi
