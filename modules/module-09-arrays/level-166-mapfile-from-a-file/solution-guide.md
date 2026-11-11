# Walkthrough: mapfile from a File

## The plan
Check that the file exists, load all its lines in one go, then report the count and the first and last line, with a special case for an empty file.

## Step by step
1. Keep the usage check from the starter, and add the readability check: `[[ -r $file ]]`. If it fails, print `no such file: $file` to stderr and exit 1.
2. Replace the starter's `hosts=($(cat "$file"))`. That form splits the file at every space and tab and expands any `*`, so "old dory" becomes two elements and the blank line vanishes.
3. Use `mapfile -t hosts < "$file"`. The shell opens the file, `mapfile` reads every line into elements 0, 1, 2, ..., and `-t` removes each line's trailing newline. A blank line becomes an empty element; the last line is kept even without a newline.
4. Print the count with `${#hosts[@]}`.
5. For `first` and `last`, branch on the count. With zero elements print `(none)` for both; otherwise print `${hosts[0]}` and `${hosts[-1]}`.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "no such file: $file" >&2
  exit 1
fi
mapfile -t hosts < "$file"
echo "loaded: ${#hosts[@]}"
if (( ${#hosts[@]} == 0 )); then
  echo "first: (none)"
  echo "last: (none)"
else
  echo "first: ${hosts[0]}"
  echo "last: ${hosts[-1]}"
fi
```

## Trying it by hand
`printf 'a\n\nb c\n' > t.txt; bash solution.sh t.txt` reports 3 lines. Compare with the `$(cat ...)` version to see the difference.

## An alternative
`while IFS= read -r line; do hosts+=("$line"); done < file` does the same, with more typing and a missing-newline special case. `mapfile` is the shorter, clearer tool for "all lines into an array". (`readarray` is a synonym.)
