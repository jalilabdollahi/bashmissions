# Walkthrough: Trim Whitespace

## The plan
For each line: remove the whitespace at the front, remove the whitespace at the
back, print it in brackets so the result is visible.

## Why extglob
A normal glob can say "any characters" (`*`) but not "one or more blanks". The
extended patterns can. After `shopt -s extglob` Bash understands, among others:

- `+(pattern)` one or more matches
- `*(pattern)` zero or more
- `?(pattern)` zero or one

`[[:space:]]` is the character class for any whitespace character, tab included.
So `+([[:space:]])` means "a run of blanks".

## Trimming both ends
Use the greedy trimmers so the whole run goes, not just one blank:

```bash
line=${line##+([[:space:]])}
line=${line%%+([[:space:]])}
```

`##` takes the longest prefix and `%%` the longest suffix. Whitespace in the middle
is never at an end of the value, so it is never removed. A line of only blanks is
fully consumed by the first step and leaves an empty string.

## Reading without trimming
`read` itself trims blanks unless you clear `IFS`. We use `IFS= read -r` so that
the trimming you wrote is the only trimming that happens.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob
while IFS= read -r line || [[ -n $line ]]; do
  line=${line##+([[:space:]])}
  line=${line%%+([[:space:]])}
  echo "[$line]"
done
```

## Try it by hand
```bash
printf '   Tidewater  Books  \n\n' | ./solution.sh
```

## Alternative
`line=$(echo "$line" | xargs)` is a popular shortcut, but it also collapses inner
spaces and mangles quotes and backslashes. The expansion touches the ends only.
