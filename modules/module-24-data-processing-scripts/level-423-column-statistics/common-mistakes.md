# Common Mistakes

- **Starting min and max at 0.** With `min = 0`, a column of positive numbers reports `min=0.00`, and with `max = 0` an all-negative column reports `max=0.00`. Seed from the first value: `if (n == 1 || v < min) min = v`.
- **Letting text count as zero.** `pending + 0` is `0`, so it joins the average. Test the cell with a regex and count the rest as skipped.
- **Dividing by zero.** `sum / n` with an empty column kills awk with an error. Guard with `if (n > 0)`.
- **Using `NR` as the row count.** `NR` includes the header and the blank lines. Count only the numeric cells in `n`.
- **Comparing without making numbers.** `min` and `v` taken straight from a cell can compare as text (`"9" > "10"`). `v += 0` first.
