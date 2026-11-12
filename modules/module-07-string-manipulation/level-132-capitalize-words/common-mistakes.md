# Common Mistakes

- **Only capitalising, not lowering.** `${word^}` on `DENTAL` gives `DENTAL`. Put
  `word=${word,,}` first, then capitalise.
- **Quoting the loop list.** `for word in "$name"` is one word: the whole name.
  Without splitting, only the first letter of the whole string is changed.
- **A leading space in the result.** `result+=" ${word^}"` leaves a space at the
  start. Use `${result:+ }` or trim afterwards.
- **Using `^^` on the whole name.** `${name^^}` shouts everything; it does not
  produce Title Case at all.
