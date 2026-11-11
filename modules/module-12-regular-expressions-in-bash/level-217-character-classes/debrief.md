# Debrief: Character Classes

A literal letter in a regex matches itself. A **bracket expression** matches *one
character chosen from a set*. That single idea is the heart of regex: instead of
listing the input you expect, you describe its *kind*. `[a-z]` is "a lowercase
letter", `[[:digit:]]` is "a digit", and `[aeiou]` is "one of these five".

Remember the word *one*. `[[:digit:]]` does not mean "a number"; it means a
single digit, which is why the tag needs it twice. Saying "any amount of them" is
the job of quantifiers, the next level.

The POSIX names are the portable vocabulary: `[:digit:]`, `[:alpha:]`,
`[:alnum:]`, `[:upper:]`, `[:lower:]`, `[:space:]`, `[:xdigit:]` and `[:punct:]`.
They only work *inside* a bracket expression, which is why you see the doubled
brackets. You can combine them: `[[:alpha:]_]` is a letter or an underscore.

Why not `\d`? Shorthand escapes like `\d` and `\w` belong to Perl-style regexes.
Bash and `grep -E` use POSIX syntax, where they are unreliable between macOS and
Linux. Brackets work the same everywhere.

Going further: you will soon need "one or more digits" without typing the class
repeatedly. Quantifiers do that.
