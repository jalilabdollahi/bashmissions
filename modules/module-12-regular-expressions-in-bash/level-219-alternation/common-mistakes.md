# Common Mistakes

- **An alternation without a group.**
  Wrong: `ACTION=DROP|REJECT|DENY` (the second and third alternatives lack
  `ACTION=`, so a stray "REJECT" anywhere counts).
  Right: `ACTION=(DROP|REJECT|DENY)`.
- **Not closing the word.** `ACTION=(DROP|REJECT)` matches `ACTION=REJECTED`.
  Add what must follow: `( |$)`.
- **Spaces around the bar.** `(DROP | REJECT)` means "DROP followed by a space" or
  "a space followed by REJECT". Spaces in a regex are real characters.
- **Alternatives that start the same way.** In `(AL|ALLOW)` the engine can still
  find a match with either; if the order or the boundary is wrong you may
  capture less than you expect. Put the longer word first or close the word.
- **Using `\|` in ERE.** In extended regex `|` is already the operator; `\|` would
  be a literal bar (this differs from basic `grep` without `-E`).
