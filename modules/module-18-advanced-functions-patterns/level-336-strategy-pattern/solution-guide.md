# Walkthrough: Strategy Pattern

## The plan

The loop that formats invoice lines should be written once. The only thing
that varies between customers is *how to round*. So the rounding is a function
picked before the loop; the loop calls "whatever strategy was picked".

## Step by step

Three functions with one signature, cents in, euros out. Integer arithmetic
does all the work:

```bash
round_nearest() { echo $(( ($1 + 50) / 100 )); }
round_up()      { echo $(( ($1 + 99) / 100 )); }
round_down()    { echo $(( $1 / 100 )); }
```

Integer division drops the fraction. Adding 50 first makes everything from
.50 up reach the next euro; adding 99 does that for any fraction above zero.

Pick the strategy once, from the argument, and store the *function name*:

```bash
case $1 in
  nearest) strategy=round_nearest ;;
  up)      strategy=round_up ;;
  down)    strategy=round_down ;;
  *) echo "unknown strategy: $1" >&2; exit 2 ;;
esac
```

In the loop, no mention of rounding rules at all:

```bash
while read -r cents; do
  [[ -z $cents ]] && continue
  [[ $cents =~ ^[0-9]+$ ]] || { echo "skip: '$cents' is not an amount" >&2; bad=1; continue; }
  echo "${cents}c -> $("$strategy" "$cents") EUR"
done
exit "$bad"
```

`"$strategy" "$cents"` expands the variable to a function name, then runs it.

## Try it by hand

```
printf '1249\n1250\n' | ./solution.sh nearest
printf '1201\n' | ./solution.sh up
echo 12.50 | ./solution.sh down; echo "exit=$?"
```

## Alternative

Put the `case` inside the loop and decide on every line. It gives the same
output and is shorter for two strategies, but the rule is then tangled into the
loop, repeated per line, and every new strategy has to touch the loop.
