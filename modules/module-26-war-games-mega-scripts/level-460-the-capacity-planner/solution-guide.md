# Walkthrough: The Capacity Planner

## The plan
A forecast is just three steps: summarise each disk's history as a growth rate, divide the
remaining space by it, and translate the answer into a date a human can read. The only
unusual ingredient is the calendar. `date -d` and `date -j` differ between macOS and Linux,
so the script does its own day arithmetic: it converts every date into a day number (days
since 1970-01-01), where "twelve days later" is plain addition, and converts back at the end.

## Step by step
1. **Options and validation.** A `while`/`case` loop takes `--warn` and `--crit`, insisting
   on `^[0-9]+$`. Every usage problem exits 3, not 2, because the exit codes 0, 1 and 2 are
   reserved for the verdict (the convention of monitoring plugins: OK, WARNING, CRITICAL,
   UNKNOWN).

2. **Day numbers.** The `days(y, m, d)` function treats March as the first month, so the
   leap day lands at the *end* of the year and needs no special case: `y -= (m <= 2)`, count
   400-year eras, then `doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1`. `civil(z)` is the
   inverse. Both use only `int()`, so they work in any POSIX awk.

3. **Group and collect.** Use `$2 SUBSEP $3` as the key. Store every `(day, used)` pair
   because the regression needs them all. Track the newest sample separately: rows may come
   in any order, so "last" means "largest day number", not "last line". Bad rows (wrong field
   count, bad date, non-numeric or zero total) are counted, and the count is reported once
   from `END`.

4. **Regression.** Shift x to "days since the first sample" so the sums stay small, then
   `slope = (n*Sxy - Sx*Sy) / (n*Sxx - Sx^2)`. A flat or shrinking disk has slope <= 0 and
   gets `-` instead of a date, because dividing by it would be nonsense.

5. **Verdict.** `int((total - used) / slope)` rounds down: the disk is full *during* that
   day, so under-promising is correct. The status is the strictest rule that applies, and
   the 95 percent rule overrides the forecast: a full disk that has stopped growing is still
   an emergency.

6. **Order.** awk prints a numeric key first, `sort -t'|' -k1,1n -k2,2 -k3,3` orders by it,
   and the table printer ignores that first field. Non-growing critical disks get -1 (top),
   other flat disks 900000, NODATA 999999.

7. **Verdict as exit status.** Count statuses with one more awk pass and finish with
   `exit 2` / `exit 1`.

## Try it by hand
```
./solution.sh --warn 30 --crit 7 fixtures/samples.csv; echo "exit=$?"
```

## Alternative
Using only the first and last sample is simpler: `(last - first) / days`. It is also fragile,
because one noisy first reading (a temporary file, a snapshot) skews the whole forecast. The
least-squares line uses every sample, so a single outlier moves the answer much less.
