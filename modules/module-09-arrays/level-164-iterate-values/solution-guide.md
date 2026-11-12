# Walkthrough: Iterate Values

## The plan
Walk through the amounts one at a time. For each, add it to a running total, and if it is 100 or more, bump a counter. Print both after the loop.

## Step by step
1. The starter already makes the array and sets `total` and `large` to 0.
2. Start the loop: `for amount in "${amounts[@]}"; do`. This is the safe all-elements expansion from earlier, used as the list for `for`. The variable `amount` holds a copy of each value in turn.
3. Add it up with `total=$(( total + amount ))`. Inside `$(( ))` you do not need dollar signs on variable names.
4. Test with `if (( amount >= 100 )); then large=$(( large + 1 )); fi`. The comparison is inclusive, so exactly 100 counts.
5. After `done`, print the two lines. For an empty array the loop body never runs and both numbers stay 0, with no special case.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
amounts=("$@")
total=0
large=0
for amount in "${amounts[@]}"; do
  total=$(( total + amount ))
  if (( amount >= 100 )); then
    large=$(( large + 1 ))
  fi
done
echo "total: $total"
echo "large: $large"
```

## Trying it by hand
`bash solution.sh 120 40 99 100` should say total 359, large 2. Run it with no arguments too.

## An alternative
`for amount; do ... done` with no list loops over `"$@"` directly and skips the array. That is fine for a quick script, but once the data comes from somewhere other than the command line, the array form is the one you will reuse.
