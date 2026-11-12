# Walkthrough: Arithmetic Conditions

## The plan

We need a three-way decision with two thresholds. The condition "used is at
least 90% of total" can be written as `used / total >= 90 / 100`. Bash cannot
keep a fraction, so we rearrange: multiply both sides by `total * 100` and get
`used * 100 >= total * 90`. Pure integers, no rounding, no division.

## Building it

In `(( ))`, the usual comparison operators work, and the whole thing is true or
false, so it can sit directly in `if`:

```bash
if (( used * 100 >= total * 90 )); then
```

Notice there are no `$` signs and no `-ge`. Compare with the test brackets
from earlier modules: `[[ $used -ge $total ]]` needs `-ge`, while `(( used >=
total ))` uses the symbols you know from school.

Order matters. A disk at 95% passes both thresholds, so the stricter test
comes first and the `elif` only sees what is left:

```bash
if   (( used * 100 >= total * 90 )); then echo "$name: CRITICAL"
elif (( used * 100 >= total * 75 )); then echo "$name: WARNING"
else                                       echo "$name: OK"
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

name="$1"
used="$2"
total="$3"

if (( used * 100 >= total * 90 )); then
  echo "$name: CRITICAL"
elif (( used * 100 >= total * 75 )); then
  echo "$name: WARNING"
else
  echo "$name: OK"
fi
```

## Try it by hand

```bash
./solution.sh dory 89 100
./solution.sh eel 450 500
./solution.sh grouper 599 800
```

## An alternative

Compute `pct=$(( used * 100 / total ))` and compare `pct >= 90`. It reads well but
the division truncates: 89.9% becomes 89, which is fine here, yet 90.0 versus
89.99 can matter in other thresholds. Cross-multiplying is exact.
