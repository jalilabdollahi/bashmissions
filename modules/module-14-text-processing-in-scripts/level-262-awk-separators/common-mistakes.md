# Common Mistakes

- **Forgetting that print needs commas for OFS.** `print $2 $1` glues the values together with no separator at all; `print $2, $1` uses OFS.
- **An unquoted semicolon.** `awk -F; '...'` runs `awk -F` and then a second command. Write `-F';'`.
- **Setting only one separator.** `awk -F';' '{ print $2, $1 }'` reads semicolons but still writes spaces. Set `-v OFS=','` too.
- **Using -F' ' for a single space.** `-F' '` is awk's default: runs of blanks count as one separator. For exactly one space use `-F'[ ]'`.
- **Splitting on a character that appears in the data.** A name like `Gull; Anchor` would break every column after it. Check that the delimiter cannot occur inside a field.
