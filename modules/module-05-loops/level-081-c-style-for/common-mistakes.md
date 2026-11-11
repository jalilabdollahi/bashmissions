# Common Mistakes

- **Using commas instead of semicolons.** The three parts are separated by `;`.
  Wrong: `for (( i=3, i>=1, i-- ))`
  Right: `for (( i=3; i>=1; i-- ))`
- **Counting the wrong way.** If the update moves away from the limit the loop never ends.
  Wrong: `for (( i=3; i>=1; i++ ))` (runs until you press Ctrl-C)
  Right: `for (( i=3; i>=1; i-- ))`
- **Off by one at the edge.** `>` versus `>=` decides whether 1 is printed.
  Wrong: `i>1` prints T-3 and T-2 for N=3
  Right: `i>=1` prints T-3, T-2 and T-1
- **Only one pair of parentheses.** `for ( i=0; ...)` is a syntax error. The arithmetic form needs `((` and `))`.
