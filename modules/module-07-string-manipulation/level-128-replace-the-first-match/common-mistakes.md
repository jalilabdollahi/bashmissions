# Common Mistakes

- **Expecting all matches to change.** `${list/eel/marlin}` replaces only the
  first `eel`. For every match you need two slashes (next level).
- **Leaving the search term unquoted.** `${list/$old/$new}` with `old='db[1]'`
  treats the brackets as a character class and misses the text. Write
  `${list/"$old"/$new}`.
- **Searching in the wrong order.** The pattern comes first, the replacement
  second: `${list/eel/marlin}` swaps eel for marlin, not the other way round.
- **Thinking it edits in place.** The expansion produces a new value; assign it
  (`list=${list/eel/marlin}`) if you want to keep it.
