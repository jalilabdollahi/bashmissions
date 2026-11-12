# Walkthrough: Column Statistics

## The plan
One pass, five running values: how many numbers (`n`), their `sum`, the
smallest, the largest, and how many cells had to be skipped. The average is
derived at the end from `sum` and `n`.

## Step by step
1. **Find the column.** In the header rule, loop over the fields and remember
   the position whose text equals the requested name. If nothing matched,
   `col` is still empty (false), so print the error on stderr and exit 1.

2. **Skip what is not data.** Blank lines go straight to `next`. After
   `sub(/\r$/, "")` has run, Windows files look like any other.

3. **Is it a number?** `$col ~ /^-?[0-9]+(\.[0-9]+)?$/` accepts `120.50`, `80`
   and `-20.25`, and rejects empty cells and `pending`. Cells that fail only
   increase `skipped`; they do not poison the sum.

4. **Update the statistics.** `v += 0` turns the cell into a real number.
   `if (n == 1 || v < min) min = v` seeds the minimum from the first value. If
   `min` started at 0, a column of only negative values would report the wrong
   maximum, and a column of only positive values the wrong minimum.

5. **Report.** `printf "%.2f"` gives fixed decimals. `sum / n` is only computed
   when `n > 0`; dividing by zero is a fatal error in awk.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, -v name="$2" '
  { sub(/\r$/, "") }
  NR == 1 { for (i = 1; i <= NF; i++) if ($i == name) col = i
            if (!col) { print "unknown column: " name > "/dev/stderr"; failed = 1; exit 1 }
            next }
  $0 == "" { next }
  { v = $col
    if (v ~ /^-?[0-9]+(\.[0-9]+)?$/) { v += 0; n++; sum += v
      if (n == 1 || v < min) min = v
      if (n == 1 || v > max) max = v
    } else skipped++ }
  END { if (failed) exit 1
        printf "count=%d\nskipped=%d\n", n, skipped
        if (n > 0) printf "sum=%.2f\nmin=%.2f\nmax=%.2f\navg=%.2f\n", sum, min, max, sum / n }
' "$1"
```

## Try it by hand
```bash
printf '3\n9\n-4\n' | awk '{ if (NR == 1 || $1 < m) m = $1 } END { print m }'
./solution.sh payments.csv amount
```

## Alternative
`sort -n | head -1` finds the minimum and `tail -1` the maximum, and `paste -sd+`
with `bc` sums, but that is four tools and several passes, and none of them
skips bad cells for you. A single awk pass is shorter and handles the mess.
