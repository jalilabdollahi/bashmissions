# Common Mistakes for Uppercase All

- Forgetting that Bash substring offsets are zero-based.
- Mixing up shortest and longest prefix/suffix removal (`#` vs `##`, `%` vs `%%`).
- Quoting glob patterns inside `[[ ]]` when pattern matching is intended.
- Using external commands when Bash parameter expansion can do the string operation directly.
