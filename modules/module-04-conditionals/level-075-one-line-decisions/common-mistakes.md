# Common Mistakes

- **Using `A && B || C` when B can fail.** C then runs after B's failure, too.
  - Wrong: `[[ $sev == critical ]] && notify page-oncall || echo "logged: $sev"`
  - Right: `... && { notify page-oncall || echo "pager failed" >&2; } || echo "logged: $sev"`, or a real `if`
- **Forgetting the semicolon before `}`.** Braces group commands, and the last command inside must be terminated.
  - Wrong: `{ notify page-oncall || echo "pager failed" >&2 }`
  - Right: `{ notify page-oncall || echo "pager failed" >&2; }`
- **No space after `{`.** `{` is a keyword, not punctuation.
  - Wrong: `&&{ notify page-oncall; }`
  - Right: `&& { notify page-oncall; }`
- **Swapping `&&` and `||`.** `A || B && C` is a different program: B runs if A fails, and C runs if that chain succeeds.
  - Wrong: `[[ $sev == critical ]] || notify page-oncall && echo "logged: $sev"`
  - Right: `[[ $sev == critical ]] && ... || ...`
