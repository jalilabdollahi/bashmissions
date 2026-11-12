# Common Mistakes

- **Moving instead of copying.** `mv` changes the original's location and inode metadata, and a failed move can lose the only copy. Always `cp -p` and leave the source alone.
- **Locking before the checksum comparison, or never.** If the copy stays writable, `verify` can say OK while the file is changing. Compare first, then `chmod 0444`.
- **Splitting the manifest on spaces.** `read -r name sum size orig` is right; `awk '{print $4}'` truncates a path like `notes today.txt`.
- **Hashing with a trailing filename.** `cksum file` prints the name as well, so comparisons against "SUM SIZE" fail. Use `cksum < file`.
- **Creating the case folder before validating.** A run that collects nothing still leaves an official-looking empty case. Filter the sources first.
- **Trusting the manifest alone.** An attacker who edits a file can edit the manifest line too. The seal over the manifest is what makes that detectable.
- **Overwriting the custody log with `>`.** The log is a record; only append with `>>`.
