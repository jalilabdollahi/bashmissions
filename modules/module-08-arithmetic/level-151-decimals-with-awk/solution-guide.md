# Walkthrough: Decimals with awk

## The plan

Bash can only count with whole numbers, so for dollars and cents we hand the
calculation to `awk`, which uses floating point numbers. We pass the three
arguments into awk, multiply, divide, and print with two decimals.

## Building it

Try the limit first:

```bash
echo $(( 250.5 * 0.12 ))      # error: invalid arithmetic operator
```

awk does not need an input file when the program lives in a `BEGIN` block, which
runs once at the start:

```bash
awk 'BEGIN { print 250.5 * 0.12 }'
```

To get shell values into awk safely, use `-v name=value`. The program text
stays in single quotes, so the shell does not touch it:

```bash
awk -v gb="$gb" -v rate="$rate" -v servers="$servers" 'BEGIN { ... }'
```

`printf "%.2f"` prints a number with exactly two decimals, rounding the rest.
It is the same `printf` format you already know from the shell:

```bash
printf "total=$%.2f\n", total
```

The `$` before `%` is plain text in awk's printf, so it comes out as a dollar
sign.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

gb="$1"; rate="$2"; servers="$3"

awk -v gb="$gb" -v rate="$rate" -v servers="$servers" 'BEGIN {
  total = gb * rate
  printf "total=$%.2f\n", total
  printf "per_server=$%.2f\n", total / servers
}'
```

## Try it by hand

```bash
./solution.sh 250.5 0.12 2
awk 'BEGIN { printf "%.3f\n", 22 / 7 }'     # 3.143
```

## An alternative

Embedding values directly into the awk text (`awk "BEGIN { print $gb * $rate }"`)
works for simple values but breaks on odd input and invites quoting bugs. With
`-v` the data and the program stay separate, which is both safer and easier to read.
