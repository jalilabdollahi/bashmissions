# Walkthrough: Status Code Breakdown

## The plan
Turn each request into a bucket name (`2xx`, `404` becomes `4xx`, junk becomes
`other`), count requests per bucket, and print the buckets from a fixed list so
the report always has the same six lines.

## Step by step
1. **Clean input.** Strip `\r`, skip blank lines. Every remaining line is a
   request, so `total++` happens before any other decision. This is why a line
   with a broken status still counts: it is evidence that something happened.

2. **Classify.** If field 4 matches `^[1-5][0-9][0-9]$` it is a real status code,
   and `substr($4, 1, 1) "xx"` builds the bucket name by gluing `xx` onto the
   first digit. Otherwise the bucket is `other`. A line with only three fields
   has an empty `$4`, which fails the regex and lands in `other` too.

3. **Count.** `count[cls]++`.

4. **Report in fixed order.** `for (k in count)` would print only buckets that
   exist, in an unspecified order. Instead `split("1xx 2xx ... other", names, " ")`
   gives a list you control, and the loop prints each name. An empty bucket is
   an unset element, and `count[...] + 0` turns it into 0.

5. **Percent.** `100 * c / total`, guarded: if the log is empty, `total` is 0
   and the division would crash awk, so use 0. In `printf`, `%%` prints a
   literal percent sign.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk '
  { sub(/\r$/, "") }
  $0 == "" { next }
  { total++
    if ($4 ~ /^[1-5][0-9][0-9]$/) cls = substr($4, 1, 1) "xx"
    else cls = "other"
    count[cls]++ }
  END { n = split("1xx 2xx 3xx 4xx 5xx other", names, " ")
        for (i = 1; i <= n; i++) {
          c = count[names[i]] + 0
          pct = (total > 0) ? 100 * c / total : 0
          printf "%s %d %.1f%%\n", names[i], c, pct
        }
        printf "total %d\n", total + 0 }
' "$1"
```

## Try it by hand
```bash
./solution.sh req.log
awk 'BEGIN { printf "%.1f%%\n", 100 * 3 / 8 }'
```

## Alternative
`cut -d' ' -f4 | cut -c1 | sort | uniq -c` gives a frequency table, but with
no zero rows, no `other` bucket, no percentages and a different shape on every
run. A report that other people read needs a stable layout.
