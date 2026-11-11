# Common Mistakes

- **Forgetting the `;` or newline before the closing brace.**
  - Wrong: `{ echo a; echo b }  > out` (the brace is just an argument to echo)
  - Right: `{ echo a; echo b; } > out`
- **No space after the opening brace.**
  - Wrong: `{echo a; } > out`
  - Right: `{ echo a; } > out`
- **Redirecting inside and outside.** The inner `>` steals the output from the group's file.
  - Wrong: `{ echo a > x; echo b; } > out` (only b reaches out)
  - Right: no redirection on the inner commands unless you mean it
- **Using parentheses and expecting variables to survive.** A `( ... )` group runs in a subshell.
  - Wrong: `( count=5 ) > out; echo "$count"` prints an empty line
  - Right: `{ count=5; } > out`
