# Common Mistakes

- **Forgetting the newline.** `printf "%-12s %5s", $1, $3` glues all rows into one line. End the format with `\n`.
- **Mixing up the alignment.** `%12s` pads on the left (right-aligned); `%-12s` pads on the right (left-aligned). Text columns normally want the minus, numbers do not.
- **Using print with a format.** `print "%-12s", $1` prints the percent sign literally. Only `printf` interprets formats.
- **Too narrow a column.** `%-8s` for `octopus-east` (12 characters) does not truncate; it shifts every following column out of line. Size the widths for the longest value.
- **Shell expansion of the format.** In double quotes, `"%5s\n"` is fine, but `"$fmt"` or `%` followed by shell variables can be expanded early. Keep the awk program in single quotes.
