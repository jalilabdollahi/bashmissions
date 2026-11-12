# Debrief: C-Style for

The C-style loop puts the whole life of a counter into one line: where it begins, how long it lives and how it changes. Compared with a list loop, you stop receiving items and start generating them.

## How it works
`for (( init; test; update ))` is shorthand for a pattern you could write with `while`: run init once, test, run the body, run update, test again. Everything inside `(( ))` is arithmetic, so `i-- `, `i += 2` and `i * 2` all work and variables do not need `$`.

Because the test comes first, a loop whose test is already false runs zero times. That is why a countdown from 0 prints nothing, and it is usually exactly the behaviour you want for "nothing to do".

Remember that the variable survives after the loop. Here `i` ends at 0, and it is visible to the rest of the script.

## In real work
Retry counters, paging through numbered result pages, building N test users, "do this every 5th minute": whenever the number of rounds or the step is computed, a counting loop is the tool.

## Going further
The same counter logic can also be written with `while`. The next level does exactly that and shows when the shape is more convenient.
