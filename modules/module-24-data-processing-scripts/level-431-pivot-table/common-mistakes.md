# Common Mistakes

- **Printing only the combinations that occurred.** Looping over the cells that exist leaves holes: `Kelp Cove` would show a single value with no zeros for the other plans. Loop over rows and columns, and use `cell[r, c] + 0`.
- **Trusting `for (k in array)` for order.** The order differs between awk versions, so the table's rows and columns shuffle. Collect the names and sort them yourself.
- **Comparing names that look like numbers.** `a[j] > t` with `10` and `9` compares numerically in awk. Write `a[j] "" > t ""` to force text order.
- **Computing totals from the printed cells.** If a skipped row is counted in the margin but not in the cell (or vice versa), the table lies. Update cell, row, column and grand totals together, after the row has been accepted.
- **Forgetting the empty input.** With no data, `nr` and `nc` are empty, and `for (i = 1; i <= nr; ...)` must simply not run. Print `grand + 0` so the grand total is `0`, not blank.
