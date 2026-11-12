# Walkthrough: Append Items

## The plan
Start with a fixed two-element array, loop over stdin, and push every line onto the end. When the input is exhausted, print the pool and its size.

## Step by step
1. Create the starting pool: `pool=(anchovy barracuda)`.
2. Read lines with `while IFS= read -r line; do ... done`. `IFS=` stops `read` from trimming leading and trailing spaces, and `-r` keeps backslashes as they are, so "grouper  (spare)" arrives intact.
3. In the body append with `pool+=("$line")`. Bash finds the next free index by itself; you never compute it.
4. A final line without a newline makes `read` return failure even though it filled the variable. Adding `|| [[ -n $line ]]` to the loop condition gives that last line one more turn.
5. Print the array with `printf '%s\n' "${pool[@]}"` and the count with `${#pool[@]}`. The pool is never empty here (it starts with two), so no guard is needed.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
pool=(anchovy barracuda)
while IFS= read -r line || [[ -n $line ]]; do
  pool+=("$line")
done
printf '%s\n' "${pool[@]}"
echo "total: ${#pool[@]}"
```

## Trying it by hand
`printf 'dory\neel\n' | bash solution.sh` shows a pool of four. Then try `bash solution.sh < /dev/null` for the quiet case.

## An alternative
`pool[${#pool[@]}]=$line` also appends, by assigning to the index just past the end. It works as long as the array has no gaps, but `+=` is shorter and does not break on sparse arrays (the next level makes some).
