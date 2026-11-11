# Common Mistakes

- **Mixing up the direction.** `a -nt b` reads "a is newer than b". Putting the files in the wrong order inverts the answer.
  - Wrong: `[[ $backup -nt $source_file ]]` to detect a stale backup
  - Right: `[[ $source_file -nt $backup ]]`
- **Treating "equal" as stale.** If both files have the same mtime, neither `-nt` nor `-ot` is true.
  - Wrong: `if [[ $a -ot $b ]] ... else echo "stale"` when equal should be fresh
  - Right: decide deliberately which side gets the equal case, as the else branch does here
- **Adding an unnecessary existence check.** `-nt` already handles a missing second file.
  - Wrong: `if [[ ! -e $backup ]] || [[ $source_file -nt $backup ]]` (works, but redundant)
  - Right: `if [[ $source_file -nt $backup ]]`
- **Trusting mtime after a plain `cp`.** The copy gets the current time, so it looks new even if the data is old.
  - Wrong: comparing against a copy made without `cp -p`
  - Right: compare against the real backup file, or preserve times when copying
