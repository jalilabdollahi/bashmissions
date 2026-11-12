# Common Mistakes

- **Giving tr a file name.** `tr 'a-z' 'A-Z' names.txt` fails: tr reads only standard input. Right: `tr 'a-z' 'A-Z' < names.txt`.
- **Sets of different length by accident.** `tr 'a-z.-' 'A-Z_'` maps the dot to `_` but the dash is left unchanged on some systems and mapped on others. Make the second set as long as the first.
- **A dash in the middle of a set.** `tr 'a-z-.' ...` can be read as a range from `z` to `.`. Put the dash first or last.
- **Treating it as a word replacer.** `tr 'cat' 'dog'` swaps the characters c, a, t for d, o, g everywhere, so `tractor` becomes `drogdor`. Use sed for words.
- **Forgetting quotes.** An unquoted `tr a-z A-Z` is fine until a file named `a` or `b` matches the glob. Quote the sets: `tr 'a-z' 'A-Z'`.
