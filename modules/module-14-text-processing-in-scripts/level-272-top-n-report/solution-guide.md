# Walkthrough: Top-N Report

## The plan
A leaderboard is a pipeline of small, single-purpose filters. We write it
left to right, testing after each stage: select, count, rank, cut off, number.

## Step by step
1. Select. awk keeps the lines whose fourth field is exactly `NXDOMAIN` and
   prints only the name (field 3):

   ```bash
   awk '$4 == "NXDOMAIN" { print $3 }' "$log"
   ```

2. Count. Equal names must be neighbours before `uniq -c` can count them, so
   `sort | uniq -c`. The count comes out padded with spaces, in a width that
   depends on the platform, so remove the leading blanks: `sed 's/^ *//'`.
   Every line is now `<count> <name>`.

3. Rank. A second sort orders by count, numerically and descending
   (`-k1,1nr`). For ties, `-k2,2` sorts the names alphabetically, so the report
   is the same on every run.

4. Cut off. `head -n "$n"` keeps the first N lines. If there are fewer lines
   than N it just keeps them all, which is the required behaviour.

5. Number. The last awk prints rank, name and count. `NR` is the number of the
   current line, so it is the rank:

   ```bash
   awk '{ printf "%d. %s (%d)\n", NR, $2, $1 }'
   ```

6. The title goes first, with `echo`, outside the pipeline. If no line passes
   the filter, the pipeline prints nothing and only the title remains.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
log=$1 n=$2
echo "Top $n NXDOMAIN names"
awk '$4 == "NXDOMAIN" { print $3 }' "$log" |
  sort | uniq -c | sed 's/^ *//' |
  sort -k1,1nr -k2,2 |
  head -n "$n" |
  awk '{ printf "%d. %s (%d)\n", NR, $2, $1 }'
```

## Try it by hand
```bash
./solution.sh resolver.log 3
awk '$4 == "NXDOMAIN" { print $3 }' resolver.log | sort | uniq -c   # stop after any stage
```

## Alternative
One awk program could count into an array, but you would still need to sort and
cut off the result. The pipeline keeps each step trivial to read and to test
on its own, which is why it is the usual style for reports like this.
