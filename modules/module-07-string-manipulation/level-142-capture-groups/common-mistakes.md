# Common Mistakes

- **Reading the array after a failed match.** Without the `if`, a non-matching line
  leaves the previous line's groups in `BASH_REMATCH` and you print stale data.
  Use the groups only inside the matching branch.
- **Off-by-one group numbers.** Group 0 is the whole match, so the method is
  `${BASH_REMATCH[1]}`, not `[0]`. Numbering follows the opening parentheses.
- **Capturing too much.** `(.*)` is greedy and swallows the rest of the line. Be
  specific: `([^ ]+)` stops at the first space.
- **Forgetting that the match is not anchored.** The regex may match in the middle
  of a line. Add `^` or `$` when the whole line has to fit, as in the previous level.
- **Quoting the regex.** `[[ $line =~ "$re" ]]` makes the regex literal text. Keep it
  unquoted, in a variable.
