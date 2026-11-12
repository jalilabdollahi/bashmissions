# Debrief: Translate Characters

`tr` works at a lower level than the tools you have used so far. `cut`, `sort`
and `uniq` see lines; `tr` sees characters, one after another, with no idea
where lines or words begin. It is a pure mapping from characters to characters,
which is why it needs no pattern language, only two aligned lists.

That simplicity has consequences worth remembering. `tr` cannot take a file
name: it reads standard input only, so you write `tr ... < file` or put it
in a pipe. It maps single characters, so "replace the word cat with dog" is
not its job (that is sed's). And when the second set is shorter than the
first, the last character is repeated, which is the trick people use to map
many characters to one.

In real work `tr` is the quick fix for normalising data: shouting names for
environment variables as here, lowering case before comparing, turning
newlines into commas, or swapping delimiters before `cut`. Because it never
backtracks or parses, it runs at close to disk speed.

Going further: `tr` can also delete characters and squeeze repeats. The next
level uses both to clean up a messy export.
