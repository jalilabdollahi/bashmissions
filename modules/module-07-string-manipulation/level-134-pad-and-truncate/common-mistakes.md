# Common Mistakes

- **Width without precision.** `%-14s` pads but never cuts, so a long name pushes
  the columns out. Add the precision: `%-14.14s`.
- **Forgetting the minus.** `%14.14s` is right-aligned: the name appears flush
  right, with padding on the left.
- **Putting data in the format.** `printf "$name"` breaks on a `%` and eats
  backslashes. Keep the format fixed and pass values as arguments.
- **Forgetting the newline.** `printf` prints exactly what the format says, so
  without `\n` all the rows run together on one line.
