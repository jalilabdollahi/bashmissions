# Debrief: Counting Arguments

`$#` is the shell's own tally of positional parameters. It is not computed when
you ask, the shell set it when it split the command line, and it changes only
when you change the arguments (for example with `shift`, which comes soon).

A useful mental picture: `$1`, `$2`... are the contents of the boxes, and `$#` is
the number of boxes. Zero boxes is a perfectly normal state, and `$#` says so
plainly instead of failing.

In real scripts the count is the foundation for validation: "this tool needs
exactly two arguments", "at least one hostname", "refuse batches over twenty".
Checking `$#` before touching `$1` is also how you avoid the `unbound variable`
crash that `set -u` produces when an expected argument is missing.

Going further: your script can now see how many arguments there are. The next
levels teach how to pass all of them on without damaging them (`"$@"`), how to
join them, and how to consume them one at a time with `shift`.
