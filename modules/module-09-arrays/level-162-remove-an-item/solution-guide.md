# Walkthrough: Remove an Item

## The plan
For every index you are given, delete that element from the array. Then show the array so you can see what is left. The interesting part is not the deleting; it is what the array looks like afterwards.

## Step by step
1. The array is fixed: `fleet=(anchovy barracuda cuttlefish dory eel)`, indexes 0 to 4.
2. Loop over the arguments: `for i in "$@"; do ... done`. Each `$i` is a number such as 1 or 3.
3. Inside, write `unset 'fleet[$i]'`. Bash evaluates `$i` inside the subscript. The single quotes matter: without them the shell may treat `fleet[$i]` as a pattern that matches file names such as `fleet1`, and unset would then quietly remove nothing.
4. After removing indexes 1 and 3 the array still has the keys 0, 2 and 4. That is what `declare -p fleet` shows: `([0]="anchovy" [2]="cuttlefish" [4]="eel")`. This is a sparse array: there is simply no slot 1 any more.
5. `${#fleet[@]}` counts the elements that exist, so after two removals it is 3 even though the highest index is 4.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
fleet=(anchovy barracuda cuttlefish dory eel)
for i in "$@"; do
  unset 'fleet[$i]'
done
echo "left: ${#fleet[@]}"
declare -p fleet
```

## Trying it by hand
Run `bash solution.sh 1 3` and `bash solution.sh 3 1`. The result is identical, because indexes are stable names, not positions.

## An alternative
To get a tightly packed array again, rebuild it: `fleet=("${fleet[@]}")` copies the survivors into a fresh array numbered from 0. Do that only when you no longer need the old numbers.
