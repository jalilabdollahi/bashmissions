# Walkthrough: Rounding Division

## The plan

`a / b` in Bash always throws the remainder away, which is "round down" (floor)
for non-negative numbers. The other two roundings can be made by adding a
carefully chosen number to `a` first. No floating point, no extra tools.

## Why adding works

Write `a = q * b + r`, where `r` is the remainder (0 to b-1). Then `a / b` is `q`.
If you add `k` to `a`, the remainder becomes `r + k`, and the quotient grows by
one exactly when `r + k` reaches `b`. So choosing `k` decides how large the
remainder must be before it tips over:

| goal | k | tips over when remainder is at least |
|---|---|---|
| floor | 0 | never |
| nearest, half up | b / 2 | about half of b |
| ceiling | b - 1 | 1, so any leftover |

Check with 7 / 2 (3.5): `(7 + 1) / 2` is 4, half rounds up. With 10 / 3
(3.33): `(10 + 1) / 3` is 3, stays down. With 11 / 3 (3.67): `(11 + 1) / 3` is 4,
rounds up.

## Building it

First the zero guard, because dividing by zero is an error in Bash:

```bash
if (( parts == 0 )); then
  echo "parts must be at least 1" >&2
  exit 2
fi
```

Then the three results:

```bash
floor=$(( amount / parts ))
nearest=$(( (amount + parts / 2) / parts ))
ceiling=$(( (amount + parts - 1) / parts ))
```

For an even `parts`, `parts / 2` is exact and an exact half always lands on
the tipping point, so it rounds up as the objective says. For an odd `parts`
there can be no exact half, so the rounding down of `parts / 2` is harmless.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

amount="$1"
parts="$2"

if (( parts == 0 )); then
  echo "parts must be at least 1" >&2
  exit 2
fi

floor=$(( amount / parts ))
nearest=$(( (amount + parts / 2) / parts ))
ceiling=$(( (amount + parts - 1) / parts ))

echo "floor=$floor"
echo "nearest=$nearest"
echo "ceiling=$ceiling"
```

## Try it by hand

```bash
./solution.sh 7 2
./solution.sh 10 4
./solution.sh 1234567 12
```

## An alternative

With awk, `printf "%.0f"` rounds, but it rounds half to even (so 2.5 becomes 2)
and needs another process. The "add before dividing" trick stays in Bash, gives
the rule you chose (half up) every time, and is exact for any size of integer.
