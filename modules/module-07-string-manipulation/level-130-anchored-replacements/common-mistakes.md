# Common Mistakes

- **Forgetting the anchor.** `${path/legacy/lanternfish}` rewrites the first
  `legacy` wherever it is, including in `/backup/var/log/legacy/db.txt`. Use
  `${path/#/var/log/legacy/...}` style start anchoring.
- **Swapping the anchors.** `${path/%/var/log/legacy/...}` asks for a path that
  ENDS with the directory, so nothing happens. `#` = start, `%` = end.
- **Unescaped slashes.** `${path/#/var/log/legacy//var/log/lanternfish/}` is
  parsed at the wrong slash. Escape them (`\/`) or use variables with
  `${path/#"$old"/$new}`.
- **Replacing with `//` and an anchor.** There is no `//#`. Anchored forms replace
  at most one place, because only one start and one end exist.
