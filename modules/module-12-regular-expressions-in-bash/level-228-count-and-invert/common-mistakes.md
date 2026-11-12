# Common Mistakes

- **Letting `grep -c` kill the script.**
  Wrong: `n=$(grep -c failed log)` under `set -e` when there are no matches.
  Right: `n=$(grep -c failed log || true)`.
- **Counting before filtering.** `grep -c 'Failed password' "$log"` counts the
  commented-out example too. Filter the comments, then count.
- **Reading `-c` as "count matches".** It counts matching *lines*. A line with two
  failures counts once. For matches use `grep -o ... | wc -l`.
- **Using `wc -l` and printing the raw result.** On macOS `wc -l` pads with
  spaces (`"       3"`), which breaks exact comparisons. `grep -c` is clean.
- **Writing `grep -v ^#`.** Unquoted `#` starts a shell comment only after a space,
  but `^(#|$)` has parentheses, so always put the regex in single quotes.
