# Debrief: Operator Precedence

## What you learned

An arithmetic expression is not read strictly left to right. Each operator has a
strength, and stronger ones are applied first. Parentheses are your override:
whatever is inside them is finished before the outside operators get a turn.

## Under the hood

Bash's parser builds the expression in layers. `a + b * c` becomes "a plus
(b times c)" because `*` sits above `+` in the table. When two operators have
equal strength (such as `-` and `+`), they are applied left to right, so
`10 - 3 - 2` is 5, not 9. The same applies to `/`: `100 / 10 / 5` is 2.

The classic accident is the invoice that is "almost right". `base + gb * rate *
servers` still returns a number, just not Gus's number. Bash never warns you;
wrong precedence is a silent bug.

## In real work

Billing formulas, retry back-off (`base * attempt + jitter`), time maths, and
anything copied from a spreadsheet. When in doubt, add parentheses. They cost
nothing and tell the next reader exactly what you meant.

## Going further

You have used `*`, `+` and `-`. Division is next, and in integer arithmetic it
comes with a companion that tells you what was left over.
