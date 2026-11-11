# Common Mistakes

- **Leaving the anchors off a validation.**
  Wrong: `[[ $line =~ yes ]]` also matches `yesterday` and `Banner /etc/yes`.
  Right: `[[ $line =~ \ yes$ ]]`.
- **Checking in the wrong order.** If `risky` is tested before `comment`,
  `#PermitRootLogin yes` is labelled risky. Put the most specific or most
  important rule first.
- **Expecting `^` to mean "not".** Outside square brackets `^` is only the
  start-of-line anchor. Putting it in the middle, as in `a^b`, never matches
  ordinary text.
- **Testing for an empty line with a pattern of nothing.** `[[ $line =~ "" ]]`
  matches every string. Use `^$` to mean "empty".
- **A trailing space or carriage return.** `yes$` fails on `yes ` or on a line
  copied from Windows that ends in `\r`. If a rule "should match but doesn't",
  print the line with `printf '%q\n' "$line"` to see hidden characters.
