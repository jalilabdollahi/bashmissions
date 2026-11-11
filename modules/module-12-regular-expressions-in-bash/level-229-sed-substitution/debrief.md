# Debrief: sed Substitution

`sed` is the **stream editor**: text goes in, commands transform it line by line,
text comes out. It never touches the file unless you ask (`-i`), which makes it
perfect for pipelines: `sed ... file | next-command`.

The `s` command is the part of sed you will use 95% of the time. Its anatomy is
`s` + delimiter + *regex* + delimiter + *replacement* + delimiter + *flags*. Three
facts carry most of the weight:

1. The **pattern is a regex**, so everything you learned applies, including the
   rule that a bare `.` means "any character". When you mean the dot, escape it.
2. By default only the **first** match per line is replaced. The `g` flag means
   "all of them". Forgetting it is the most common sed bug, because the output
   looks right on the first line you check.
3. The **delimiter is free**. When the text contains slashes (paths, URLs), use
   `|` or `#` so you do not drown in backslashes.

The replacement is not a regex: it is text, plus a few special sequences you will
meet next (`&` and `\1`).

Anonymising data, rewriting config values, fixing paths after a move: all of it
is `s///g`. The portable habit is to avoid in-place editing in scripts that must
run on both macOS and Linux, because `sed -i` differs between them. Writing to
stdout (or `-i.bak`, with a suffix) is safe everywhere.

Going further: the pieces matched by groups can be reused in the replacement.
That is the next level.
