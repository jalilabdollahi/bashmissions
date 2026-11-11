# Debrief: Rounding Division

## What you learned

Integer division rounds down, and by adding a small offset to the numerator
you can change when it tips to the next whole number. The same idea gives you
all three useful roundings: floor (plain `/`), nearest (add half the divisor)
and ceiling (add divisor minus one).

## Under the hood

The identity behind it is `a = q * b + r`. Division returns `q` and ignores
`r`; adding `k` first just asks "is `r + k` at least `b`?". It is exact: no
floats, no representation error, nothing that depends on a library.

The rule for ties is a design decision, not a law. Here a remainder of exactly half
goes up ("round half up", what most people learn at school). Bankers round
half to even, which avoids a small upward bias across many numbers, and awk's
`printf "%.0f"` does that. For money you must choose a rule, state it, and
use it everywhere.

Negative amounts are a different story: Bash truncates toward zero, so the
formulas in this level are only correct for amounts that are zero or
positive. That is why the objective says so. If your data can go negative, handle
the sign first and apply the rule to the absolute value.

## In real work

Splitting costs, "how many pages / disks / containers do I need" (ceiling), turning
bytes into kilobytes for a display (nearest), and progress percentages.

## Going further

You have finished the arithmetic module: sums, powers, bases, decimals and
rounding. Next come arrays and maps, which let one variable hold a whole list of the
numbers you now know how to handle.
