# Common Mistakes

- **Using -s when you mean -d.** `tr -s '\r'` squeezes runs of carriage returns into one; it does not remove it. Delete with `tr -d '\r'`.
- **Squeezing everything.** `tr -s '[:space:]'` also squeezes newlines, so blank lines vanish and paragraphs run together. Name only the space: `tr -s ' '`.
- **Trying to delete a word.** `tr -d 'foo'` removes every `f` and `o`, so `food` becomes `d`. Characters only; use sed for strings.
- **Forgetting that tr reads only standard input.** `tr -d '\r' export.csv` is an error. Right: `tr -d '\r' < export.csv > clean.csv`.
- **Cleaning into the same file.** `tr -d '\r' < f > f` truncates `f` before tr can read it. Write a new file and `mv` it over the old one.
