# Debrief: Running Totals

An accumulator is a variable that remembers. The loop body is a function of "what I read now" and "what I knew before", and the variable is the memory that connects the rounds.

## How it works
Three decisions define every accumulator. Where does it start? (Zero for sums, one for products, an empty string for a list you are building.) How is it updated? (`sum=$(( sum + x ))`, or the shorthand `(( sum += x ))`.) When is it reported? (After the loop, or each round, as in this level.)

Because the variable lives outside the loop body, it survives from one round to the next, and it survives after the loop too. Printing it after `done` is how you produce a summary.

Bash integers are whole numbers only. If you need decimals (euros and cents), work in the smallest unit (cents) and format the result at the end, or hand the job to `awk`.

Accumulating is not limited to numbers: `names="$names $customer"` builds a list, `max` and `min` trackers use a test before they update. Only the update rule changes.

## In real work
Disk usage per team, invoice totals, request counts by hour, bytes transferred. Nearly every report adds something up.

## Going further
There is a classic trap waiting in this pattern: put the loop at the end of a pipe and the total disappears. Level 94 shows how.
