# Walkthrough: Collapse Repeats

## The plan
A timeline of states should show a line only when something changed. "Changed"
means "different from the previous line", and that is exactly the comparison
`uniq` makes.

## Step by step
1. Read what `uniq` really does. It compares each line with the previous one
   and prints the line only if it is different. It never looks further back.

2. Run it on the monitor file:

   ```bash
   uniq "$1"
   ```

   For `OK OK OK SLOW SLOW DOWN OK OK` the first three OKs collapse into one,
   the two SLOWs into one, DOWN stands alone, and the two final OKs collapse.
   The late `OK` is printed because its neighbour is `DOWN`, not `OK`.

3. Do not sort. People remember `uniq` as "the unique-lines tool" and put a
   `sort` in front. That is a different job (a list of distinct values) and
   here it would produce `DOWN OK SLOW`, with no sense of when anything happened.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
uniq "$1"
```

## Try it by hand
```bash
printf 'OK\nOK\nDOWN\nOK\n' > h.txt
./solution.sh h.txt          # OK, DOWN, OK
sort h.txt | uniq            # DOWN, OK   (distinct values, no timeline)
uniq -d h.txt                # lines that were repeated
```

## Alternative
`awk '$0 != prev {print} {prev = $0}'` does the same with explicit logic, and
it is handy when you want to compare only one column. For whole lines, `uniq`
says the same thing in one word.
