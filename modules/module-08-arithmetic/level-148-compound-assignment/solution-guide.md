# Walkthrough: Compound Assignment

## The plan

Two projections share the same starting point but evolve differently, so they
need two variables. Every month both get updated, and we print them. The update
itself is a very common shape: "take the variable, change it using its own
value, store it back".

## Building it

Copy the start value into both scenario variables and print the header line:

```bash
steady="$start"
doubling="$start"
echo "start=$start"
```

The spelled-out way to update is `steady=$(( steady + add ))`. The compound
operators say the same thing with less repetition:

| shorthand | long form |
|---|---|
| `x += n` | `x = x + n` |
| `x -= n` | `x = x - n` |
| `x *= n` | `x = x * n` |
| `x /= n` | `x = x / n` |

Inside `(( ))` that is a plain statement:

```bash
(( steady += add ))
(( doubling *= 2 ))
```

Wrap it in a counting loop. The C-style `for (( ... ))` from the loops module
runs the body once per month:

```bash
for (( month = 1; month <= months; month++ )); do
  (( steady += add ))
  (( doubling *= 2 ))
  echo "month $month: steady=$steady doubling=$doubling"
done
```

With `MONTHS` equal to 0 the loop body never runs, so only the start line
appears. That is exactly what the objective asks for.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

start="$1"; add="$2"; months="$3"
steady="$start"
doubling="$start"

echo "start=$start"
for (( month = 1; month <= months; month++ )); do
  (( steady += add ))
  (( doubling *= 2 ))
  echo "month $month: steady=$steady doubling=$doubling"
done
```

## Try it by hand

```bash
./solution.sh 100 15 4
./solution.sh 250 10 0
```

## An alternative

`steady=$(( steady + add ))` is wordier but always succeeds even under
`set -e`, whereas `(( x += n ))` returns status 1 if the new value happens to be
zero. Here the values never end up at zero in the tests, but keep that in mind
when you use the short form in strict scripts.
