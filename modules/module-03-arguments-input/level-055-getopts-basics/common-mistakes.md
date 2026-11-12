# Common Mistakes

- **Forgetting the colon.** `getopts "vn"` treats `-n` as a switch, so
  `$OPTARG` is empty and `-n 2` leaves the `2` behind. Right: `getopts "vn:"`.
- **Putting the colon on the wrong letter.** `getopts "v:n"` makes `-v` expect a
  value. The colon goes right after the letter that takes one.
- **Using `$1` for the value.** Inside the loop, `-n 2` has the number in
  `$OPTARG`, not in `$1`. `getopts` does not shift for you.
- **Parsing before setting defaults.** Without `count=3` before the loop, running
  with no `-n` leaves `count` unset and `set -u` aborts the script.
