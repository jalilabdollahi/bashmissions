# Common Mistakes

- **Searching for the bare key.** `index($0, "host")` also hits `"hostname"` and any message containing the word. Search for the whole token `"host":` including both quotes and the colon.
- **Cutting a string at the first quote.** `"msg":"he said \"stop\""` ends at the escaped quote if you use `index(rest, "\"")`. Walk the characters and treat a backslash as "take the next one literally".
- **Printing `null` as text.** The cell should be empty, not the four letters. Check for `null` after reading a bare token.
- **Unquoted CSV cells.** `disk 91%, rotating` printed raw adds a fifth column. Quote cells containing a comma or a quote, and double inner quotes.
- **Forgetting the header for empty input.** Printing the header from a rule that runs per line means an empty file gives no output. Use `BEGIN`.
