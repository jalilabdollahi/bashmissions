# Walkthrough: Percentages Without Floats

## The plan

Bash has no decimals, but a decimal is just a whole number with a point drawn
in the right place. 37.5% is 375 tenths. If we calculate in tenths, every
step stays an integer, and only the printing needs to know about the point.

## Building it

Guard the divisor first, because dividing by zero is an arithmetic error:

```bash
if (( total == 0 )); then
  echo "total must not be zero" >&2
  exit 2
fi
```

Now the order of operations. Compare:

```bash
echo $(( 1 / 3 * 1000 ))     # 0: the division already lost everything
echo $(( 1 * 1000 / 3 ))     # 333: scaling first keeps the digits
```

333 tenths of a percent is 33.3%. The same rule as in cash registers: work in
the smallest unit and convert only at the end.

To put the point back, divide by ten for the whole part and take the remainder
for the digit:

```bash
tenths=$(( used * 1000 / total ))
echo "usage: $(( tenths / 10 )).$(( tenths % 10 ))%"
```

Check 5 of 2000: tenths is 2, so whole part 0 and digit 2: `0.2%`. Because the
decimal digit is a single number, no padding is needed. (With two decimals you
would have to pad, and that is a classic extra bug.)

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

used="$1"
total="$2"

if (( total == 0 )); then
  echo "total must not be zero" >&2
  exit 2
fi

tenths=$(( used * 1000 / total ))
echo "usage: $(( tenths / 10 )).$(( tenths % 10 ))%"
```

## Try it by hand

```bash
./solution.sh 375 1000
./solution.sh 2 3
./solution.sh 5 2000
```

## An alternative

`awk` can do this in one line with `printf "%.1f"`, and rounds instead of
truncating. It is the right choice when awk is available and you want
rounding. The integer way has no dependency and no startup cost, which is why
it is popular in tiny scripts and in places that run thousands of times.
