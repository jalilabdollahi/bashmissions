# Common Mistakes

- **Hard-coding the width.** Wrong: `printf '%-10s ...'` truncates nothing but breaks alignment as soon as a name is longer than 10. Right: measure the longest name in a first pass and use `%-*s`.
- **Left-aligning numbers.** Wrong: `%-5s` on LOAD makes `0.42` and `10.00` start at the same column so the decimal points wander. Right: `%5s` (right-aligned) for numbers.
- **Printing while measuring.** Wrong: printing each row as it is read, because the third row may be wider than the first. Right: store the rows, measure, then print.
- **Trailing whitespace from an empty marker.** Wrong: `printf '%s  %s\n' "$row" "$marker"` leaves two spaces on every healthy row. Right: append the marker to the row only when there is one.
- **`${#array}` instead of `${#array[@]}`.** Wrong: `${#f}` is the length of the first *element's text*. Right: `${#f[@]}` is the number of elements.
