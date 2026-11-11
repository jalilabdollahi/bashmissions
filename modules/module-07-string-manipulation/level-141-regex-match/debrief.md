# Debrief: Regex Match

Patterns with `*` and `[...]` can say "anything" or "one of these", but not "one or
more digits" or "this part is optional". Regular expressions can. `[[ s =~ re ]]`
uses **POSIX extended** regular expressions, the same dialect as `grep -E` and
`sed -E`, so what you learn here works in those tools too.

Four ideas covered nearly all of this level: character sets (`[0-9]`), quantifiers
(`+` one or more, `?` optional), escapes (`\.` for a literal dot), and anchors
(`^`, `$`). Anchors are the one beginners forget. A regex answers "does this
pattern occur *somewhere* in the string?", not "is the whole string like this?".
Add both anchors to validate a complete value.

The quoting rule in Bash is the opposite of the glob test from earlier: in `==`
tests the *quoted* parts are literal; in `=~` a **quoted regex is also taken
literally**, so quote nothing and keep the expression in a variable. Cases with
spaces in a regex are the reason people prefer the variable form.

`=~` has a bonus: on success it records what matched in `BASH_REMATCH`, which is
the topic of the next level. Real uses: validating versions, ports, IPs, e-mail
shapes (roughly), identifiers, dates.

Going further: validate first, then extract. Capture groups give you the pieces.
