# Walkthrough: Iterate Keys in Order

## The plan
Fill a map from the pairs, then print its keys in an order that you impose by sorting them numerically, ascending or descending.

## Step by step
1. The starter handles the optional `--reverse` and shifts it away, so `$@` contains only pairs.
2. Create the map with `declare -A rack`.
3. For every pair, split at the first equals sign. `${pair%%=*}` deletes the longest match of `=*` from the end, which is everything from the first `=` onwards, leaving the unit. `${pair#*=}` deletes the shortest match of `*=` from the front, leaving everything after the first `=`. That matters for `console cable=blue`, where only the first `=` is a separator. Assign `rack[unit]=device`; a repeated unit overwrites the earlier device.
4. Pick the sort flags: `sort -n` for ascending numbers, `sort -rn` for descending.
5. Send the keys out and bring them back in order: `mapfile -t units < <(printf '%s\n' "${!rack[@]}" | sort -n)`. Then a plain `for unit in "${units[@]}"` loop prints `U$unit: ${rack[$unit]}`. Names or numbers with spaces would stay whole because the array holds one key per element.
6. Guard the empty map, so `printf` does not feed `sort` a blank line.
7. Declare the map as `declare -A rack=()`: an empty-but-declared map counts as "set" under `set -u`, so `${#rack[@]}` does not fail on no pairs.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
reverse=0
if [[ ${1:-} == --reverse ]]; then
  reverse=1
  shift
fi
declare -A rack=()
for pair in "$@"; do
  rack[${pair%%=*}]=${pair#*=}
done
if (( ${#rack[@]} > 0 )); then
  if (( reverse )); then
    mapfile -t units < <(printf '%s\n' "${!rack[@]}" | sort -rn)
  else
    mapfile -t units < <(printf '%s\n' "${!rack[@]}" | sort -n)
  fi
  for unit in "${units[@]}"; do
    echo "U$unit: ${rack[$unit]}"
  done
fi
```

## Trying it by hand
`bash solution.sh 10=a 2=b 3=c` and then `bash solution.sh --reverse 10=a 2=b 3=c`. Remove `-n` and watch 10 jump in front of 2.

## An alternative
Keep the keys in an extra indexed array while you fill the map and sort that. It is the same round trip with more bookkeeping. Sorting `"${!rack[@]}"` straight from the map is simpler and cannot get out of step with it.
