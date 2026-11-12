# Debrief: Type-Check Values

The mental model: **text is not a type until you check it.** Everything a config
file or an environment variable gives you is a string. `lots`, `08`, `Yes` and
`$((2+2))` are all strings; the program wants an integer, a boolean and an enum.
The boundary where text becomes typed values is the one place to be strict, because
after it the rest of the script can stop worrying.

Three habits here carry over everywhere. Check the shape before the meaning: the
regex `^[0-9]+$` runs before any arithmetic, because Bash arithmetic evaluates
whatever it is given, including variable names and command substitutions, so
unchecked text in `(( ))` is an injection hole. Name the base: `10#` makes `08`
and `09` work instead of failing as octal. Normalise on the way in: accept many
spellings (`YES`, `on`, `1`), store one (`true`), so the rest of the program
compares against a single word.

`case` with `|` is the idiomatic enum check: a short, readable whitelist, and
the `*)` branch is the error path. A whitelist (accept these) beats a blacklist
(reject those) because new surprises land in the error branch by default.

Going further: some of the values you now trust are secrets. They must be used,
but never shown. The next level prints a config for humans with passwords and tokens
masked.
