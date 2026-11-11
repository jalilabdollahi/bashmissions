# Debrief: Capitalize Words

The single-character forms `${var^}` and `${var,}` change only the first letter.
That is the missing piece for names and titles. Because Bash has no "title case"
operator, you compose one from small parts: split into words, normalise each
word with `,,`, capitalise it with `^`, and join the results.

The most important lesson hides in the loop header. `for word in $name` with the
variable **unquoted** performs *word splitting*: Bash cuts the value at every
run of whitespace (the characters listed in `IFS`) and ignores the empty parts.
That is why repeated spaces collapse for free. You normally quote variables to
avoid exactly this, and now you know when it is deliberate. Do it only when you
understand the consequences: unquoted values are also subject to filename
expansion, so a word like `*` would turn into a list of files. Here the names
contain none, and the next level shows a safer way to split.

Case conversion follows the locale: tests use ASCII. For names with accents,
run it in the right locale and check the result.

Going further: the "add a space unless it is the first word" trick works for any
joined list. You will meet it again when joining array items.
