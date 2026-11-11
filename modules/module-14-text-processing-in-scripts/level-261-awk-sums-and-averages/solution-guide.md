# Walkthrough: awk Sums and Averages

## The plan
Two phases: while the lines go by, accumulate; once they have all gone by,
report. awk has a block for each: the main block runs per line, and `END` runs
once after the last one.

## Step by step
1. Accumulate. In the main block, add the amount to a variable:

   ```awk
   { total += $3 }
   ```

   There is no declaration. An awk variable that was never assigned is `0` in
   a number context, so the first `+=` just works. The value persists from
   line to line.

2. Know the count. awk keeps `NR`, the number of records (lines) read so far.
   In the `END` block it holds the total number of lines, so we do not need
   our own counter.

3. Compute the average carefully. Dividing by `NR` fails when the file is
   empty, so use the conditional expression `(NR > 0) ? total / NR : 0`.

4. Print with printf. `%d` is an integer, `%.2f` is a number with two
   decimals, so `5` prints as `5.00` and `18.3333` as `18.33`. Unlike `print`,
   `printf` does not add a newline, so end the format with `\n`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk '
  { total += $3 }
  END {
    avg = (NR > 0) ? total / NR : 0
    printf "count=%d total=%.2f avg=%.2f\n", NR, total, avg
  }
' "$1"
```

## Try it by hand
```bash
printf 'a x 1.5\nb y 2.5\n' > e.txt
./solution.sh e.txt                   # count=2 total=4.00 avg=2.00
awk '{ s += $3 } END { print s }' e.txt
awk 'BEGIN { print 10 / 4 }'          # 2.5, awk does real division
```

## Alternative
A Bash loop with `read` can add up integers, but Bash cannot do decimal
arithmetic at all; you would need `bc`, which is not available everywhere.
awk does floating-point maths natively and processes the whole file in a
single pass.
