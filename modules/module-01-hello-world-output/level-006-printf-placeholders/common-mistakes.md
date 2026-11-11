# Common Mistakes

- **Putting the values inside the format.** The variable then gets treated as format text, and a stray `%` in the data can break the output.
  Wrong: `printf "Customer: $CUSTOMER\n"`
  Right: `printf 'Customer: %s\n' "$CUSTOMER"`
- **Leaving out the quotes around a name with spaces.** The words become separate values and the placeholders shift.
  Wrong: `printf '%s has %d\n' $CUSTOMER $TICKETS`
  Right: `printf '%s has %d\n' "$CUSTOMER" "$TICKETS"`
- **Wrong order of values.** The first value always fills the first placeholder.
- **Forgetting `\n`.** The next output starts on the same line.
