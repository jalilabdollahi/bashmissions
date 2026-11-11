# Walkthrough: Comparing Numbers

## The plan

Four bands, one number. This is the elif ladder from before, but the questions
are now about size rather than identical text. Text comparison would be a trap:
as strings, "9" sorts after "70" because "9" comes after "7" character by
character. Numeric operators compare values instead.

## The six operators

| Operator | Meaning |
|---|---|
| `-eq` | equal |
| `-ne` | not equal |
| `-lt` | less than |
| `-le` | less than or equal |
| `-gt` | greater than |
| `-ge` | greater than or equal |

## Building it

Order the ladder from most to least severe, because a value like 95 satisfies
both "at least 90" and "at least 70", and only the first true test counts:

```bash
used="$1"
if [[ $used -eq 100 ]]; then
  echo "$used% used: FULL"
elif [[ $used -ge 90 ]]; then
  echo "$used% used: CRITICAL"
elif [[ $used -ge 70 ]]; then
  echo "$used% used: WARNING"
else
  echo "$used% used: OK"
fi
```

Notice the boundaries: 70 is WARNING, 90 is CRITICAL. "Or more" in the spec
translates to `-ge`, not `-gt`. Off-by-one boundaries are the classic bug here.

## Try it by hand

```bash
for n in 9 69 70 89 90 100; do ./solution.sh "$n"; done
```

## An alternative

The sort-it-yourself alternative is to put the most common case first and
add `&&` to bound each band, for example `-ge 70 && -lt 90`. That makes each rung
independent of order, but it is longer; a top-down ladder is shorter and
reads like the runbook.
