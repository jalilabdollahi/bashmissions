# Common Mistakes

- **Missing the space or the semicolon.** `{` is a reserved word, not punctuation.
  - Wrong: `{echo hi; echo there;}` or `{ echo hi; echo there }`
  - Right: `{ echo hi; echo there; }`
- **Using parentheses for the error exit.** The subshell leaves only itself.
  - Wrong: `[[ -r $f ]] || ( echo "bad" >&2; exit 1 )` (the script goes on)
  - Right: `[[ -r $f ]] || { echo "bad" >&2; exit 1; }`
- **Redirecting each line.** `>` on every command overwrites the file again and again, `>>` depends on its starting state.
  - Wrong: `echo a > r.txt; echo b > r.txt`
  - Right: `{ echo a; echo b; } > r.txt`
- **Forgetting that the group's stdout is redirected.** A message you want on screen inside the group goes into the file.
  - Right: send it to stderr with `>&2`, as in the error branch.
- **Assuming variables set inside `{ } | cmd` survive.** A group on one side of a pipe runs in a subshell.
