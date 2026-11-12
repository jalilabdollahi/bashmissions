# Common Mistakes

- **Hard-coding column numbers.** `awk '{ print $3, $2 }'` works until the export adds a column. Look names up: `$(pos["email"])`.
- **Leaving `\r` on the header.** On a Windows file the last header name is `plan\r`, so asking for `plan` reports "unknown column". Strip it before building `pos`.
- **Testing membership with `if (pos[name] == "")`.** Reading a missing element creates it. Use `if (!(name in pos))`.
- **Printing a trailing comma.** `out = out $(pos[w]) ","` leaves `a,b,`. Put the separator before every value except the first.
- **Failing after printing.** Validating names inside the per-row rule prints a few good lines before the error. Validate on line 1, before anything is output.
