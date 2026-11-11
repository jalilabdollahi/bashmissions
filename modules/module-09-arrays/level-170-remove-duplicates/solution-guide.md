# Walkthrough: Remove Duplicates

## The plan
Walk the tickets from oldest to newest. Keep a list of names already accepted. A name is accepted only if the list does not contain it yet. At the end, the accepted list is the digest.

## Step by step
1. Start with an empty array `unique=()`.
2. Outer loop: `for name in "$@"`. Each argument is one ticket.
3. Inner loop: walk `"${unique[@]}"` and compare each `kept` with `"$name"` using `[[ $kept == "$name" ]]` (quoted on the right, so names are compared literally). On a match set `seen=1` and `break`.
4. After the inner loop, `if (( seen == 0 )); then unique+=("$name"); fi`. Setting `seen=0` at the top of each outer round is essential; forgetting it means that after the first duplicate nothing is ever added again.
5. Print the array, guarded against emptiness. The number of repeats is arguments minus uniques: `$(( $# - ${#unique[@]} ))`.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
unique=()
for name in "$@"; do
  seen=0
  for kept in "${unique[@]}"; do
    if [[ $kept == "$name" ]]; then
      seen=1
      break
    fi
  done
  if (( seen == 0 )); then
    unique+=("$name")
  fi
done
if (( ${#unique[@]} > 0 )); then
  printf '%s\n' "${unique[@]}"
fi
echo "removed: $(( $# - ${#unique[@]} ))"
```

## Trying it by hand
`bash solution.sh a b a c b` prints a, b, c and `removed: 2`. Reverse the arguments and the digest order changes with them, as it should.

## An alternative
`sort -u` removes duplicates in one command but returns them in sorted order, which destroys "first appearance". In the associative-array levels you will see the idiomatic Bash way: remember names in a map and test with `-v`, which turns the inner loop into a single lookup.
