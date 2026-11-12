# Common Mistakes

- **Checking columns before the field count.** On a row with 6 fields, `$3` is part of the subject, so "bad priority" would be reported for the wrong reason. Use `if (NF != 4) ... else if ...`, not independent `if`s.
- **Printing a second verdict after exit.** `exit 1` in a rule still runs `END`. Without a flag, the header error is followed by `valid: 0 rows`.
- **Using a counter instead of NR for line numbers.** `n++` in a rule that skips blank lines drifts; `NR` is always the real line number of the file.
- **Forgetting `\r`.** On Windows files the header is `...,subject\r`, which never equals the expected header, and the last field of every row is polluted. `sub(/\r$/, "")` first.
- **Reporting only the verdict.** `invalid` with no line numbers sends someone to hunt through 40,000 rows. Print the line and the reason.
