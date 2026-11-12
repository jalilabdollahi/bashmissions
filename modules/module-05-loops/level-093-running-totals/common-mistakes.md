# Common Mistakes

- **Forgetting to start the sum.** An unset variable breaks formatting and hides intent.
  Wrong: no `sum=0`, so empty input prints `total=`
  Right: `sum=0` before the loop
- **Resetting inside the loop.** The meter restarts every round.
  Wrong: `sum=0` as the first line of the loop body (every line shows `+120 = 120`)
  Right: initialise once, above the loop
- **Concatenating instead of adding.** Without arithmetic, values are glued as text.
  Wrong: `sum="$sum$gb"` produces `120045300`
  Right: `sum=$(( sum + gb ))`
- **Printing the sum before adding.** The meter lags one line behind.
  Right: update first, then print
- **Expecting decimals.** `$(( 1.5 + 2 ))` is a syntax error. Use whole units.
