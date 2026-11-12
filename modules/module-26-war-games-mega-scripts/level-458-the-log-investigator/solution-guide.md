# Walkthrough: The Log Investigator

## The plan
Three teams, three formats: the answer is *normalise first, then everything else is easy*.
Each input line is turned into one fixed record, `TS|FILE|LINE|SERVICE|LEVEL|MESSAGE`.
After that the merge is a `sort`, the timeline is a `printf`, and the summary is a few
one-line awk passes. The same design is how real log shippers work: parsers at the edge,
one canonical schema in the middle.

## Step by step
1. **Fail early.** Check the argument count, both timestamps with
   `^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$`, the order of the window
   (`[[ $from < $to ]]` is a string comparison, valid because the format is zero padded),
   and that every file is readable. Nothing may be printed before these checks pass.

2. **A scratch directory.** `work=$(mktemp -d)` with `trap 'rm -rf "$work"' EXIT`. It holds
   the merged events and the per-file counters.

3. **One awk program, three parsers.** Build the three regexes in `BEGIN` from `[0-9]`
   classes; interval expressions are not portable to every awk. For format A the
   timestamp is `substr($0, 2, 19)`. For B it is the date part, a space, and the time part
   (`substr($0, 1, 10) " " substr($0, 12, 8)`), and the message is everything after the
   third `|`, so it can contain pipes. Format C has no year, so the program receives it
   with `-v year=`; the month name goes through a lookup table, and the day is padded with
   `gsub(/ /, "0", day)`. A trailing `[LEVEL]` is optional there.

4. **Normalise and filter.** `WARNING`, `CRITICAL`, `ERR` map to `WARN`, `CRIT`, `ERROR`.
   Test the window with string comparisons, count `inwin`, and print an event only when
   its rank is at least WARN. The counters go to a stats file in the `END` block.

5. **Merge.** Files are processed in command-line order and numbered, so
   `sort -t'|' -k1,1 -k2,2n -k3,3n` gives time, then file, then line. Two events in the same
   second never swap places between runs.

6. **Report.** Rebuild the message from fields 6 to NF (it may have been split on `|`),
   print with `%-8s %-5s`, then derive `first error` (first line whose level is ERROR or
   CRIT) and `by service` (an awk counter, `sort`, `paste -s -d' ' -`). Finally exit 1 if a CRIT
   line exists; that is the signal a pager script can act on.

## Try it by hand
```
./solution.sh "2026-11-12 03:00:00" "2026-11-12 03:30:00" fixtures/*.log
echo "exit=$?"
```

## Alternative
You could convert everything to epoch seconds and sort numerically. That is needed
once windows cross midnight or time zones appear, but it requires date arithmetic that is
not portable between macOS and Linux. Because the data here is already zero-padded
ISO text, plain string comparison is simpler and cannot get the arithmetic wrong.
