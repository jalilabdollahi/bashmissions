# Common Mistakes

- **Putting the step in the wrong position.** The order is FIRST, STEP, LAST.
  Wrong: `seq 0 45 15` (steps of 45 from 0 up to 15, so it prints only 0)
  Right: `seq 0 15 45`
- **Off by one in the last value.** For N servers the last offset is `(N-1)*STEP`, not `N*STEP`.
  Wrong: `seq 0 15 $(( count * step ))` schedules one server too many
- **Brace range with variables.** `{0..$last..15}` is not expanded.
  Right: `$(seq 0 15 "$last")`
- **Forgetting to pad.** `printf '%d:%d'` shows `2:5` instead of `02:05`. Use `%02d`.
- **Quoting the whole substitution.** `for x in "$(seq 1 3)"` runs once with all lines as one word.
