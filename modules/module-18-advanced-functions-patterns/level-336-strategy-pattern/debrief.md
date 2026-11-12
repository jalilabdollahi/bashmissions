# Debrief: Strategy Pattern

A strategy is an interchangeable algorithm behind a fixed interface. The code
that *uses* the algorithm (the loop) and the code that *is* the algorithm
(the rounding functions) meet at one agreement: "cents in, euros out". As long as
a new function honours it, it can be plugged in without touching the loop.

## How it differs from a dispatch table

The dispatch table (the first level of this module) chooses *per request*:
every command line may pick a different function. A strategy is chosen once and
then fixed for a whole run: it is a setting. That is why it lives in a plain
variable, not in a table consulted for each item.

## Under the hood

`strategy=round_up` stores text. `"$strategy" "$cents"` makes Bash expand that
text and treat it as a command name, so function lookup happens at call time,
and swapping the variable swaps the behaviour. The quotes keep the call safe.
The three rounding tricks are plain integer arithmetic: Bash has no floating
point, and working in cents and integer division is also how real billing code
avoids rounding errors in the first place.

## Design notes

Choosing early has a bonus: an unknown strategy is rejected before any input is
read, so the program never fails in the middle of a run. Per-line problems (not
an amount) are reported and skipped, and reflected in the exit status.

## In real work

Sorting order, compression level, retention policy, date format, backup tool:
anywhere "how" differs but "what" stays the same.

## Going further

Sometimes you do not want to *choose* one algorithm but apply several in a
row. Next, a middleware chain.
