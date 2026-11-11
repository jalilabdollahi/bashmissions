# Common Mistakes

- **Fixing the caller.** Renaming `count` in the main loop hides this bug but
  leaves a trap for the next function. Fix the function: `local n=${#1}`.
- **Making `bar` local too.** Then the main loop sees an empty `$bar` and prints
  lines with no hashes. The intended output variable must stay global.
- **Declaring local after use.** `count=${#1}; local count` is too late; the global
  was already overwritten. Declare first: `local count=${#1}`.
- **Assuming a subshell protects you.** Calling `bar=$(make_bar x)` would be safe
  but changes the design. A plain call, as in this script, shares the namespace.
- **Not testing with more than one item.** With one site the bug is invisible:
  the first number is 1 anyway. Always test with two or more.
