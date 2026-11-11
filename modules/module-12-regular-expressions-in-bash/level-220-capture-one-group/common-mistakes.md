# Common Mistakes

- **Reading `BASH_REMATCH` after a failed match.** Without the `if`, a line like
  `session opened for user tom` would print the *previous* line's username.
- **Starting at 0.** `${BASH_REMATCH[0]}` is the whole matched text
  (`Failed password for root from `), not the username. The first group is `[1]`.
- **Capturing with a greedy dot.** `Failed password for (.*) from ` swallows
  `invalid user admin` too, and with a longer line it could run past the first
  " from ". Describe the word: `([^ ]+)`.
- **Forgetting the parentheses.** `Failed password for [^ ]+ from ` matches just
  fine but captures nothing, so `BASH_REMATCH[1]` is empty.
- **Quoting the regex.** `[[ $line =~ "Failed password for ([^ ]+) from " ]]` treats
  the quoted text literally: the brackets and plus are no longer special.
