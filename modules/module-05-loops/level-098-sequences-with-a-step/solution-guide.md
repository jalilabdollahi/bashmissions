# Walkthrough: Sequences with a Step

## The plan
Compute how many minutes after 02:00 each server starts, which is a stepped sequence, then format the clock time.

## Step by step
1. Check for two arguments, then name them: `count=$1`, `step=$2`.
2. Work out the last offset. With `count` servers the offsets are `0, step, 2*step, ..., (count-1)*step`. So the last one is `$(( (count - 1) * step ))`.
3. Let `seq` generate the offsets: `seq 0 "$step" "$last"`. Its three arguments are FIRST, INCREMENT and LAST. The same call with brace syntax is impossible, because braces cannot contain variables.
4. Loop over the output: `for offset in $(seq ...); do`. The numbers contain no spaces, so splitting the output into words is safe here.
5. Keep a server number `n`, increased by one every round.
6. Convert: 02:00 is minute 120, so `minutes=$(( 120 + offset ))`. Hours are `minutes / 60`, minutes are `minutes % 60`. `printf` with `%02d` pads both to two digits.
7. For `count=0` the last offset would be `-step`, below the start. Different systems treat that differently (GNU `seq` prints nothing, BSD `seq` complains), so handle it yourself: `if (( count < 1 )); then exit 0; fi` before the loop.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh COUNT STEP" >&2
  exit 2
fi
count=$1
step=$2
n=0
if (( count < 1 )); then
  exit 0
fi
for offset in $(seq 0 "$step" $(( (count - 1) * step ))); do
  n=$(( n + 1 ))
  minutes=$(( 120 + offset ))
  printf 'host-%d starts at %02d:%02d\n' "$n" $(( minutes / 60 )) $(( minutes % 60 ))
done
```

## Trying it by hand
`seq 0 15 45` on its own shows the raw numbers. Then `bash solution.sh 4 15`.

## An alternative
A C-style loop, `for (( n=1; n<=count; n++ ))`, computes the offset as `(n-1)*step` and needs no `seq` at all. Bash 4 also has stepped braces, `{0..45..15}`, but only for fixed numbers. `seq` earns its place when the ends come from variables and the step is not 1.
