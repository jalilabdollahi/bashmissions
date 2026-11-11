# Debrief: Compound Assignment

## What you learned

Updating a variable from its own value is so common that arithmetic has a
whole family of shortcuts: `+=`, `-=`, `*=`, `/=`, `%=` and `**=`. They make
accumulators, running totals and growth models short and readable.

## Under the hood

`x += n` is evaluated as `x = x + n`: the current value is read, the operation
is applied, and the result is written back to the same name. Because they are
assignments, they work inside `(( ))` as a statement, or inside `$(( ))` where
they also produce a value. As with `++`, the exit status of a bare `(( ))`
reflects whether the final value was non-zero, which matters under
`set -e`.

Look at the output you produced: the steady scenario grows by a constant
amount, the doubling one by a constant *factor*. Linear versus exponential
growth is the most important thing a capacity planner knows, and `*=` shows
it in ten lines. Watch the doubling column in the 10-month test.

## In real work

Running totals (`bytes += size`), back-off timers (`delay *= 2`), budgets
(`remaining -= cost`), and any loop that carries a number from one iteration
to the next.

## Going further

You have now seen `(( ))` as a statement in three levels. Next level puts it
side by side with an older relative, `let`, so you can read both in the wild.
