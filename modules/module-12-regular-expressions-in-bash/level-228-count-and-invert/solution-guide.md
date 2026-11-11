# Walkthrough: Count and Invert

## The plan
Two numbers, one shared filter. A "real entry" is any line that is not a comment
and not empty. Count those, then count the failures among them.

## Step 1: invert the junk pattern
Comments and empty lines are `^#` and `^$`. One regex for both: `^(#|$)`. Since
we want everything *except* those, use `-v`:

```bash
grep -v -E '^(#|$)' "$log"
```

## Step 2: count
`-c` makes grep print a number instead of lines. Here the filtered text arrives
on stdin from the first grep, and the second grep counts:

```bash
entries=$(grep -v -E '^(#|$)' "$log" | grep -c '' || true)
```

The empty pattern `''` matches every line, so this simply counts lines. You
can also fold both steps into one call, `grep -c -v -E '^(#|$)' "$log"`; the
pipeline version is shown because the same filter feeds both numbers.

For failures, filter first, then count:
```bash
failed=$(grep -v -E '^(#|$)' "$log" | grep -c 'Failed password' || true)
```

## The zero trap
`grep -c` with no match *prints 0* but exits 1. Inside `$( )` with `set -e`
(and `pipefail`) that status would stop the script. `|| true` swallows the
status while the `0` that grep printed is kept.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
printf '# note\nFailed password for x\n\nok line\n' > t.log
./solution.sh t.log
```
The answer is `entries: 2` and `failed: 1`.

## Alternative
`grep -c -v -E '^(#|$)' "$log"` for the first number is shorter, and
`grep -v -E '^(#|$)' "$log" | wc -l` would do too, but `wc -l` pads its output
with spaces on macOS. `grep -c` prints a clean number everywhere.
