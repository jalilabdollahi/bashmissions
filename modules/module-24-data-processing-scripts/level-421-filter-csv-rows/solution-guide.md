# Walkthrough: Filter Rows

## The plan
A filter keeps a row when all of its conditions are true. In awk that is a
pattern made of comparisons joined with `&&`, and a pattern without an action
prints the line. The work is deciding what "true" means for messy cells.

## Step by step
1. **Arguments.** Check `$#` first and fail with exit status 2, the usual
   "you called me wrong" code.

2. **Give awk the values.** `-v region="$2" -v min="$3"` creates awk variables.
   This is safer than pasting `$2` into the awk program text: a region with a
   space or a quote cannot change the program.

3. **Header and `\r`.** One rule removes a trailing carriage return from every
   line, then `NR == 1 { print; next }` prints the header and skips the rest of
   the rules for it.

4. **Region.** `$2 == region` is an exact string comparison, so `Harbour` does
   not match `harbour`.

5. **A number or not.** `n/a` and empty cells must not pass. The regex
   `/^[0-9]+(\.[0-9]+)?$/` accepts `9`, `12.5`, rejects `n/a` and the empty
   string.

6. **Compare as numbers.** `$3 + 0 >= min + 0` forces numeric comparison.
   Otherwise `9 >= 10` is decided character by character, and "9" wins.

7. **Tier.** `$4 != "retired"`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
[[ $# -lt 3 ]] && { echo "usage: solution.sh FILE REGION MIN_GB" >&2; exit 2; }
awk -F, -v region="$2" -v min="$3" '
  { sub(/\r$/, "") }
  NR == 1 { print; next }
  $2 == region && $3 ~ /^[0-9]+(\.[0-9]+)?$/ && $3 + 0 >= min + 0 && $4 != "retired"
' "$1"
```

## Try it by hand
```bash
./solution.sh bandwidth.csv "north pier" 10
awk 'BEGIN { print ("9" > "10"), (9 > 10) }'     # 1 0
```

## Alternative
A `read` loop with `(( ))` can filter too, but `(( ))` is integer-only, so the
decimals (12.5 GB) would need extra work. awk does floating-point comparisons
natively.
