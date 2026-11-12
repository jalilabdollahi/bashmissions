# Walkthrough: The Cron Analyzer

## The plan
Cron's schedule language is compact and nobody expands it in their head. The analyzer does it
mechanically for one chosen day: decide whether each job runs, list the minutes it starts, mark
every minute it keeps the machine busy, and then count how often two jobs are busy at once.
The whole day is only 1440 minutes, so a plain table (`occ[job, minute]`) is fast and also very
easy to reason about, much simpler than comparing intervals pair by pair.

## Step by step
1. **Validation in the shell.** `--min-shared` must be a positive integer, and MONTH, DOM and
   DOW must be numbers within their ranges. Failures exit 2 with the exact messages.

2. **Expanding a field.** `expand(f, lo, hi, set)` splits on commas and handles each part:
   `*` means the full range, `N` one value, `A-B` a range, and `/S` a step (`*/15`, `10-50/20`).
   It returns 0 for anything else, and the caller names the field in its warning. Day of week
   accepts 0-7 and then maps 7 onto 0.

3. **Parsing lines.** Blank lines, comments, `NAME=value` and `@reboot` are skipped. A trailing
   `# runs 25m` is matched with `match()` and stripped so it does not become part of the command.
   `@hourly` and friends are replaced by their five-field equivalents before the same expansion
   code runs, so there is one code path, not two.

4. **The day rule.** If either the day-of-month or the day-of-week field *begins with `*`*, both
   must match; if both are restricted, either is enough. That is why `0 3 1 * 0` runs on the first
   of the month and also on every Sunday. The rule is easy to get wrong because it is an OR where
   everything else in cron is an AND.

5. **Occupancy.** For each start minute `s` mark `occ[job, t]++` for `t = s .. s+run-1`, stopping
   at minute 1439. A job whose run time exceeds its interval ends up with `occ > 1`: it overlaps
   itself.

6. **Counting overlaps.** For every minute and every pair `a < b` busy at that minute,
   `shared[a SUBSEP b]++` and remember the first minute. Self-overlap minutes are counted from
   `occ > 1`. Overlap rows carry a numeric sort key `100000 - minutes` so that the shell's
   `sort -k1,1n` puts the biggest collisions first, with the job ids as tie-breaker.

7. **Output.** awk prints tagged rows; the shell prints the `T|` rows, the `== Overlaps ==`
   header, and the sorted `O|` rows, with exit status 1 if there were any.

## Try it by hand
```
./solution.sh 11 12 4 crontab.txt; echo "exit=$?"
```

## Alternative
Comparing `[start, end)` intervals for every pair of runs avoids the table, but becomes quadratic
for a job that fires every minute and needs extra care for midnight. The minute table makes
shared time something you can simply add up.
