#!/usr/bin/env bash
# Seeded chaos monkey. All "randomness" comes from a small LCG, so a seed
# replays the exact same sequence of faults on any machine and any Bash.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--dry-run] SEED ROUNDS FLEET" >&2
  exit 2
}

dry=0
if [[ ${1:-} == --dry-run ]]; then
  dry=1
  shift
fi
[[ $# -eq 3 ]] || usage
seed=$1 rounds=$2 fleet=$3
[[ $seed =~ ^[0-9]{1,18}$ ]] || usage
[[ $rounds =~ ^[1-9][0-9]{0,8}$ ]] || usage

chance=${CHANCE:-50}
if [[ ! $chance =~ ^[0-9]+$ ]] || (( chance > 100 )); then
  echo "invalid CHANCE" >&2
  exit 2
fi
[[ -r $fleet ]] || { echo "cannot read $fleet" >&2; exit 2; }

targets=()
while read -r name flag _; do
  [[ -z $name || $name == \#* ]] && continue
  [[ $flag == protected ]] && continue
  targets+=("$name")
done < "$fleet"
if (( ${#targets[@]} == 0 )); then
  echo "no eligible services in $fleet" >&2
  exit 1
fi

# --- the generator --------------------------------------------------------
# Bash integers are 64-bit: state < 2^31 times 1103515245 (~2^30) stays far
# below 2^63, and "& 2147483647" keeps the state within 31 bits.
state=$((seed & 2147483647))
rnd=0
next() {
  state=$(( (state * 1103515245 + 12345) & 2147483647 ))
  rnd=$(( state >> 16 ))
}

faults=0 unhealed=0
for (( n = 1; n <= rounds; n++ )); do
  next
  if (( rnd % 100 >= chance )); then
    echo "round $n: calm"
    continue
  fi
  next; target=${targets[rnd % ${#targets[@]}]}
  next; kind=$(( rnd % 3 ))
  next; p=$(( rnd % 9 + 1 ))
  case $kind in
    0) desc="kill $target" ;;
    1) desc="delay $target $((p * 100))ms" ;;
    2) desc="drop $target $((p * 10))%" ;;
  esac
  faults=$((faults + 1))
  if (( dry )); then
    echo "round $n: would $desc"
    continue
  fi
  case $kind in
    0) chaosctl kill "$target" ;;
    1) chaosctl delay "$target" $((p * 100)) ;;
    2) chaosctl drop "$target" $((p * 10)) ;;
  esac
  s1=$(chaosctl status "$target")
  chaosctl heal "$target"
  s2=$(chaosctl status "$target")
  [[ $s2 == healthy ]] || unhealed=$((unhealed + 1))
  echo "round $n: $desc -> $s1 -> $s2"
done

if (( dry )); then
  echo "summary: rounds=$rounds faults=$faults (dry run)"
else
  echo "summary: rounds=$rounds faults=$faults unhealed=$unhealed"
  (( unhealed == 0 ))
fi
