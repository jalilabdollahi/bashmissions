# Debrief: Arithmetic Tests

Double parentheses give Bash a small calculator. Inside `(( ))` everything is
an integer expression: you can compare with `>`, `<=` and `==`, add, subtract,
multiply, divide, and use variables by name. It is the natural home for any
decision that involves numbers.

## Under the hood

There are two spellings with different jobs. `(( expr ))` as a command
evaluates the expression and sets the exit status: 0 (true) if the result is
non-zero, 1 (false) if the result is zero. That is the opposite of how C
thinks about success but is consistent with Bash, where 0 means "ok".
`$(( expr ))` is an expansion: it is replaced by the numeric result, so it can
sit inside strings and assignments.

Inside both, variable names are looked up automatically, which is why `used`
needs no dollar sign. Variables that are empty count as 0, and text that is not
a number is treated as a variable name, which can surprise you.

## Where it shows up

Capacity maths, retry loops, percentage calculations, comparing counts, and every
"is it above the threshold?" check that needs a computation first.

## Going further

You now have tests for text and for numbers. Real runbook sentences combine
several conditions: "if X and Y". Next level.
