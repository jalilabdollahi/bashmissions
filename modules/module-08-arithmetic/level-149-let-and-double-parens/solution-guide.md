# Walkthrough: let and (( ))

## The plan

Two ways of doing the same arithmetic live side by side, and the exit
status of both has a surprising rule. We use `let` for the free space, `(( ))`
for the percentage, and keep an eye on `$?` right after `let`.

## `let` and `(( ))` compared

| | `let` | `(( ))` |
|---|---|---|
| assign | `let "x = a + b"` | `(( x = a + b ))` |
| quoting | needed when spaces are used | not needed |
| status | 0 if result is non-zero, 1 if zero | the same |
| age | old, from the Korn shell | recommended style |

## Building it

```bash
let "free = total - used"
let_status=$?
```

The quotes make the whole expression a single argument. Without them,
`let free = total - used` would be five separate arguments and fail.

The very next line grabs `$?`. Any later command, even an `echo`, would replace
it. When the volume is exactly full, `free` is 0 and `let` reports failure
(status 1): "the last expression evaluated to false". That is not an error in
the arithmetic, only the way the status is designed.

Then the percentage:

```bash
(( used_pct = used * 100 / total ))
```

Multiplying before dividing keeps precision: `10 / 30 * 100` would be 0, but
`10 * 100 / 30` is 33.

## Complete solution

```bash
#!/usr/bin/env bash
set -uo pipefail

total="$1"
used="$2"

let "free = total - used"
let_status=$?

(( used_pct = used * 100 / total ))

echo "free=$free"
echo "used_pct=$used_pct"
echo "let_status=$let_status"
```

## Try it by hand

```bash
./solution.sh 500 125
./solution.sh 200 200
```

## An alternative

`free=$(( total - used ))` is a plain assignment whose status is always 0. It is
the safest form under `set -e`. `let` is worth knowing so you can read old
scripts, but new code should prefer `(( ))` or `$(( ))`.
