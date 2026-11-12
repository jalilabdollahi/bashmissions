# Walkthrough: Sum, Min, Max

## The plan

A stream of numbers can be summarised without ever storing it. Four variables
are enough: how many we have seen, their sum, and the smallest and largest so
far. Each new number updates all four. At the end, the answers are simply
sitting there.

## Building it

The loop reads one value per line. Blank lines are skipped first:

```bash
while read -r value; do
  [[ -z $value ]] && continue
  ...
done
```

The sum and count are the easy parts:

```bash
count=$(( count + 1 ))
sum=$(( sum + value ))
```

For min and max the question is what to start from. If both start at 0,
a week of readings that are all above 800 would report a minimum of 0, a value
that never appeared. The fix is to let the first real reading set both
records, and use comparisons only afterwards:

```bash
if (( count == 0 )); then
  min=$value; max=$value
else
  if (( value < min )); then min=$value; fi
  if (( value > max )); then max=$value; fi
fi
```

After the loop, `count` is 0 only if nothing was read. Dividing by zero would
crash, so check before printing:

```bash
if (( count == 0 )); then
  echo "no data" >&2
  exit 1
fi
```

The average is `sum / count`; integer division truncates toward zero, so
-15 / 4 is -3.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

count=0; sum=0; min=0; max=0

while read -r value; do
  [[ -z $value ]] && continue
  if (( count == 0 )); then
    min=$value; max=$value
  else
    if (( value < min )); then min=$value; fi
    if (( value > max )); then max=$value; fi
  fi
  count=$(( count + 1 ))
  sum=$(( sum + value ))
done

if (( count == 0 )); then
  echo "no data" >&2
  exit 1
fi

echo "count=$count"
echo "sum=$sum"
echo "min=$min"
echo "max=$max"
echo "avg=$(( sum / count ))"
```

## Try it by hand

```bash
printf '40\n35\n52\n' | ./solution.sh
printf '' | ./solution.sh; echo "status=$?"
```

## An alternative

`sort -n | head -1` would give the minimum, and another `sort` the maximum, but
each needs a pass over the data and a pipeline, and the data would have to be
stored (or generated three times). One pass with variables is simpler,
faster and works on endless streams such as a log you are following.
