# Walkthrough: Operator Precedence

## The plan

One server costs `BASE + GB * RATE`. The whole fleet costs that amount times
`SERVERS`. The first formula needs no help from us; the second needs the
addition to finish before the multiplication starts.

## Precedence in one table

From strongest to weakest, the ones we care about:

| operators | meaning |
|---|---|
| `( )` | do this first |
| `*` `/` `%` | multiply, divide, remainder |
| `+` `-` | add, subtract |

Operators at the same level are evaluated left to right.

## Building it

Per-server price. With 100 GB at a rate of 2 and a base of 20, the multiplication
runs first (200) and the base is added afterwards (220):

```bash
echo "per_server=$(( base + gb * rate ))"
```

The total is where beginners slip. Without parentheses, `base + gb * rate *
servers` would multiply only the traffic charge by the number of servers and add
the base fee once. We want everything multiplied:

```bash
echo "total=$(( (base + gb * rate) * servers ))"
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

servers="$1"
base="$2"
gb="$3"
rate="$4"

echo "per_server=$(( base + gb * rate ))"
echo "total=$(( (base + gb * rate) * servers ))"
```

## Try it by hand

```bash
./solution.sh 3 20 100 2
echo $(( 20 + 100 * 2 * 3 ))     # the buggy version: 620, not 660
```

## An alternative

Store the per-server price first and reuse it:

```bash
per_server=$(( base + gb * rate ))
echo "total=$(( per_server * servers ))"
```

That is easier to read and avoids repeating the formula. It needs a variable
to hold the intermediate result, which is the trade-off the parentheses avoid.
