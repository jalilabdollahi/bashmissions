# Debrief: Decimals with awk

## What you learned

Bash arithmetic is integer-only by design. When you need a fractional result,
use a tool that has floating point numbers, and awk is the one that is
always installed. A `BEGIN { ... }` block turns it into a calculator, `-v`
passes values in, and `printf "%.2f"` controls how the result looks.

## Under the hood

awk stores numbers as double-precision floats, so a value like 0.1 is not
represented exactly; sums of money can be off by a tiny fraction. That is
fine for display with `%.2f`, but for accounting you either keep integer cents
(next level) or round at the end only. Rounding by `%.2f` is binary-float
rounding: a value like 2.675 may print as 2.67, not 2.68.

Why not `bc`? It is the traditional calculator, but it is missing on many
minimal Linux images and containers. awk ships with every system, so a script that
uses it travels well. The `-v` assignments are processed by awk itself, so the
shell never gets to interpret your numbers as code.

## In real work

Percentages with decimals, averages, converting units (bytes to GiB),
and reports for people who read dollars rather than cents.

## Going further

Floats are convenient, but they are slow to start and awkward in loops. The
next level shows how to keep exact integers and still print a decimal
point, using nothing but Bash.
