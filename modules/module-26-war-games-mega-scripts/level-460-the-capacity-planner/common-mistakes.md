# Common Mistakes

- **Using the last line as the newest sample.** Wrong: `used = $4` on every line. If the export is unsorted you forecast from an old reading. Right: keep the values of the row with the largest day number.
- **Dividing by a zero or negative slope.** Wrong: `left = (total - used) / slope` for a flat disk gives `inf` or a negative date. Right: only compute `left` and `full` when `slope > 0`.
- **Rounding up the days left.** Wrong: `%d` of `(total - used) / slope + 0.5` promises one day too many. Right: `int(...)` rounds down, the safe direction.
- **Reaching for `date -d`.** Wrong: works on Linux, dies on macOS. Right: days-since-epoch arithmetic in awk, which also handles leap years.
- **Forgetting the thresholds' order.** Wrong: checking `left <= warn` last, which downgrades a CRIT to WARN. Right: assign WARN first and let the CRIT test overwrite it.
- **Sorting numbers as text.** Wrong: `sort -k1,1` puts `10` before `9`. Right: `-k1,1n`.
