# Debrief: Align a Table

All the filters before this one passed text through almost untouched. `printf`
is about presentation: the same data can be an unreadable string of commas or a
neat table, and the difference is a format string. The format reads like a
template: literal text, with `%` conversions where the values go, each with
optional flags and a width. `%-12s` means "a string, 12 wide, left-aligned";
`%5s` is "right-aligned in 5"; `%.2f` is a number with two decimals; `%d` is an
integer; `%%` is a literal percent sign.

Two practical lessons. First, one format string used for both the header and
the rows is the way to keep a table honest: change the width in one place and
everything moves together. Second, widths are minimums, not limits. A value
longer than its column is not cut; it pushes the rest of the row to the right,
so pick widths from your longest expected value.

Bash's own `printf` builtin takes exactly the same formats, so everything you
learned works in a plain `while read` loop as well. awk is just more convenient
when the data arrives as delimited text.

Going further: awk read the comma-separated fields for you here. The next level
reads `key=value` configuration lines in pure Bash, using `IFS` to split them.
