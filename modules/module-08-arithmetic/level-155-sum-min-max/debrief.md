# Debrief: Sum, Min, Max

## What you learned

A single-pass statistic keeps just enough state to answer the question: a few
numbers that are updated as each item goes by. The pattern is called an
accumulator, and it works on a file of ten lines or a stream of ten billion,
with the same tiny memory use.

## Under the hood

The thing every beginner trips over is the starting value. A neutral start
exists for sums (0) and counts (0), but not for min and max: no number
is "smaller than everything", and picking one (such as 999999) just
postpones the bug. The reliable answer is to initialise from the first value
you really see. The `count == 0` test does that, and the same variable is later
reused as the "is there any data?" check.

Other details: integer division truncates toward zero, so the average of
-15 over 4 numbers is -3, not -4. The sum is a signed 64-bit integer, so a very
long file of large numbers can wrap around without warning. And `set -e`
conflicts with `(( count++ ))` when count is 0, so the solution uses plain
assignments.

## In real work

Latency summaries, log analysis, "what was the peak and the trough", checking
a column of a CSV, and monitoring scripts that cannot store history.

## Going further

You have averages that are truncated. Sometimes truncating is wrong, and
you want to round to the nearest whole number. The last level takes
that on using integers only.
