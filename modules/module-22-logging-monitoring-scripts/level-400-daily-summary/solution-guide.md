# Walkthrough: Daily Summary

## The plan
A report is a few facts plus layout. Gather the facts in one pass over all the
files (counts per level, errors per host, the earliest and latest error), emit
them as a small tagged list, and let the shell lay out the report from that
list.

## Step by step
1. Validate the date with a regex and require at least one file. Then check
   every file is readable before printing anything: a half-printed report with
   a failure at the end is worse than none.

2. One `awk` over all files (`"$@"` after the `shift`). The condition
   `$1 == day && NF >= 4` keeps only well-formed lines of that day. It counts
   the total and `level[$3]++`. For ERROR lines it also counts
   `host[$4]++` and tracks the smallest and largest time seen so far. The
   files are not merged or sorted, so you really do compare each time with the
   current record. Times like `08:14:03` sort correctly as plain text, and no
   date arithmetic is needed.

3. In `END` print tagged lines: `LINES 9`, `INFO 3`, `HOST eel 2`, `FIRST
   08:14:03 eel`. Use `+ 0` so a missing level prints 0 instead of nothing.

4. Print the report. A small helper picks a value out of the tagged data
   (`awk '$1 == "INFO" {print $2}'`). For the top hosts:

   ```bash
   awk '$1 == "HOST" {print $2, $3}' <<< "$data" | sort -k2,2nr -k1,1 | head -n 3
   ```

   `-k2,2nr` sorts the second column numerically in reverse (biggest first);
   `-k1,1` breaks ties alphabetically.

5. When a value is empty (no errors) fall back to `none` with `${first:-none}`.

## Try it by hand
```
printf '2026-03-01 08:14:03 ERROR eel boom\n2026-03-01 09:00:00 INFO eel ok\n' > eel.log
./solution.sh 2026-03-01 eel.log
```

## Alternative
Run `grep -c` once per level per file. It is simple, but it reads each file
four or five times and cannot track hosts and times at all. One awk pass reads
each line exactly once, which matters when the logs are gigabytes.
