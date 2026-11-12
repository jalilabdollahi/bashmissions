# Common Mistakes

- **Unquoted pattern.** `find "$dir" -name $pat` lets the shell expand `*.tmp` in the current folder; if a match exists, find gets a plain file name and the rule silently matches nothing.
  - Right: `-name "$pat"`
- **`-size +1000` without a unit.** That means more than 1000 blocks of 512 bytes (about half a megabyte).
  - Right: `-size +1000c`
- **Using `-mtime +0` for "any age".** It means "older than a day", so today's files survive.
  - Right: skip the `-mtime` test when the rule says 0.
- **Validating while deleting.** A typo on line 9 is discovered after rules 1 to 8 have already run.
  - Right: a complete first pass, exit before touching any file.
- **Counting freed bytes after `rm`.** The file is gone, so `wc -c` fails.
  - Right: measure first, remove second.
