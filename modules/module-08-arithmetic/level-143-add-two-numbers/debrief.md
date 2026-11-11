# Debrief: Add Two Numbers

## What you learned

Bash variables hold text. Arithmetic is something you ask for explicitly, and
`$(( ... ))` is how you ask. Everything inside is evaluated as an integer
expression, and the result is substituted back into the command line as text.

## Under the hood

Inside `$(( ))` the shell parses your expression like a tiny calculator. A bare
word such as `anchovy_gb` is looked up as a variable (that is why no `$` is
needed), and if it contains digits it becomes a number. The numbers are signed
64-bit integers: the range is about plus or minus 9.2 quintillion. Go past
that and the value silently wraps around to negative, with no error message.
There are no decimals at all; that comes up again later in this module.

## In real work

Summing byte counts, adding retry counters, computing "port + offset" for the
Nth instance of a service. Whenever a script needs a number from other numbers,
this is the tool.

## Going further

Adding is the easy one. The next level mixes several operators in one line, and
you will see why the order Bash evaluates them in matters to Gus's invoices.
