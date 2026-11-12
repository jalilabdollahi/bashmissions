# Walkthrough: Coverage Gate

## The plan
A gate is a number compared with a limit. The two traps are decimals (Bash
has none) and trusting input blindly. Both are solved by arithmetic on whole
numbers and a regex before any `$(( ))`.

## Steps
Validate arguments first. A threshold must be digits only and at most 100:

```bash
if [[ ! $threshold =~ ^[0-9]+$ ]] || (( threshold > 100 )) || [[ -z $report ]]; then
  echo "usage: solution.sh THRESHOLD REPORT" >&2; exit 2
fi
```

The regex runs before the arithmetic on purpose: `$(( x ))` with `x=abc` would
treat `abc` as a variable name and quietly give 0.

Read the report while counting every line number (comments included, so the
error message points at the real line). Parse each data line with captures, and
use `10#` so `08` is not taken for octal. Keep `paths`, `covs` and `tots` in
parallel arrays and add to `sum_cov` and `sum_tot`.

Now the percentage. To show 82.5 you work in tenths:

```bash
t=$(( (cov * 1000 + tot / 2) / tot ))     # adding tot/2 rounds half up
echo "$(( t / 10 )).$(( t % 10 ))"
```

The pass/fail decision must not use that rounded text. A ratio
`cov/tot >= limit/100` is the same as `cov*100 >= limit*tot`, which is exact:

```bash
if (( sum_cov * 100 >= threshold * sum_tot )); then echo "gate: PASS"
else echo "gate: FAIL"; exit 1; fi
```

That is why 1999 of 2500 lines prints 80.0% yet fails an 80% gate: the true
value is 79.96%.

## Try it by hand
```bash
printf 'a.py 9 10\nb.py 5 10\n' > cov.txt
./solution.sh 70 cov.txt; echo "exit $?"
```

## Alternative
`awk '{c+=$2; t+=$3} END {printf "%.1f", c*100/t}'` is the usual one-liner, but
it hides rounding, has no exact gate, and the validation would move into awk
as well. Integer Bash keeps every decision visible.
