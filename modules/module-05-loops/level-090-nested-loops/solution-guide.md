# Walkthrough: Nested Loops

## The plan
The grid has two directions. The outer loop walks down the rows (one row per number of servers). For each row, an inner loop walks along the cells (one per month). After the inner loop finishes, you end the line.

## Step by step
1. Check the arguments: fewer than two means usage on stderr and `exit 2`. Give them names: `servers=$1`, `months=$2`.
2. The outer loop: `for (( s = 1; s <= servers; s++ )); do`. Zero servers means the condition is false at once, so nothing is printed, which is exactly what the objective asks.
3. At the start of every row print the label without a newline: `printf 'servers %d:' "$s"`.
4. The inner loop: `for (( m = 1; m <= months; m++ )); do`. Each round prints one cell: `printf '%6d' $(( s * m * 12 ))`. The format `%6d` reserves six characters and has no newline, so the cells line up on the same row.
5. After the inner loop's `done`, print `printf '\n'`. It sits inside the outer loop, so it runs once per row.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh SERVERS MONTHS" >&2
  exit 2
fi
servers=$1
months=$2
for (( s = 1; s <= servers; s++ )); do
  printf 'servers %d:' "$s"
  for (( m = 1; m <= months; m++ )); do
    printf '%6d' $(( s * m * 12 ))
  done
  printf '\n'
done
```

## Trying it by hand
`bash solution.sh 3 4` prints a three-row grid. Move the `printf '\n'` line inside the inner loop to see every cell land on its own line, a good way to understand which line belongs to which loop.

## An alternative
Brace ranges in both loops, `for s in {1..3}; do for m in {1..4}`, give the same output for fixed sizes. They cannot take the sizes from arguments, which is why counting loops are used here.
