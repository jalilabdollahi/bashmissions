# Common Mistakes

- **Using `cat file | while read`.** The "useless cat" is not only wasteful, it creates the trap.
  Wrong: `cat "$file" | while read -r h s; do n=$((n+1)); done; echo "$n"` prints nothing useful
  Right: `while read -r h s; do n=$((n+1)); done < "$file"; echo "$n"`
- **Believing the loop is broken.** The loop did run. Only its variables were lost. Add an `echo` inside the loop to confirm.
- **Fixing it by printing inside the loop.** The report is then printed once per line instead of once.
- **Putting the redirect before `while`.** `< "$file" while read ...` is not valid; the redirect goes after `done`.
- **Reading the file in two places.** Counting in a pipeline and then looping again over the same file works but doubles the work; one loop with a redirect is enough.
