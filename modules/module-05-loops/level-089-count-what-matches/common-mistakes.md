# Common Mistakes

- **Not starting the counters at zero.** The report prints empty or garbage.
  Wrong: `echo "$errors"` when the loop never ran (prints nothing)
  Right: `errors=0` before the loop
- **Incrementing outside the `if`.** Then every line counts as an error.
  Wrong: `errors=$(( errors + 1 ))` placed after the closing `fi`
  Right: inside the `then` branch
- **Printing the result inside the loop.** You get one line per request instead of one report.
  Right: put the `echo "server errors: ..."` after `done`
- **Splitting on the wrong field.** With `read -r client status path` the status is the second word. If you name the variables in a different order you will count paths.
- **Counting with a literal in a pipe.** `cat log | while read ...` hides the counters (see level 94).
