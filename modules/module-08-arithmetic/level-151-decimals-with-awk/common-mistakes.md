# Common Mistakes

- **Doing decimals in `$(( ))`.** It stops at the point.
  - Wrong: `echo $(( 250.5 * 0.12 ))` gives "invalid arithmetic operator"
  - Right: `awk -v a=250.5 -v b=0.12 'BEGIN { print a * b }'`
- **Using double quotes around the awk program.** The shell expands `$` and `%` before awk sees them.
  - Wrong: `awk "BEGIN { printf \"%.2f\", $gb * $rate }"`
  - Right: single quotes around the program and `-v` for the values
- **Forgetting `\n` in awk's printf.** Unlike `print`, `printf` adds no newline.
  - Wrong: `printf "total=$%.2f", total` joins all output on one line
  - Right: `printf "total=$%.2f\n", total`
- **Using `%d` for money.** It truncates to a whole number.
  - Wrong: `printf "%d", 15.03` prints 15
  - Right: `printf "%.2f", 15.03`
