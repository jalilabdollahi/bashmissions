# Debrief: Integer Variables

## What you learned
Bash variables are text unless you say otherwise. `declare -i` attaches an integer attribute, after which assigning to the variable runs the value through Bash's arithmetic engine.

## Under the hood
The attribute is stored with the variable, like the read-only flag from earlier. On each assignment Bash checks for the flag, and if it is there it evaluates the right-hand side as an expression: `+`, `-`, `*`, `/`, `%`, and parentheses all work, and names inside the expression are read as variables. The result is stored as an ordinary decimal string. That is also why `+=` behaves differently: it adds instead of appending.

Everything is whole numbers; Bash has no decimals. A value that is not a valid expression becomes `0` or raises an arithmetic error, so check your inputs.

## In real work
Counters, sizes, retry numbers, port offsets: anything you add to or compare. In later modules you will use `(( ... ))` and `$(( ... ))` for the same arithmetic without declaring anything.

## Going further
All your settings so far arrived reliably. The next levels deal with the rest of reality: settings that are missing.
