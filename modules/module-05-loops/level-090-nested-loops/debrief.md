# Debrief: Nested Loops

When one loop sits inside another, the inner loop runs to completion for every single round of the outer loop. A 3-by-4 grid therefore executes the inner body 12 times, while the outer body runs 3 times.

## How it works
Each loop has its own counter. The inner counter is reset by its own `for` header at the start of every outer round, which is why every row starts again at month 1. The outer counter does not change while the inner loop is running, so the inner body can use both. That is the whole trick of grids.

Where you put things matters. Whatever sits between the outer `do` and the inner `for` runs once per row (the label); whatever sits after the inner `done` also runs once per row (the newline); whatever sits in the inner body runs once per cell.

The total work is rows times cells, so nested loops are quick for small tables and slow for big ones. A loop of 1000 inside a loop of 1000 is a million rounds, which Bash handles slowly.

`break` and `continue` only affect the innermost loop. `break 2` leaves both.

## In real work
Every combination of environments and services, hosts times ports for a scan, regions times instance sizes in a price table, test matrices.

## Going further
Next, a different kind of loop-with-a-counter: numbering the lines of a list as you walk it.
