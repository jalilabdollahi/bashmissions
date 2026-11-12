# Walkthrough: Time Window Filter

## The plan
Do no time arithmetic at all. ISO-8601 timestamps in a single time zone are
built so that text order equals time order, so a window filter is two string
comparisons.

## Why it works
`2026-03-04T14:05:10Z` has the most significant unit first, and every field has
a fixed width thanks to zero padding (`03`, not `3`). Comparing two such
strings character by character looks at the year first, then the month, and so
on, exactly like comparing the moments they stand for. This breaks for formats
like `4/3/2026` (day first) or `2026-3-4` (no padding), and for mixed time zones,
which is why lines that do not match the exact shape are rejected rather than
compared.

## Step by step
1. **Arguments.** Check `$#`, then check `[[ $2 > $3 ]]`. Inside `[[ ]]` the `>`
   operator compares strings, which is precisely what we want here. Use an
   `if` so that `set -e` is never triggered by a false `&&`.

2. **Pass the bounds in with `-v`.** `-v from="$2" -v to="$3"`.

3. **Shape check.** A regex with 4-2-2 digits, `T`, 2-2-2 digits and `Z`. A line
   failing it gets `skipped line NR` on stderr and `next`.

4. **The window.** `$1 >= from && $1 < to` as a pattern with no action prints
   the line. The lower bound is inclusive and the upper exclusive, so adjacent
   windows share no line. Because bounds are compared as text, `2026-03-04`
   works as "the start of that day" and `2026-03-04T14` as "14:00".

## Complete solution
See `answer.sh`; the key line is `$1 >= from && $1 < to`.

## Try it by hand
```bash
./solution.sh deploys.log 2026-03-04T14:00:00Z 2026-03-04T15:30:00Z
[[ 2026-03-04T09:00:00Z < 2026-03-04T10:00:00Z ]] && echo earlier
```

## Alternative
Convert every timestamp to epoch seconds with `date -d`. That is slow (one
process per line), different on GNU and BSD `date`, and unnecessary here. Text
comparison is fast and portable, as long as the format is strictly ISO and in
one time zone.
