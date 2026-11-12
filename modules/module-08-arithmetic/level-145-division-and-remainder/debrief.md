# Debrief: Division and Remainder

## What you learned

Bash division is integer division: it hands you the whole number of times and
drops the rest, silently. `%` hands you the rest. Together they split any
quantity into "units and leftovers", which is how clocks, pages of results and
disk blocks all work.

## Under the hood

`7 / 2` is 3, never 3.5, and negative numbers truncate toward zero, so
`-7 / 2` is -3 and `-7 % 2` is -1. The identity `a == (a / b) * b + a % b`
always holds, which is a good way to check your own formulas.

Dividing by zero is not silently ignored: Bash prints "division by 0" and the
command fails. If a divisor comes from outside the script, you check it
first.

## In real work

Converting seconds to HH:MM:SS, splitting a list into pages of 50 rows,
choosing a server for a request by `id % server_count`, and finding every
Nth item in a loop.

## Going further

Division goes down; the next level goes up. Powers will tell you how fast
things grow when something doubles every time, and how big a network really is.
