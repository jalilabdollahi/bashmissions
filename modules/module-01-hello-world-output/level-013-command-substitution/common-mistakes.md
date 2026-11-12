# Common Mistakes

- **Using parentheses without the dollar.** Without `$` it is not a substitution.
  Wrong: `echo "Oldest: (head -n 1 fixtures/queue.txt)"`
  Right: `echo "Oldest: $(head -n 1 fixtures/queue.txt)"`
- **Single quotes around the whole text.** Nothing is run; you get the characters.
  Wrong: `echo 'Oldest: $(head -n 1 fixtures/queue.txt)'`
  Right: `echo "Oldest: $(head -n 1 fixtures/queue.txt)"`
- **Printing the labels separately.** `echo "Oldest:"; head -n 1 file` puts the ticket on the next line instead of the same line.
- **Misspelling the path.** A wrong file name gives an error from head and an empty result in the text.
