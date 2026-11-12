# Walkthrough: Metrics File

## The plan
Prometheus does not push or poll your script; it reads a text file (or a URL)
in a fixed format. You compute the numbers from the log, print them in that
format, and publish the file so that a reader can never catch it mid-write.

## The format in one minute
```
# HELP name What this number means.
# TYPE name counter
name{label="value"} 42
```
A *counter* only ever goes up (requests served since the log began). A *gauge*
can go up and down (the largest response right now). The type tells the server
how to draw and calculate with the series.

## Step by step
1. Validate arguments and that the log is readable.

2. Aggregate with `awk`. A valid line has exactly five fields, with the status
   and bytes made of digits; `NF == 5 && $4 ~ /^[0-9]+$/ && $5 ~ /^[0-9]+$/`
   says so. Everything else increments a malformed counter. Print the totals
   in `END` with `+ 0` so an empty log yields `0` and not an empty string.

3. Count per status code in a second `awk` with an array, pipe through
   `sort -n` so 503 does not sort before 1000 by text order.

4. Print the file into `"$out.tmp"` with a `{ ...; } > file` group. The
   `printf 'name{code="%s"} %s\n'` form puts the label in place. Skip the sample
   lines when there are no codes (an empty `read` result).

5. `mv "$out.tmp" "$out"`. A rename within one directory is atomic, so the
   scraper sees the old file or the new one.

## Try it by hand
```
printf '2026-03-01T10:00:01Z GET /menu 200 5123\n' > access.log
./solution.sh access.log web.prom && cat web.prom
```

## Alternative
Write straight into `OUTFILE`. For a one-off that is fine, but a scrape that
lands in the middle of the write sees a truncated file, and the dashboard
shows a false drop to zero.
