# Walkthrough: Counting with a Map

## The plan
Use the plan name as the key and the number of customers as the value. Every input line bumps one counter. When the input ends, list the keys in sorted order with their counters.

## Step by step
1. `declare -A count` creates the map.
2. Read stdin with `while IFS= read -r plan || [[ -n $plan ]]`. `IFS=` and `-r` keep the line as typed, and the second condition rescues a last line without a newline.
3. Skip empty lines with `[[ -z $plan ]] && continue`.
4. Increment: `count[$plan]=$(( ${count[$plan]:-0} + 1 ))`. The expansion `${count[$plan]:-0}` yields the current value, or 0 when the key does not exist yet, and `$(( ))` adds one. Avoid `((count[$plan]++))` under `set -e`: when the old value is 0 the expression's result is 0, which counts as "false" and aborts the script.
5. The order of `"${!count[@]}"` is unspecified, so feed the keys through `sort`: `printf '%s\n' "${!count[@]}" | sort`. Read them back one per line with `while read` and `< <(...)`, so names with spaces survive.
6. Guard the empty map so empty input prints nothing.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
declare -A count=()
while IFS= read -r plan || [[ -n $plan ]]; do
  [[ -z $plan ]] && continue
  count[$plan]=$(( ${count[$plan]:-0} + 1 ))
done
if (( ${#count[@]} > 0 )); then
  while IFS= read -r plan; do
    echo "$plan: ${count[$plan]}"
  done < <(printf '%s\n' "${!count[@]}" | sort)
fi
```

## Trying it by hand
`printf 'a\nb\na\n' | bash solution.sh` gives `a: 2` and `b: 1`.

## An alternative
`sort | uniq -c` counts too, and for a one-off command line it is perfect. A map is better inside a script when you want the counts available as data afterwards: to look up one plan, to compare two counts or to print a percentage.
