# Walkthrough: Error Spike Detector

## The plan
"Errors per minute" means: take the error lines, throw away everything except
the minute they happened in, and count how often each minute appears. Anything
at or above the threshold is a spike.

## Step by step
1. Validate both arguments. A threshold of zero would flag every minute that
   has no errors at all, so it has to be at least 1.

2. Select real error lines. A plain `grep ERROR` also catches `INFO ERROR page
   is cached`, so anchor the pattern to the third word:

   ```bash
   grep -E '^[0-9-]+ [0-9:]+ ERROR ' "$log"
   ```

3. Reduce each line to its minute. The timestamp has a fixed width, so
   `cut -c1-16` keeps `2026-03-01 14:05`:

   ```bash
   ... | cut -c1-16
   ```

4. Count the groups. `uniq` counts only neighbouring duplicates, so `sort`
   first. Because the timestamps are year-first, sorting them as text is
   sorting them by time:

   ```bash
   ... | sort | uniq -c
   ```

5. Read the counted lines back (`count day minute`), compare to the limit,
   and print the spikes. Count them in a variable, so the loop must read from
   a process substitution (`done < <(...)`) rather than being the end of a pipe.

   `grep` exits with status 1 when nothing matches, which `set -e` and
   `pipefail` would treat as failure, so wrap it: `{ grep ... || true; }`.

## Try it by hand
```
printf '2026-03-01 14:05:01 ERROR a\n2026-03-01 14:05:09 ERROR b\n' > t.log
./solution.sh t.log 2; echo $?
```

## Alternative
One `awk` program with an array keyed by minute does the counting without
`sort | uniq -c`, and is a good tool when you also need sums or averages. The
pipeline version is preferred here because each stage can be run and checked by
itself.
