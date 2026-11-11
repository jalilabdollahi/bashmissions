# Walkthrough: Sort by Key and Number

## The plan
Each line is a row, `used_gb` is the third column, and the host is the first.
We want a two-level ordering: size descending, then host ascending. `sort`
supports exactly that with repeated `-k` options.

## Step by step
1. Tell `sort` where the fields are. `-t,` makes the comma the separator
   (otherwise it splits at blanks, and `dory,/data,430` would be one field).

2. Choose the first key. `-k3,3` means "from field 3 to field 3". The `,3` is
   important: without it the key runs from field 3 to the end of the line.

3. Add the flags to the key. `n` compares numerically, so 95 is smaller than
   120. `r` reverses the comparison, so the biggest comes first. Written
   together: `-k3,3nr`.

4. Add the tie-breaker `-k1,1`. `sort` only looks at the second key when the
   first compares equal, so this orders `dory` before `flounder` when both use
   430 GB.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sort -t, -k3,3nr -k1,1 "$1"
```

## Try it by hand
```bash
printf 'a,/x,9\nb,/x,10\nc,/x,10\n' > d.csv
./solution.sh d.csv              # b and c (10), then a (9)
sort -t, -k3,3n d.csv            # ascending instead
sort -t, -k3 d.csv               # careful: key runs to end of line
```

## Alternative
A global `-n -r` flag (`sort -t, -k3 -nr`) also works for a single key, but with
several keys it applies one comparison to all of them. Attaching the flags to
each `-k` keeps every rule explicit, which is why professionals prefer it.
