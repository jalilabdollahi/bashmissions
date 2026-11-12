# Debrief: awk Separators

Real data comes in dialects. Commas, semicolons, tabs, colons, pipes: every
system chose its own. awk lets you describe a dialect with two settings.
`FS` (set on the command line with `-F`) tells it how to split what it reads;
`OFS` tells it what to put between the items of `print a, b`. They are
independent, so converting from one format to another is a matter of setting
the two and printing.

A quiet detail: FS is a regular expression when it has more than one
character. `-F', *'` splits at a comma followed by any number of spaces, and
`-F'[;,]'` splits at either a semicolon or a comma. With a single space (the
default) awk does something special, treating any run of blanks as one
separator; with any other single character it splits strictly at each one,
leaving empty fields in between.

Another: awk rebuilds `$0` with OFS only when you change a field. That is why
`$1 = $1` is a well-known idiom for "rewrite this line with the new separator".

Going further: next you will use awk's arrays to total a column per customer
instead of one grand total.
