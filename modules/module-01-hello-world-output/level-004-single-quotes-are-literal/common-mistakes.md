# Common Mistakes

- **Using double quotes and expecting literal dollars.** The value is inserted, or nothing at all if it is unset.
  Wrong: `echo "Fee: $5"`  (prints `Fee: `)
  Right: `echo 'Fee: $5'`
- **Putting an apostrophe inside single quotes.** It ends the quote early.
  Wrong: `echo 'Priya's rule: $HOME is private'`
  Right: `echo "Priya's rule: \$HOME is private"`
- **Mixing the quotes by accident.** `echo 'text"` never closes and Bash waits for more input.
- **Quoting only part of the line.** `echo Never paste '$HOME' or $USER` protects one variable but not the other.
