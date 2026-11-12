# Common Mistakes

- **Forgetting the arithmetic wrapper.** Without it you just glue text together.
  - Wrong: `total="$a + $b"` stores the text `120 + 80`
  - Right: `total=$(( a + b ))`
- **Using only one pair of parentheses.** `$( ... )` is command substitution and tries to run `a` as a program.
  - Wrong: `total=$( a + b )`
  - Right: `total=$(( a + b ))`
- **Spaces around `=` in the assignment.** The shell then looks for a command named `total`.
  - Wrong: `total = $(( a + b ))`
  - Right: `total=$(( a + b ))`
- **Feeding it decimals.** Bash arithmetic is integer only.
  - Wrong: `./solution.sh 1.5 2` fails with a syntax error
  - Right: pass whole numbers here; decimals need another tool (later level)
