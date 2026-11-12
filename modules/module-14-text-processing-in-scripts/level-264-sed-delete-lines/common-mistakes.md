# Common Mistakes

- **Anchoring too early.** `sed '/^;/d'` misses `  ; indented comment`. Allow blanks: `'/^[[:space:]]*;/d'`.
- **Deleting inline comments by accident.** `sed '/;/d'` removes every record that has a `;` anywhere, including `www IN A 192.0.2.10 ; note`. Anchor the pattern to the start of the line.
- **Only matching empty lines.** `/^$/d` leaves lines holding a single space or tab. Use `^[[:space:]]*$`.
- **Expecting the file to change.** `sed '/^;/d' zone` prints a cleaned copy; the original stays as it is. In-place editing is a later level.
- **Forgetting the quotes.** An unquoted `/^$/d` or `/;/d` is mangled by the shell (`$` and `;` mean things to it). Always single-quote sed programs.
