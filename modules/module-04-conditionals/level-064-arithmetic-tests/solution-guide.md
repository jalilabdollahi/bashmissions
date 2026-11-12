# Walkthrough: Arithmetic Tests

## The plan

We need one yes/no question ("is used greater than quota?") and one subtraction
whose direction depends on the answer. Bash's double parentheses do both: the
statement form `(( ... ))` is a test, and the expansion form `$(( ... ))` gives
you the calculated number to paste into text.

## Building it

```bash
used="$1"
quota="$2"
```

The test reads exactly like maths. Note that variables inside `(( ))` are
written without `$`:

```bash
if (( used > quota )); then
```

Exit status is the clever part: `(( ))` succeeds (true) when the expression
is non-zero and fails when it is zero, so `if` can use it directly. Comparison
operators evaluate to 1 (true) or 0 (false).

In the message, `$(( used - quota ))` is replaced by the result of the sum:

```bash
  echo "over quota: $used GB used of $quota GB (+$(( used - quota )) GB)"
else
  echo "within quota: $used GB used of $quota GB ($(( quota - used )) GB left)"
fi
```

Equal usage lands in the `else` branch because `>` is strict, and the spec says
equal counts as within quota.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

used="$1"
quota="$2"

if (( used > quota )); then
  echo "over quota: $used GB used of $quota GB (+$(( used - quota )) GB)"
else
  echo "within quota: $used GB used of $quota GB ($(( quota - used )) GB left)"
fi
```

## Try it by hand

```bash
./solution.sh 340 300
./solution.sh 500 500
```

## An alternative

`[[ $used -gt $quota ]]` gives the same answer, and so does `[ ]`. The `(( ))`
form wins when you also need arithmetic in the same condition, such as
`(( used * 100 / quota > 90 ))`, which the double-bracket operators cannot do.
