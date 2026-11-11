# Common Mistakes

- **Using `$` inside the parentheses to change a variable.**
  - Wrong: `(( $total++ ))` expands to `(( 5++ ))` and fails
  - Right: `(( total++ ))`
- **Trying to increment with a plain assignment.**
  - Wrong: `total++` on its own line: Bash looks for a command named `total++`
  - Right: `(( total++ ))`
- **`set -e` stopping at the first count.** `(( total++ ))` exits with 1 when total was 0.
  - Wrong: `set -e` plus `(( total++ ))` on a fresh counter
  - Right: `(( ++total ))`, or `total=$(( total + 1 ))`, or `(( total++ )) || true`
- **Reading the counter inside the same expression as the post-increment.** `echo $(( n++ ))` prints the old value.
  - Wrong: expecting `n=4; echo $(( n++ ))` to print 5
  - Right: it prints 4; the variable is 5 afterwards. Use `$(( ++n ))` for 5.
