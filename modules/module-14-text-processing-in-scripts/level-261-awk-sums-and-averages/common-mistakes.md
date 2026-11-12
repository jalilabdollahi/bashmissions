# Common Mistakes

- **Printing inside the main block.** `awk '{ total += $3; print total }'` prints a running total on every line. The summary belongs in `END { print total }`.
- **Dividing without a guard.** `avg = total / NR` on an empty file is a division by zero. Use `(NR > 0) ? total / NR : 0`.
- **Using print for money.** `print total` can show `200` or `1.5e+06`. Use `printf "%.2f\n", total` for stable output.
- **Forgetting the newline in printf.** `printf "total=%.2f", total` leaves the shell prompt on the same line. End with `\n`.
- **Misspelling the accumulator.** `{ total += $3 } END { print totl }` prints an empty line: `totl` is a brand-new variable. awk will not warn you.
