# Common Mistakes

- **Expecting a fraction.** `/` truncates.
  - Wrong: assuming `$(( 90 / 60 ))` gives 1.5
  - Right: it gives 1; use `$(( 90 % 60 ))` for the 30 that is left over
- **Taking the hours from the raw total.** Without removing the days first you get 75 hours instead of 3.
  - Wrong: `hours=$(( minutes / 60 ))`
  - Right: `hours=$(( minutes % 1440 / 60 ))`
- **Forgetting that `%` is not percent.** It is the remainder.
  - Wrong: `echo $(( 40 % 200 ))` to mean "40 percent of 200"
  - Right: `echo $(( 40 * 200 / 100 ))`
- **`$days` glued to a letter.** The shell reads the longest name it can.
  - Wrong: `"$daysd"` is the (empty) variable `daysd`
  - Right: `"${days}d"`
