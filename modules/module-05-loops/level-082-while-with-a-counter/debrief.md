# Debrief: while with a Counter

`while` is the general-purpose loop: "as long as this is true, keep going". The counter is not part of the syntax at all. It is just a variable that you set up, test, and change, which makes `while` the most flexible and the easiest loop to get wrong.

## How it works
Bash evaluates the condition before every round, including the first. If it succeeds (exit status 0), the body runs and the condition is evaluated again. `(( week <= weeks ))` succeeds when the comparison is true, so it fits perfectly. A body that never changes anything the condition depends on loops forever.

Because the test comes first, a condition that is false from the start gives zero rounds. For `N=0` the forecast is empty and nothing in your script has to treat that as a special case.

The state you built up (`size`, `week`) is ordinary variables, visible after the loop. After the final round `week` is `N + 1`; that is normal.

## In real work
Capacity planning, polling counters, "keep doing this until the number reaches the limit". Whenever the stopping rule is a condition rather than a list, `while` is the starting point.

## Going further
What if the condition is a command that should eventually succeed, like "is the database up yet"? Level 83 introduces `until`, the mirror image of `while`.
