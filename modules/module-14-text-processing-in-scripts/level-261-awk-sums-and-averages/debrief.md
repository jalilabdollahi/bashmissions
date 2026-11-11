# Debrief: awk Sums and Averages

An awk program has a life cycle, and you have now seen all of it: an optional
`BEGIN` block before any input, the per-line `pattern { action }` rules, and an
`END` block after the last line. Variables live across all of them, which is
what makes awk a tool for summaries. Where `sort | uniq -c` counts lines, awk
adds, averages, tracks maximums, and prints one tidy report at the end.

Two details make this safe. First, uninitialised variables are zero, so
accumulators need no setup, but that same fact means a typo in a variable name
silently makes a new zero variable. Second, an empty input still runs the `END`
block, so the report must make sense with no data. Dividing by `NR` without a guard
would print `inf` or abort, depending on which awk you have.

awk also does real arithmetic, which Bash cannot: Bash's `$(( ))` is integer
only. When a script needs money, percentages or ratios, an awk one-liner is the
portable answer, and `printf "%.2f"` fixes the output format so the report looks
the same on every machine.

Going further: your data will not always be separated by spaces. The next level
sets the field separator and the output separator, so awk can read and write CSV.
