# Common Mistakes

- **Forgetting `-type f`.** Folders have a size too and show up as "big files".
  - Wrong: `find "$folder" -size +20c`
  - Right: `find "$folder" -type f -size +20c`
- **Leaving out the unit.** The default unit is 512-byte blocks.
  - Wrong: `find "$folder" -type f -size +20` (more than 20 blocks, about 10 KB)
  - Right: `find "$folder" -type f -size +20c`
- **Mixing up the signs.** `+` is "more than", `-` is "less than", no sign is "exactly".
  - Wrong: `-size 20c` when you wanted "at least 20 bytes"
  - Right: `-size +19c` for "at least 20", or `-size +20c` for "more than 20"
- **Counting the starting folder.** `find DIR -type d` includes DIR.
  - Wrong: `dirs=$(find "$folder" -type d | wc -l)` reports one too many
  - Right: subtract one, or test `! -path "$folder"`
- **Putting the size in a bare variable.** `-size +$bytesc` is read as a variable named `bytesc`.
  - Wrong: `-size +$bytesc`
  - Right: `-size +"${bytes}"c`
