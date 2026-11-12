# Common Mistakes

- **Parsing `ls` output with spaces and surprises.** `for f in $(ls dir)` breaks on odd names and, without a glob, re-sorts however `ls` likes.
  - Right: `archives=("$dir"/*.tar.gz)`
- **No `nullglob`.** In an empty folder the array holds the literal string `backups/*.tar.gz`, and the script "deletes" a file that does not exist.
  - Right: `shopt -s nullglob` before the glob.
- **Off-by-one on "newest 7".** Using `i > total-7` keeps only six.
  - Right: indexes `>= total-7` are the newest seven.
- **Deleting in dry-run mode.** Printing "would delete" but still calling `rm` ruins the only safe preview.
  - Right: put `rm` inside the `else` of `if (( dry ))`.
- **Counting the dry-run summary like a real run.** The last line must say `would delete`, not `deleted`.
