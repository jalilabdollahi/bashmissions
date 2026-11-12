# Common Mistakes

- **Letting a bar into a cell.** `| Rope | 10m |` becomes five cells and shifts every column to its right. Write `\|` for a literal bar.
- **No blank line around the table.** Many renderers need an empty line before and after a table, or the rows are glued to the paragraph above. Print `print ""` on both sides.
- **Comparing numbers as text.** `"9" <= "10"` is false as text. Add zero: `$3 + 0 <= $4 + 0`, and reject non-numbers first so `many` does not become 0.
- **Printing an empty table.** With no low items, a header and a separator over nothing look like a broken report. Print the note instead.
- **Forgetting the separator row.** Without `|---|---|---:|---:|` there is no table, only lines starting with bars.
