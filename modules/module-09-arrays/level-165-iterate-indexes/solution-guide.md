# Walkthrough: Iterate Indexes

## The plan
The line you print depends on where a machine sits, not only on its name. So loop over positions, and read the value at each position.

## Step by step
1. Build the array: `rack=("$@")`.
2. Get the indexes with `"${!rack[@]}"`. The exclamation mark turns "give me the values" into "give me the keys". For a three-element array it expands to `0 1 2`.
3. Loop: `for i in "${!rack[@]}"; do`. Now `i` is the position and `${rack[i]}` is the value there. (Inside the square brackets Bash evaluates arithmetic, so no dollar sign is needed.)
4. Skip empty slots with a test and `continue`: `[[ ${rack[i]} == "-" ]]`. The numbering is unaffected because it comes from `i`, not from a counter that only counts printed lines.
5. Print `slot $(( i + 1 )): ${rack[i]}`. The `+ 1` converts the zero-based index into the numbering on the physical labels.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
rack=("$@")
for i in "${!rack[@]}"; do
  if [[ ${rack[i]} == "-" ]]; then
    continue
  fi
  echo "slot $(( i + 1 )): ${rack[i]}"
done
```

## Trying it by hand
`bash solution.sh a - b` should print slots 1 and 3. Then run it with no arguments; the loop does not run and nothing is printed.

## An alternative
A counter variable that you increment by hand works for plain arrays, and a C-style loop `for ((i=0; i<${#rack[@]}; i++))` too. Both break on sparse arrays (after an `unset`), where the count and the highest index differ. `"${!rack[@]}"` lists only indexes that really exist, so it is the robust choice.
