# Walkthrough: Sort an Array

## The plan
An array cannot be sorted in place, but a stream of lines can. The recipe is a round trip: array to lines, lines through `sort`, lines back to an array.

## Step by step
1. Mode check and `shift` are in the starter. After the shift, `items` holds only the things to sort.
2. Handle the empty list first. `printf '%s\n'` with no arguments prints one blank line, and that blank would be sorted and returned as an element. If `${#items[@]}` is 0, exit quietly.
3. Send the array out as lines: `printf '%s\n' "${items[@]}"`. The format is reused for every element, so you get exactly one line per element, and spaces survive.
4. Pipe into `sort`. For `num` use `sort -n`, which reads the leading number of each line; plain `sort` compares bytes, so "443" lands before "80".
5. Load the result with `mapfile -t sorted < <( ... )`, as in level 167, so the array lives in your shell.
6. Print it with `printf '%s\n' "${sorted[@]}"`.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
mode=${1:-}
if [[ $mode != alpha && $mode != num ]]; then
  echo "usage: solution.sh alpha|num ITEM..." >&2
  exit 2
fi
shift
items=("$@")
if (( ${#items[@]} == 0 )); then
  exit 0
fi
if [[ $mode == num ]]; then
  mapfile -t sorted < <(printf '%s\n' "${items[@]}" | sort -n)
else
  mapfile -t sorted < <(printf '%s\n' "${items[@]}" | sort)
fi
printf '%s\n' "${sorted[@]}"
```

## Trying it by hand
`bash solution.sh num 443 22 8080` gives 22, 443, 8080. `bash solution.sh alpha 443 22 8080` gives 22, 443, 8080 as well, but add 80 and the two modes disagree.

## An alternative
You can also write a bubble sort in pure Bash with two loops and swaps. It teaches loops well and is hopeless for long lists, and it has to be rewritten for every comparison rule. `sort` is faster, well tested, and offers `-n`, `-r`, `-u` and `-k` for free.
