# Common Mistakes

- **Forgetting the `+` in `-mtime`.** Without a sign it means "exactly N days old".
  - Wrong: `find "$folder" -type f -mtime 30`
  - Right: `find "$folder" -type f -mtime +30`
- **Expecting `+30` to mean "30 days or more".** The fraction of a day is dropped, so it means "at least 31 days".
  - Wrong: assuming a 30.5-day-old file is listed by `-mtime +30`
  - Right: use `-mtime +29` for "30 days or more", or compare with `-newer` against a reference file
- **Comparing against the wrong file.** `-newer A` is about A's mtime, not "newer than the folder".
  - Wrong: `-newer "$folder"` (a folder's mtime changes whenever its entries do)
  - Right: `-newer "$folder/.last-backup"`
- **Listing the marker with the rest.** Its own timestamp makes it appear as "old".
  - Wrong: `find "$folder" -type f -mtime +30` with the marker inside
  - Right: add `! -name .last-backup`
- **Printing an empty list as a line.** `echo "$old"` of an empty variable prints a blank line.
  - Wrong: `echo "$old" | wc -l` as the count (gives 1 when nothing was found)
  - Right: test `[[ -n $old ]]` first
