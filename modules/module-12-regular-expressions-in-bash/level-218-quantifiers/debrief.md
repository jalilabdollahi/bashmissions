# Debrief: Quantifiers

A character class describes *what* may appear in one position. A quantifier
describes *how many times*. Together they cover most formats you will ever
validate: three to five digits, one or more letters, an optional suffix.

Five symbols do all the work. `?` is zero or one, `*` is zero or more, `+` is one
or more, `{n}` is exactly n, and `{n,m}` is between n and m (`{n,}` has no upper
limit). Always read them as belonging to the thing on their left: a class, a
single character, or a parenthesised group.

Two traps come with the territory. First, `*` is happy with *zero*, so `[0-9]*`
matches the empty string and therefore matches almost everything; reach for `+`
when you mean "at least one". Second, quantifiers are *greedy*: they grab as many
characters as they can, then give some back only if the rest of the pattern
needs it. Anchored formats hide this, but when you extract pieces from the
middle of a line you will meet it again.

Do not confuse these with shell globs. In a glob `*` means "any text". In a regex
`*` means "repeat the previous item", so "any text" is `.*`, a dot (any
character) followed by a star.

Going further: so far the format has been fixed. Next, alternation lets a single
position accept one of several different words.
