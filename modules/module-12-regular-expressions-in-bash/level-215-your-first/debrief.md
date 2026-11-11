# Debrief: Your First =~

Until now you compared strings for equality or with glob wildcards such as
`*.log`. The operator `=~` brings in a second language: **regular
expressions**. A regex is a description of a *shape* of text, and `[[ $s =~ re ]]`
asks whether anywhere inside `$s` there is a piece of text with that shape.

The most important detail is the word "anywhere". A regex that is just a word
behaves like "contains". It is not a test of the whole string. Later levels add
anchors to demand the whole string, but the default is a search.

Under the hood, Bash hands the right-hand side to the C library's regex engine,
the same POSIX extended regular expressions that `grep -E` and `sed -E` use.
That is why the syntax you learn here carries straight over to those tools.
The status of `[[ =~ ]]` is 0 for a match, 1 for no match and 2 for a broken
regex, which is why you use it directly inside `if`.

In real work this is the first filter of every log investigation: find the lines
that mention the thing, then refine. You will do exactly that in the coming
levels.

Going further: right now the pattern is a plain word, so it matches the same
text everywhere. The next level adds `^` and `$` to say where the text must be.
