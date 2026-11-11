# Debrief: Remove Duplicates

De-duplication that keeps the order is "accept only what you have not accepted yet". It is the first time you combine two ideas from this module: building an array and searching one.

## How it works
Think of a doorman with a guest list. Each arrival is checked against the names already let in; a new face goes in and onto the list, a repeat is turned away. Because the input is processed front to back, the first appearance of every name wins, so the order of first appearance is the order of the output.

The cost is worth knowing. Every new name is compared against everything accepted so far, so the work grows with the square of the list. For a few hundred names that is nothing; for a hundred thousand it is painfully slow. That is exactly the problem associative arrays solve, two levels from here: a lookup in a map does not depend on how many keys it holds.

The flag variable (`seen`) is a pattern worth recognising: reset it before the inner loop, set it inside, test it after. Resetting at the wrong place is the most common bug.

## In real work
Digests and reports, "unique hosts affected", cleaning PATH-like lists, merging two lists without repeating shared entries.

## Going further
Next you swap the search loop for something much more powerful: a variable that is indexed by names, not numbers.
