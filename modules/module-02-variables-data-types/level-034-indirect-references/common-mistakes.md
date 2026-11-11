# Common Mistakes

- **Expanding the name instead of following it.**
  Wrong: `echo "$quota_var"` prints `LIMIT_bakery`.
  Right: `echo "${!quota_var}"` prints `50`.
- **Putting the dollar sign inside the name.**
  Wrong: `quota_var='$LIMIT_bakery'` stores text with a dollar sign and the lookup fails.
  Right: `quota_var=LIMIT_bakery` - just the name, no dollar.
- **Forgetting that braces are required.**
  `$!quota_var` is not indirection; it means the PID of the last background job followed by text.
  Right: `${!quota_var}`.
- **Trusting any name.** Indirect lookup of a name that came from a user can expose unrelated variables. Build the name from a fixed prefix, as done here.
