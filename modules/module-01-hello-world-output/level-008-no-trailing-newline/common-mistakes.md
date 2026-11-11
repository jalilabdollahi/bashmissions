# Common Mistakes

- **Leaving the newline on the label.** The verdict lands on the next line.
  Wrong: `echo "Checking backups... "`
  Right: `echo -n "Checking backups... "`
- **Dropping the trailing space.** The output becomes `Checking backups...ok`.
  Wrong: `echo -n "Checking backups..."`
  Right: `echo -n "Checking backups... "`
- **Putting -n after the text.** Then it is printed as text, not read as an option.
  Wrong: `echo "Checking backups... " -n`
  Right: `echo -n "Checking backups... "`
- **Using printf with a newline.** `printf "label\n"` ends the line just like echo does.
