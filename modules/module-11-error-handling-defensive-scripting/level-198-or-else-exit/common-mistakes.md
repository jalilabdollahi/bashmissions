# Common Mistakes

- **Using `;` instead of `||`.** Wrong: `cd "$1"; exit 1` leaves every time, even on success. Right: `cd "$1" || exit 1`; exit runs only after failure.
- **Forgetting the group.** Wrong: `cd "$1" || echo "cannot enter" >&2; exit 1` - the `exit` is outside the `||` and always runs. Right: wrap both in `{ echo "cannot enter" >&2; exit 1; }`.
- **Missing space or semicolon in the braces.** Wrong: `{echo hi; exit 1}` is a syntax error or a strange command name. Right: `{ echo hi; exit 1; }`.
- **Message on stdout.** Wrong: `echo "deploy: cannot enter $1"` ends up in a pipe or a report. Right: `echo "..." >&2`.
- **Guarding the delete instead of the cd.** Wrong: testing after the fact whether rm did something. Right: stop at the first broken assumption, the cd.
