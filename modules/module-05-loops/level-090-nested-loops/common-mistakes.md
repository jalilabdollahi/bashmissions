# Common Mistakes

- **Reusing the same loop variable.** The inner loop overwrites the outer counter and the outer loop loses its place.
  Wrong: `for (( i=1; i<=servers; i++ )); do for (( i=1; i<=months; i++ ))`
  Right: use different names, such as `s` and `m`
- **Newline in the wrong place.** Inside the inner loop it prints every cell on its own line; after the outer loop it prints a single line break at the very end.
  Right: `printf '\n'` after the inner `done`, inside the outer loop
- **Row label printed inside the inner loop.** It repeats before every cell.
  Right: print it before the inner loop starts
- **Forgetting `done` twice.** Each loop needs its own `done`. A missing one gives "unexpected end of file".
- **Using `echo` for cells.** `echo` always ends the line. Use `printf` without `\n` or `echo -n` for in-line pieces.
