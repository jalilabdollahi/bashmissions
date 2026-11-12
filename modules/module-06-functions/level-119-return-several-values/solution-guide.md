# Walkthrough: Return Several Values

## The plan
One pass over the numbers computes everything. The function prints the three
results on one line; the caller splits the line back into variables.

## Building it
Start `min` and `max` at the first argument. Starting at 0 would give a wrong
answer for all-positive minimums or all-negative maximums. Then update inside a
loop:

```bash
stats() {
  local min=$1 max=$1 sum=0 n
  for n in "$@"; do
    (( n < min )) && min=$n
    (( n > max )) && max=$n
    sum=$(( sum + n ))
  done
  printf '%s %s %s\n' "$min" "$max" "$sum"
}
```

`printf` gives exact control over what is printed and needs no `echo` caveats.
Guard against zero arguments before calling (`$1` would be unset), then unpack:

```bash
read -r min max sum <<< "$(stats "$@")"
echo "min=$min max=$max sum=$sum"
```

`<<<` is a "here-string": it feeds the text on its right to the command's stdin.
`read` splits it on whitespace into the three variables.

Note that `(( n < min )) && min=$n` is safe under `set -e`: a failing test on the left of
`&&` does not abort the script.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
stats() {
  local min=$1 max=$1 sum=0 n
  for n in "$@"; do
    (( n < min )) && min=$n
    (( n > max )) && max=$n
    sum=$(( sum + n ))
  done
  printf '%s %s %s\n' "$min" "$max" "$sum"
}
if [[ $# -eq 0 ]]; then
  echo "no numbers given" >&2
  exit 1
fi
read -r min max sum <<< "$(stats "$@")"
echo "min=$min max=$max sum=$sum"
```

## Try it by hand
```bash
./solution.sh 120 80 95 300
./solution.sh -5 10 -20 3
```

## Alternative
Name references (previous level) let `stats` set `min`, `max` and `sum` directly
in the caller. That is exact and avoids text splitting, but it ties the helper to
variable names. Printing one line keeps the function usable from pipelines too.
